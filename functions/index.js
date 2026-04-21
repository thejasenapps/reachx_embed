const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

const db = admin.firestore();

const REACHX_ADMIN_EMAIL = "admin@reachx.pro";
const WHATSAPP_URL = "https://app.reachx.pro/api/send.php";
const EMAIL_URL = "https://app.reachx.pro/api/email-sender-test.php";

// ─── Shared Helpers ──────────────────────────────────────────────────────────

async function sendWhatsApp(number, template, parameters) {
  try {
    const response = await axios.post(
      WHATSAPP_URL,
      { channel: "whatsapp", number, template, parameters },
      { headers: { "Content-Type": "application/json" } }
    );
    console.log(`✅ WhatsApp sent to ${number}:`, response.data);
  } catch (err) {
    console.error(`❌ WhatsApp failed for ${number}:`, err.response?.data || err.message);
  }
}

async function sendEmail(fields) {
  try {
    const formData = new URLSearchParams(fields).toString();
    const response = await axios.post(EMAIL_URL, formData, {
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
    });
    console.log(`📧 Email sent [event=${fields.event}]:`, response.data);
  } catch (err) {
    console.error(`❌ Email failed [event=${fields.event}]:`, err.response?.data || err.message);
  }
}

// ─── Institution Approval Trigger ────────────────────────────────────────────

exports.onInstitutionApproved = onDocumentWritten(
  "institution_subscription/{docId}",
  {
    region: "asia-south1",
  },
  async (event) => {
    const before = event.data.before?.data();
    const after  = event.data.after?.data();

    if (!after || after.status !== "approved") return null;
    if (before?.status === "approved") return null;

    const website = after.website ?? after.domainUrl ?? "";
    if (!website) {
      console.warn(`⚠️  institution_subscription/${event.params.docId} has no website/domainUrl, skipping`);
      return null;
    }

    console.log(`✅ Institution approved: ${event.params.docId} | website: ${website}`);

    const institutionsRef = db.collection("institutions");

    const existing = await institutionsRef.where("domainUrl", "==", website).get();
    if (!existing.empty) {
      const deletions = existing.docs.map((doc) => {
        console.log(`🗑️  Deleting existing institution doc: ${doc.id}`);
        return doc.ref.delete();
      });
      await Promise.all(deletions);
    }

    const newId = institutionsRef.doc().id;
    const institutionData = {
      id: newId,
      name: after.name ?? "Institution",
      logo: after.logo ?? "",
      subscriptionStatus: true,
      subscriptionId: event.params.docId,
      domainUrl: website,
      startDate: after.startDate ?? admin.firestore.FieldValue.serverTimestamp(),
      trialLimit: after.trialLimit ?? 7,
    };

    await institutionsRef.doc(newId).set(institutionData);
    console.log(`🏛️  New institution created: ${newId}`);

    return null;
  }
);

// ─── Trial & Subscription Check (every 12 hours) ─────────────────────────────

exports.checkTrialAndSubscription = onSchedule("every 12 hours", async () => {
  console.log("🔄 Running free trial check...");
  await checkFreeTrials();
  console.log("✅ Free trial check complete.");

  console.log("🔄 Running subscription notification check...");
  await checkSubscriptions();
  console.log("✅ Subscription notification check complete.");
});

// ─── Free Trial Check ─────────────────────────────────────────────────────────

async function checkFreeTrials() {
  const snapshot = await db.collection("institutions").get();

  if (snapshot.empty) {
    console.log("ℹ️  No institutions found, skipping.");
    return;
  }

  const now = new Date();
  const tasks = [];
  snapshot.forEach((doc) => {
    if (doc.data().subscriptionStatus === false) tasks.push(handleTrial(doc, now));
  });
  await Promise.all(tasks);
}

