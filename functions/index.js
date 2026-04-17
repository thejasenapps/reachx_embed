const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

const sentFiveMinNumbers = new Set();
const sentOneHourNumbers = new Set();

// ─── Existing: Upcoming Meetings ─────────────────────────────────────────────

exports.checkUpcomingMeetings = onSchedule("every 1 minutes", async (event) => {
  try {
    console.log("🔄 Starting notification check...");
    const now = new Date();
    const fiveMinutesFromNow = new Date(now.getTime() + 5 * 60 * 1000);
    const fiftyMinutesFromNow = new Date(now.getTime() + 50 * 60 * 1000);
    const oneHourFromNow = new Date(now.getTime() + 60 * 60 * 1000);

    const snapshot = await admin.firestore().collection("booking").get();
    const upcoming5min = [];
    const upcoming1hr = [];

    snapshot.forEach((doc) => {
      const booking = doc.data();
      const startTime = booking.start ? new Date(booking.start) : null;
      if (!startTime) return;

      if (
        (booking.notificationSent === false || booking.notificationSent === undefined) &&
        startTime >= now && startTime <= fiveMinutesFromNow
      ) {
        upcoming5min.push({ id: doc.id, ref: doc.ref, data: booking });
      }

      if (
        (booking.notificationSentInOneHour === false || booking.notificationSentInOneHour === undefined) &&
        startTime >= fiftyMinutesFromNow && startTime <= oneHourFromNow
      ) {
        upcoming1hr.push({ id: doc.id, ref: doc.ref, data: booking });
      }
    });

    console.log(`🕔 Found ${upcoming5min.length} bookings within 5 minutes`);
    console.log(`🕐 Found ${upcoming1hr.length} bookings within 1 hour`);

    const allTasks = [
      ...upcoming5min.map((b) => handleMeetingNotification(b, "5min")),
      ...upcoming1hr.map((b) => handleMeetingNotification(b, "1hr")),
    ];
    await Promise.all(allTasks);

    console.log("✅ Notification check completed");
    return null;
  } catch (error) {
    console.error("💥 Error in checkUpcomingMeetings:", error);
    throw error;
  }
});

async function handleMeetingNotification(bookingItem, type) {
  try {
    const promises = [];
    const booking = bookingItem.data;
    const { attendeeId, expertId } = booking;
    const eventName = booking.eventName || "your appointment";

    if (!attendeeId || !expertId) return;

    const [attendeeDoc, expertDoc] = await Promise.all([
      admin.firestore().collection("users").doc(attendeeId).get(),
      admin.firestore().collection("users").doc(expertId).get(),
    ]);

    if (!attendeeDoc.exists || !expertDoc.exists) return;

    const attendeeData = attendeeDoc.data();
    const expertData = expertDoc.data();
    const timeLeftText = type === "5min" ? "5 minutes" : "1 hour";

    const tokens = [];
    if (attendeeData.fcmToken) tokens.push(attendeeData.fcmToken);
    if (expertData.fcmToken) tokens.push(expertData.fcmToken);

    if (tokens.length > 0) {
      promises.push(
        admin.messaging().sendEachForMulticast({
          tokens,
          notification: {
            title: "ReachX Reminder",
            body: `Your appointment for ${eventName} starts in ${timeLeftText}!`,
          },
          data: { bookingId: bookingItem.id, type: "appointment_reminder" },
        })
      );
    }

    const whatsappParams = [
      { type: "text", parameter_name: "topic", text: eventName },
      { type: "text", parameter_name: "time_left", text: timeLeftText },
      { type: "text", parameter_name: "date", text: booking.start || "TBD" },
      { type: "text", parameter_name: "country_code", text: "IST" },
      { type: "text", parameter_name: "mode", text: "Online" },
    ];

    if (attendeeData.phone) {
      promises.push(sendWhatsApp(attendeeData.phone, "meeting_reminder", whatsappParams));
    }

    if (expertData.phone) {
      const setToUse = type === "5min" ? sentFiveMinNumbers : sentOneHourNumbers;
      if (!setToUse.has(expertData.phone)) {
        setToUse.add(expertData.phone);
        promises.push(sendWhatsApp(expertData.phone, "meeting_reminder", whatsappParams));
      }
    }

    await Promise.all(promises);

    const updateData = type === "5min" ? { notificationSent: true } : { notificationSentInOneHour: true };
    await bookingItem.ref.set(updateData, { merge: true });
  } catch (error) {
    console.error(`❌ Error processing booking ${bookingItem.id}:`, error);
  }
}

