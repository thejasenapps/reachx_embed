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

// Resolves a Firestore Timestamp, ISO string, or Date to a JS Date.
// Returns null if the value is missing or invalid.
function toDate(value) {
  if (!value) return null;
  if (value instanceof admin.firestore.Timestamp) return value.toDate();
  const d = new Date(value);
  return isNaN(d.getTime()) ? null : d;
}

// ─── Institution Approval Trigger ────────────────────────────────────────────
// Fires when a document in `institutions` is written.
// If `subscriptionStatus` flips to true, delete any duplicate doc with the
// same domainUrl and keep only this one.

exports.onInstitutionApproved = onDocumentWritten(
  "institutions/{docId}",
  async (event) => {
    const before = event.data.before?.data();
    const after  = event.data.after?.data();

    if (!after) return null;
    // Only act when subscriptionStatus transitions TO true
    if (!after.subscriptionStatus) return null;
    if (before?.subscriptionStatus === true) return null;

    const domainUrl = after.domainUrl ?? "";
    if (!domainUrl) {
      console.warn(`⚠️  institutions/${event.params.docId} has no domainUrl, skipping dedup`);
      return null;
    }

    console.log(`✅ Institution approved: ${event.params.docId} | domainUrl: ${domainUrl}`);

    // Delete any OTHER institution doc with the same domainUrl
    const duplicates = await db.collection("institutions")
      .where("domainUrl", "==", domainUrl)
      .get();

    const deletions = duplicates.docs
      .filter((doc) => doc.id !== event.params.docId)
      .map((doc) => {
        console.log(`�️  Deleting duplicate institution doc: ${doc.id}`);
        return doc.ref.delete();
      });

    await Promise.all(deletions);
    return null;
  }
);

// ─── Trial & Subscription Check (every 12 hours) ─────────────────────────────

exports.checkTrialAndSubscription = onSchedule("every 12 hours", async () => {
  console.log("🔄 Running trial & subscription check...");
  await Promise.all([checkFreeTrials(), checkSubscriptions()]);
  console.log("✅ Check complete.");
});

// ─── Free Trial Check ─────────────────────────────────────────────────────────
// Targets institutions where subscriptionStatus === false (still on trial).
// Uses subscriptionStartDate + trialLimit (days) to compute trial end.

async function checkFreeTrials() {
  const snapshot = await db.collection("institutions")
    .where("subscriptionStatus", "==", false)
    .get();

  if (snapshot.empty) {
    console.log("ℹ️  No trial institutions found, skipping.");
    return;
  }

  const now = new Date();
  await Promise.all(snapshot.docs.map((doc) => handleTrial(doc, now)));
}

async function handleTrial(doc, now) {
  try {
    const data = doc.data();
    const { subscriptionStartDate: rawStart, trialLimit, email, phone, domainUrl } = data;

    if (!rawStart || trialLimit === undefined || trialLimit === null) {
      console.log(`ℹ️  Skipping ${doc.id} — missing subscriptionStartDate or trialLimit`);
      return;
    }

    const start = toDate(rawStart);
    if (!start) {
      console.warn(`⚠️  Invalid subscriptionStartDate for ${doc.id}, skipping`);
      return;
    }

    const trialDays = Number(trialLimit);
    if (isNaN(trialDays) || trialDays <= 0) {
      console.warn(`⚠️  Invalid trialLimit "${trialLimit}" for ${doc.id}, skipping`);
      return;
    }

    const trialEnd = new Date(start.getTime() + trialDays * 24 * 60 * 60 * 1000);
    const hoursUntilEnd = (trialEnd - now) / (1000 * 60 * 60);
    const isExpired = trialEnd <= now;
    const isOneDayAway = hoursUntilEnd > 0 && hoursUntilEnd <= 24;

    const domain = domainUrl || "";
    const institutionEmail = email || "";

    // ── One day before expiry ────────────────────────────────────────────────
    if (isOneDayAway && !data.trialWarningOneDaySent) {
      console.log(`⚠️  Trial ending soon for institution ${doc.id}`);
      const promises = [];

      if (institutionEmail) {
        promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: institutionEmail, domain }));
      } else {
        console.warn(`⚠️  No email on institution ${doc.id}, skipping institution email`);
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "trial_ending_soon", [
          { type: "text", parameter_name: "end_date", text: trialEnd.toDateString() },
        ]));
      }

      // Admin alert — always sent
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
        console.warn(`⚠️  No email on institution ${doc.id}, skipping institution email`);
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
// Targets institutions where subscriptionStatus === true.
// Uses subscriptionEndDate directly from the institution doc.