async function handleTrial(doc, now) {
  try {
    const data = doc.data();
    const { startDate, trialLimit } = data;

    if (!startDate || trialLimit === undefined || trialLimit === null) {
      console.log(`ℹ️  Skipping ${doc.id} — missing startDate or trialLimit`);
      return;
    }

    const subscriptionId = data.subscriptionId;
    if (!subscriptionId) {
      console.warn(`⚠️  No subscriptionId on institution ${doc.id}, skipping`);
      return;
    }

    const subSnap = await db.collection("institution_subscription").doc(subscriptionId).get();
    if (!subSnap.exists) {
      console.warn(`⚠️  institution_subscription doc "${subscriptionId}" not found for ${doc.id}`);
      return;
    }

    const { email, phone } = subSnap.data();

    const start =
      startDate instanceof admin.firestore.Timestamp
        ? startDate.toDate()
        : new Date(startDate);

    if (isNaN(start.getTime())) {
      console.warn(`⚠️  Invalid startDate for ${doc.id}, skipping`);
      return;
    }

    const trialDays = Number(trialLimit);
    if (isNaN(trialDays) || trialDays <= 0) {
      console.warn(`⚠️  Invalid trialLimit value "${trialLimit}" for ${doc.id}, skipping`);
      return;
    }

    const trialEnd = new Date(start.getTime() + trialDays * 24 * 60 * 60 * 1000);
    const hoursUntilEnd = (trialEnd - now) / (1000 * 60 * 60);
    const isExpired = trialEnd <= now;
    const isOneDayAway = hoursUntilEnd > 0 && hoursUntilEnd <= 24;

    const domain = data.domainUrl || "";
    const institutionEmail = email || "";

    // ── One day before expiry ────────────────────────────────────────────────
    if (isOneDayAway && !data.trialWarningOneDaySent) {
      console.log(`⚠️  Trial ending soon for institution ${doc.id}`);
      const promises = [];

      if (institutionEmail) {
        promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: institutionEmail, domain }));
      } else {
        console.warn(`⚠️  No email for institution ${doc.id}, skipping institution email`);
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "trial_ending_soon", [
          { type: "text", parameter_name: "end_date", text: trialEnd.toDateString() },
        ]));
      }

      promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: REACHX_ADMIN_EMAIL, domain }));

      await Promise.all(promises);
      await doc.ref.set({ trialWarningOneDaySent: true }, { merge: true });
      console.log(`✅ Trial warning sent for ${doc.id}`);
    }

    // ── Trial expired ────────────────────────────────────────────────────────
    if (isExpired && !data.trialExpiredNotificationSent) {
      console.log(`🚫 Trial expired for institution ${doc.id}`);
      const promises = [];

      if (institutionEmail) {
        promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: institutionEmail, domain }));
      } else {
        console.warn(`⚠️  No email for institution ${doc.id}, skipping institution email`);
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "trial_expired", [
          { type: "text", parameter_name: "end_date", text: trialEnd.toDateString() },
        ]));
      }

      promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: REACHX_ADMIN_EMAIL, domain }));

      await Promise.all(promises);
      await doc.ref.set({ trialExpiredNotificationSent: true }, { merge: true });
      console.log(`✅ Trial expiry notification sent for ${doc.id}`);
    }

  } catch (err) {
    console.error(`❌ Error handling trial for ${doc.id}:`, err);
  }
}

// ─── Subscription Check ──────────────────────────────────────────────────────

async function checkSubscriptions() {
  const snapshot = await db.collection("institutions").get();

  if (snapshot.empty) {
    console.log("ℹ️  No institutions found, skipping subscription check.");
    return;
  }

  const now = new Date();
  const tasks = [];
  snapshot.forEach((doc) => tasks.push(handleSubscription(doc, now)));
  await Promise.all(tasks);
}

