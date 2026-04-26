import * as admin from 'firebase-admin';
import * as logger from 'firebase-functions/logger';
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';

admin.initializeApp();

const db = admin.firestore();

type PrayerLog = {
  hoursCompleted?: number[];
  gospelRead?: boolean;
  pointsEarned?: number;
  completedAt?: admin.firestore.Timestamp;
};

const ALLOWED_HOURS = new Set<number>([0, 1, 3, 6, 9, 11, 12]);

function calculatePoints(log: PrayerLog, previousExists: boolean): number {
  const hours = new Set(log.hoursCompleted ?? []);
  let points = 0;
  points += hours.size * 10;
  if (log.gospelRead) points += 5;
  if (!previousExists && hours.size > 0) points += 3;
  if (hours.size === 7) points += 100;
  return points;
}

async function updateLeaderboardCollections(uid: string, userData: any): Promise<void> {
  const churchId: string | null = userData.churchId ?? null;
  const familyGroupId: string | null = userData.familyGroupId ?? null;
  const entry = {
    uid,
    name: userData.name ?? 'Unknown',
    avatarUrl: userData.avatarUrl ?? '',
    points: userData.weeklyPoints ?? 0,
    streak: userData.currentStreak ?? 0,
    rank: 0,
  };

  if (churchId) {
    await db.collection('churches').doc(churchId).set(
      {
        weeklyLeaderboard: admin.firestore.FieldValue.arrayUnion(entry),
      },
      { merge: true },
    );
  }

  if (familyGroupId) {
    await db.collection('familyGroups').doc(familyGroupId).set(
      {
        weeklyLeaderboard: admin.firestore.FieldValue.arrayUnion(entry),
      },
      { merge: true },
    );
  }
}

export const onPrayerLogged = onDocumentWritten(
  'prayerLogs/{uid}/logs/{dateKey}',
  async (event) => {
    const uid = event.params.uid as string;
    const afterData = event.data?.after.data() as PrayerLog | undefined;
    const beforeData = event.data?.before.data() as PrayerLog | undefined;
    if (!afterData) return;

    const previousHadPrayer = !!beforeData && (beforeData.hoursCompleted?.length ?? 0) > 0;
    const awarded = calculatePoints(afterData, previousHadPrayer);
    const userRef = db.collection('users').doc(uid);
    const userSnap = await userRef.get();
    const user = userSnap.data() ?? {};

    const now = admin.firestore.Timestamp.now();
    const lastPrayed = user.lastPrayedDate as admin.firestore.Timestamp | undefined;
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);

    let streak = Number(user.currentStreak ?? 0);
    if (!lastPrayed) {
      streak = 1;
    } else {
      const diffDays = Math.floor((now.toDate().getTime() - lastPrayed.toDate().getTime()) / 86400000);
      if (diffDays === 1) {
        streak += 1;
      } else if (diffDays > 1) {
        streak = 1;
      }
    }

    let totalAwarded = awarded;
    if (streak === 7) totalAwarded += 50;

    await userRef.set(
      {
        weeklyPoints: admin.firestore.FieldValue.increment(totalAwarded),
        monthlyPoints: admin.firestore.FieldValue.increment(totalAwarded),
        totalPoints: admin.firestore.FieldValue.increment(totalAwarded),
        currentStreak: streak,
        longestStreak: Math.max(Number(user.longestStreak ?? 0), streak),
        lastPrayedDate: now,
      },
      { merge: true },
    );

    const refreshedUser = (await userRef.get()).data() ?? {};
    await updateLeaderboardCollections(uid, refreshedUser);
    logger.info('Prayer log processed', { uid, totalAwarded, streak, yesterday: yesterday.toISOString() });
  },
);

export const logPrayerCallable = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError('unauthenticated', 'User must be authenticated.');
  }
  const hour = Number(request.data.hour);
  if (Number.isNaN(hour)) {
    throw new HttpsError('invalid-argument', 'hour must be a number.');
  }
  if (!ALLOWED_HOURS.has(hour)) {
    throw new HttpsError('invalid-argument', 'hour is not an Agpeya hour.');
  }

  const dateKey = new Date().toISOString().slice(0, 10);
  const docRef = db.collection('prayerLogs').doc(uid).collection('logs').doc(dateKey);
  const snap = await docRef.get();
  const existing = snap.data() ?? {};
  const set = new Set<number>((existing.hoursCompleted ?? []) as number[]);
  set.add(hour);

  await docRef.set(
    {
      hoursCompleted: Array.from(set),
      gospelRead: existing.gospelRead ?? false,
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  logger.info('Prayer hour logged from callable', { uid, hour });
  return { success: true };
});

export const migrateGuestLogsCallable = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError('unauthenticated', 'User must be authenticated.');
  }
  const logs = request.data.logs as Record<string, string> | undefined;
  if (!logs) {
    throw new HttpsError('invalid-argument', 'logs payload is required.');
  }
  const keys = Object.keys(logs);
  if (keys.length > 45) {
    throw new HttpsError('invalid-argument', 'logs payload too large.');
  }

  const tasks = Object.entries(logs).map(async ([dateKey, csv]) => {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(dateKey)) return;
    const hours = (csv || '')
      .split(',')
      .map((x) => Number(x))
      .filter((x) => !Number.isNaN(x) && ALLOWED_HOURS.has(x));
    if (hours.length === 0) return;
    const ref = db.collection('prayerLogs').doc(uid).collection('logs').doc(dateKey);
    const snap = await ref.get();
    const existing = snap.data() ?? {};
    const set = new Set<number>([...(existing.hoursCompleted ?? []), ...hours]);
    await ref.set(
      {
        hoursCompleted: Array.from(set),
        gospelRead: existing.gospelRead ?? false,
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  });

  await Promise.all(tasks);
  logger.info('Guest logs migrated', { uid, count: Object.keys(logs).length });
  return { success: true };
});

export const weeklyReset = onSchedule(
  {
    schedule: '0 0 * * 0',
    timeZone: 'Africa/Cairo',
  },
  async () => {
    const users = await db.collection('users').get();
    const batch = db.batch();
    users.docs.forEach((doc) => {
      batch.set(doc.ref, { weeklyPoints: 0 }, { merge: true });
    });
    await batch.commit();
    logger.info('Weekly reset completed', { users: users.size });
  },
);

export const monthlyReset = onSchedule(
  {
    schedule: '0 0 1 * *',
    timeZone: 'Africa/Cairo',
  },
  async () => {
    const users = await db.collection('users').get();
    const batch = db.batch();
    users.docs.forEach((doc) => {
      batch.set(doc.ref, { monthlyPoints: 0 }, { merge: true });
    });
    await batch.commit();
    logger.info('Monthly reset completed', { users: users.size });
  },
);

export const sendPrayerReminder = onSchedule(
  {
    schedule: 'every 60 minutes',
    timeZone: 'Africa/Cairo',
  },
  async () => {
    const users = await db.collection('users').where('notificationsEnabled', '==', true).get();
    const messages: admin.messaging.Message[] = [];
    users.docs.forEach((doc) => {
      const data = doc.data();
      const token = data.fcmToken as string | undefined;
      if (!token) return;
      messages.push({
        token,
        notification: {
          title: `وقت الصلاة يا ${data.name ?? 'حبيب المسيح'}`,
          body: 'قم وصلِ من الأجبية الآن',
        },
      });
    });

    await Promise.all(messages.map((m) => admin.messaging().send(m)));
    logger.info('Prayer reminders sent', { count: messages.length });
  },
);