async function checkSubscriptions() {
  const snapshot = await db.collection("institutions")
    .where("subscriptionStatus", "==", true)
    .get();

  if (snapshot.empty) {
    console.log("ℹ️  No active subscriptions found, skipping.");
    return;
  }

  const now = new Date();
  await Promise.all(snapshot.docs.map((doc) => handleSubscription(doc, now)));
}

async function handleSubscription(doc, now) {
  try {
    const data = doc.data();
    const { subscriptionEndDate: rawEnd, email, phone, domainUrl } = data;

    if (!rawEnd) {
      console.log(`ℹ️  Skipping ${doc.id} — no subscriptionEndDate`);
      return;
    }

    const endDate = toDate(rawEnd);
    if (!endDate) {
      console.warn(`⚠️  Invalid subscriptionEndDate for ${doc.id}, skipping`);
      return;
    }

    const domain = domainUrl || "";
    const institutionEmail = email || "";

    // ── Expiring within 2 days ────────────────────────────────────────────────
    const twoDaysFromNow = new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000);
    const isTwoDaysAway = endDate > now && endDate <= twoDaysFromNow;

    if (isTwoDaysAway && !data.isTwoDaySubSent) {
      console.log(`⚠️  Subscription ending in 2 days for institution ${doc.id}`);
      const promises = [];

      if (institutionEmail) {
        promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: institutionEmail, domain }));
      } else {
        console.warn(`⚠️  No email on institution ${doc.id}, skipping institution email`);
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "subscription_ending_soon", [
          { type: "text", parameter_name: "end_date", text: endDate.toDateString() },
        ]));
      }

      promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: REACHX_ADMIN_EMAIL, domain }));

      await Promise.all(promises);
      await doc.ref.set({ isTwoDaySubSent: true }, { merge: true });
      console.log(`✅ Two-day subscription warning sent for ${doc.id}`);
    }

    // ── Subscription expired ──────────────────────────────────────────────────
    const isExpired = endDate <= now;

    if (isExpired && !data.isSubscriptionEndNot) {
      console.log(`🚫 Subscription expired for institution ${doc.id}`);
      const promises = [];

      if (institutionEmail) {
        promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: institutionEmail, domain }));
      } else {
        console.warn(`⚠️  No email on institution ${doc.id}, skipping institution email`);
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "subscription_expired", [
          { type: "text", parameter_name: "end_date", text: endDate.toDateString() },
        ]));
      }

      promises.push(sendEmail({ event: "embed-expiry", id: doc.id, email: REACHX_ADMIN_EMAIL, domain }));

      await Promise.all(promises);

      // Archive current subscription period into subscriptionHistory
      const historyEntry = [
        `Start: ${data.subscriptionStartDate ?? ""}`,
        `Amount: ${data.subscriptionAmount ?? ""}`,
        `End: ${data.subscriptionEndDate ?? ""}`,
      ].join(" | ");

      await doc.ref.set(
        {
          subscriptionStatus: false,
          subscriptionStartDate: null,
          subscriptionEndDate: null,
          subscriptionAmount: null,
          isSubscriptionEndNot: true,
          subscriptionHistory: admin.firestore.FieldValue.arrayUnion(historyEntry),
        },
        { merge: true }
      );

      console.log(`📦 Archived & reset subscription for ${doc.id}: "${historyEntry}"`);
    }

  } catch (err) {
    console.error(`❌ Error handling subscription for ${doc.id}:`, err);
  }
}