async function handleSubscription(institutionDoc, now) {
  try {
    const data = institutionDoc.data();

    if (!data.subscriptionStatus) return;

    const subscriptionId = data.subscriptionId;
    if (!subscriptionId) {
      console.warn(`⚠️  No subscriptionId on institution ${institutionDoc.id}, skipping`);
      return;
    }

    const subDocRef = db.collection("institution_subscription").doc(subscriptionId);
    const subDocSnap = await subDocRef.get();
    if (!subDocSnap.exists) {
      console.warn(`⚠️  institution_subscription doc "${subscriptionId}" not found for ${institutionDoc.id}`);
      return;
    }

    const subData = subDocSnap.data();
    const { email, phone, subscriptionEndDate: rawEndDate } = subData;

    if (!rawEndDate) {
      console.log(`ℹ️  Skipping ${institutionDoc.id} — no subscriptionEndDate in sub doc`);
      return;
    }

    const endDate =
      rawEndDate instanceof admin.firestore.Timestamp
        ? rawEndDate.toDate()
        : new Date(rawEndDate);

    if (isNaN(endDate.getTime())) {
      console.warn(`⚠️  Invalid subscriptionEndDate for ${institutionDoc.id}, skipping`);
      return;
    }

    const domain = data.domainUrl || "";
    const institutionEmail = email || "";

    // ── Expiring within 2 days ────────────────────────────────────────────────
    const twoDaysFromNow = new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000);
    const isTwoDaysAway = endDate > now && endDate <= twoDaysFromNow;

    if (isTwoDaysAway && !data.isTwoDaySubSent) {
      console.log(`⚠️  Subscription ending in 2 days for institution ${institutionDoc.id}`);
      const promises = [];

      if (institutionEmail) {
        promises.push(sendEmail({ event: "embed-expiry", id: institutionDoc.id, email: institutionEmail, domain }));
      } else {
        console.warn(`⚠️  No email for institution ${institutionDoc.id}, skipping institution email`);
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "subscription_ending_soon", [
          { type: "text", parameter_name: "end_date", text: endDate.toDateString() },
        ]));
      }

      promises.push(sendEmail({ event: "embed-expiry", id: institutionDoc.id, email: REACHX_ADMIN_EMAIL, domain }));

      await Promise.all(promises);
      await institutionDoc.ref.set({ isTwoDaySubSent: true }, { merge: true });
      console.log(`✅ Two-day subscription warning sent for ${institutionDoc.id}`);
    }

    // ── Subscription expired ──────────────────────────────────────────────────
    const isExpired = endDate <= now;

    if (isExpired && !data.isSubscriptionEndNot) {
      console.log(`🚫 Subscription expired for institution ${institutionDoc.id}`);
      const promises = [];

      if (institutionEmail) {
        promises.push(sendEmail({ event: "embed-expiry", id: institutionDoc.id, email: institutionEmail, domain }));
      } else {
        console.warn(`⚠️  No email for institution ${institutionDoc.id}, skipping institution email`);
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "subscription_expired", [
          { type: "text", parameter_name: "end_date", text: endDate.toDateString() },
        ]));
      }

      promises.push(sendEmail({ event: "embed-expiry", id: institutionDoc.id, email: REACHX_ADMIN_EMAIL, domain }));

      await Promise.all(promises);

      await institutionDoc.ref.set(
        { subscriptionStatus: false, startDate: "", isSubscriptionEndNot: true },
        { merge: true }
      );

      const { subscriptionStartDate, subscriptionAmount, subscriptionEndDate } = subData;
      const historyEntry = [
        `Start: ${subscriptionStartDate ?? ""}`,
        `Amount: ${subscriptionAmount ?? ""}`,
        `End: ${subscriptionEndDate ?? ""}`,
      ].join(" | ");

      await subDocRef.set(
        {
          subscriptionHistory: admin.firestore.FieldValue.arrayUnion(historyEntry),
          subscriptionStartDate: "",
          subscriptionAmount: "",
          subscriptionEndDate: "",
        },
        { merge: true }
      );

      console.log(`📦 Archived subscription for ${institutionDoc.id}: "${historyEntry}"`);
      console.log(`✅ Subscription expired and reset for ${institutionDoc.id}`);
    }

  } catch (err) {
    console.error(`❌ Error handling subscription for ${institutionDoc.id}:`, err);
  }
}