const db = admin.firestore();

const REACHX_ADMIN_EMAIL = "admin@reachx.pro";
const WHATSAPP_URL = "https://app.reachx.pro/api/send.php";
const EMAIL_URL = "https://app.reachx.pro/api/email-sender.php";

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

// Mirrors the project's EmailNotificationService — posts multipart/form-data
// with an "event" key plus any extra fields, matching how the Flutter app calls it.
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

// ─── Main Scheduled Function ─────────────────────────────────────────────────

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
    if (doc.data().subScriptionStatus === false) tasks.push(handleTrial(doc, now));
  });
  await Promise.all(tasks);
}

async function handleTrial(doc, now) {
  try {
    const data = doc.data();
    const { startDate, trialLimit } = data;

    // Skip docs missing required trial fields
    if (!startDate || trialLimit === undefined || trialLimit === null) {
      console.log(`ℹ️  Skipping ${doc.id} — missing startDate or trialLimit`);
      return;
    }

    // Fetch email & phone from the linked institution_subscription doc
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

    // startDate can be a Firestore Timestamp or ISO string
    const start =
      startDate instanceof admin.firestore.Timestamp
        ? startDate.toDate()
        : new Date(startDate);

    if (isNaN(start.getTime())) {
      console.warn(`⚠️  Invalid startDate for ${doc.id}, skipping`);
      return;
    }

    // trialLimit is an integer number of days (e.g. 7)
    const trialDays = Number(trialLimit);
    if (isNaN(trialDays) || trialDays <= 0) {
      console.warn(`⚠️  Invalid trialLimit value "${trialLimit}" for ${doc.id}, skipping`);
      return;
    }

    const trialEnd = new Date(start.getTime() + trialDays * 24 * 60 * 60 * 1000);

    const hoursUntilEnd = (trialEnd - now) / (1000 * 60 * 60);
    const isExpired = trialEnd <= now;
    const isOneDayAway = hoursUntilEnd > 0 && hoursUntilEnd <= 24;

    // ── One day before expiry ────────────────────────────────────────────────
    if (isOneDayAway && !data.trialWarningOneDaySent) {
      console.log(`⚠️  Trial ending soon for institution ${doc.id}`);
      const promises = [];

      if (email) {
        promises.push(sendEmail({
          event: "trial-ending-soon",
          email,
          institutionId: doc.id,
          endDate: trialEnd.toDateString(),
        }));
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "trial_ending_soon", [
          { type: "text", parameter_name: "end_date", text: trialEnd.toDateString() },
        ]));
      }

      // Admin alert — always sent regardless of institution having email/phone
      promises.push(sendEmail({
        event: "trial-ending-soon-admin",
        email: REACHX_ADMIN_EMAIL,
        institutionId: doc.id,
        institutionEmail: email || "N/A",
        institutionPhone: phone || "N/A",
        endDate: trialEnd.toDateString(),
      }));

      await Promise.all(promises);
      await doc.ref.set({ trialWarningOneDaySent: true }, { merge: true });
      console.log(`✅ Trial warning sent for ${doc.id}`);
    }

    // ── Trial expired ────────────────────────────────────────────────────────
    if (isExpired && !data.trialExpiredNotificationSent) {
      console.log(`🚫 Trial expired for institution ${doc.id}`);
      const promises = [];

      if (email) {
        promises.push(sendEmail({
          event: "trial-expired",
          email,
          institutionId: doc.id,
          endDate: trialEnd.toDateString(),
        }));
      }

      if (phone) {
        promises.push(sendWhatsApp(phone, "trial_expired", [
          { type: "text", parameter_name: "end_date", text: trialEnd.toDateString() },
        ]));
      }

      // Admin alert
      promises.push(sendEmail({
        event: "trial-expired-admin",
        email: REACHX_ADMIN_EMAIL,
        institutionId: doc.id,
        institutionEmail: email || "N/A",
        institutionPhone: phone || "N/A",
        endDate: trialEnd.toDateString(),
      }));

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
    const { subscriptionStatus } = data;

    // Only process institutions with an active subscription
    if (!subscriptionStatus) {
      return;
    }

    // Fetch the linked institution_subscription doc (used for email/phone AND archiving)
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

    // Resolve subscriptionEndDate from institution_subscription (Timestamp or ISO string)
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

    // ── Sub-function 1: Two-day-before notification ───────────────────────────
    // Fire when subscriptionEndDate is within the next 2 days and the reminder
    // has not been sent yet (isTwoDaySubSent is falsy on the institutions doc).
    const twoDaysFromNow = new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000);
    const isTwoDaysAway = endDate > now && endDate <= twoDaysFromNow;

    if (isTwoDaysAway && !data.isTwoDaySubSent) {
      console.log(`⚠️  Subscription ending in 2 days for institution ${institutionDoc.id}`);
      const promises = [];

      if (email) {
        promises.push(
          sendEmail({
            event: "subscription-ending-soon",
            email,
            institutionId: institutionDoc.id,
            endDate: endDate.toDateString(),
          })
        );
      }

      if (phone) {
        promises.push(
          sendWhatsApp(phone, "subscription_ending_soon", [
            {
              type: "text",
              parameter_name: "end_date",
              text: endDate.toDateString(),
            },
          ])
        );
      }

      // Admin alert
      promises.push(
        sendEmail({
          event: "subscription-ending-soon-admin",
          email: REACHX_ADMIN_EMAIL,
          institutionId: institutionDoc.id,
          institutionEmail: email || "N/A",
          institutionPhone: phone || "N/A",
          endDate: endDate.toDateString(),
        })
      );

      await Promise.all(promises);
      await institutionDoc.ref.set({ isTwoDaySubSent: true }, { merge: true });
      console.log(`✅ Two-day subscription warning sent for ${institutionDoc.id}`);
    }

    // ── Sub-function 2: Subscription expired ─────────────────────────────────
    // Fire when subscriptionEndDate has passed and the expiry has not been
    // processed yet (isSubscriptionEndNot is falsy on the institutions doc).
    const isExpired = endDate <= now;

    if (isExpired && !data.isSubscriptionEndNot) {
      console.log(`🚫 Subscription expired for institution ${institutionDoc.id}`);
      const promises = [];

      // --- Send expiry notifications ---
      if (email) {
        promises.push(
          sendEmail({
            event: "subscription-expired",
            email,
            institutionId: institutionDoc.id,
            endDate: endDate.toDateString(),
          })
        );
      }

      if (phone) {
        promises.push(
          sendWhatsApp(phone, "subscription_expired", [
            {
              type: "text",
              parameter_name: "end_date",
              text: endDate.toDateString(),
            },
          ])
        );
      }

      // Admin alert
      promises.push(
        sendEmail({
          event: "subscription-expired-admin",
          email: REACHX_ADMIN_EMAIL,
          institutionId: institutionDoc.id,
          institutionEmail: email || "N/A",
          institutionPhone: phone || "N/A",
          endDate: endDate.toDateString(),
        })
      );

      await Promise.all(promises);

      // --- Update institutions collection ---
      await institutionDoc.ref.set(
        {
          subscriptionStatus: false,
          startDate: "",
          isSubscriptionEndNot: true,
        },
        { merge: true }
      );

      // --- Archive & clear subscription details in institution_subscription ---
      const { subscriptionStartDate, subscriptionAmount, subscriptionEndDate } = subData;

      // Build a one-line history string from the three fields
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
