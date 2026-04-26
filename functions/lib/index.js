"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendPrayerReminder = exports.monthlyReset = exports.weeklyReset = exports.migrateGuestLogsCallable = exports.logPrayerCallable = exports.onPrayerLogged = void 0;
const admin = __importStar(require("firebase-admin"));
const logger = __importStar(require("firebase-functions/logger"));
const firestore_1 = require("firebase-functions/v2/firestore");
const https_1 = require("firebase-functions/v2/https");
const scheduler_1 = require("firebase-functions/v2/scheduler");
admin.initializeApp();
const db = admin.firestore();
const ALLOWED_HOURS = new Set([0, 1, 3, 6, 9, 11, 12]);
function calculatePoints(log, previousExists) {
    var _a;
    const hours = new Set((_a = log.hoursCompleted) !== null && _a !== void 0 ? _a : []);
    let points = 0;
    points += hours.size * 10;
    if (log.gospelRead)
        points += 5;
    if (!previousExists && hours.size > 0)
        points += 3;
    if (hours.size === 7)
        points += 100;
    return points;
}
async function updateLeaderboardCollections(uid, userData) {
    var _a, _b, _c, _d, _e, _f;
    const churchId = (_a = userData.churchId) !== null && _a !== void 0 ? _a : null;
    const familyGroupId = (_b = userData.familyGroupId) !== null && _b !== void 0 ? _b : null;
    const entry = {
        uid,
        name: (_c = userData.name) !== null && _c !== void 0 ? _c : 'Unknown',
        avatarUrl: (_d = userData.avatarUrl) !== null && _d !== void 0 ? _d : '',
        points: (_e = userData.weeklyPoints) !== null && _e !== void 0 ? _e : 0,
        streak: (_f = userData.currentStreak) !== null && _f !== void 0 ? _f : 0,
        rank: 0,
    };
    if (churchId) {
        await db.collection('churches').doc(churchId).set({
            weeklyLeaderboard: admin.firestore.FieldValue.arrayUnion(entry),
        }, { merge: true });
    }
    if (familyGroupId) {
        await db.collection('familyGroups').doc(familyGroupId).set({
            weeklyLeaderboard: admin.firestore.FieldValue.arrayUnion(entry),
        }, { merge: true });
    }
}
exports.onPrayerLogged = (0, firestore_1.onDocumentWritten)('prayerLogs/{uid}/logs/{dateKey}', async (event) => {
    var _a, _b, _c, _d, _e, _f, _g, _h;
    const uid = event.params.uid;
    const afterData = (_a = event.data) === null || _a === void 0 ? void 0 : _a.after.data();
    const beforeData = (_b = event.data) === null || _b === void 0 ? void 0 : _b.before.data();
    if (!afterData)
        return;
    const previousHadPrayer = !!beforeData && ((_d = (_c = beforeData.hoursCompleted) === null || _c === void 0 ? void 0 : _c.length) !== null && _d !== void 0 ? _d : 0) > 0;
    const awarded = calculatePoints(afterData, previousHadPrayer);
    const userRef = db.collection('users').doc(uid);
    const userSnap = await userRef.get();
    const user = (_e = userSnap.data()) !== null && _e !== void 0 ? _e : {};
    const now = admin.firestore.Timestamp.now();
    const lastPrayed = user.lastPrayedDate;
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    let streak = Number((_f = user.currentStreak) !== null && _f !== void 0 ? _f : 0);
    if (!lastPrayed) {
        streak = 1;
    }
    else {
        const diffDays = Math.floor((now.toDate().getTime() - lastPrayed.toDate().getTime()) / 86400000);
        if (diffDays === 1) {
            streak += 1;
        }
        else if (diffDays > 1) {
            streak = 1;
        }
    }
    let totalAwarded = awarded;
    if (streak === 7)
        totalAwarded += 50;
    await userRef.set({
        weeklyPoints: admin.firestore.FieldValue.increment(totalAwarded),
        monthlyPoints: admin.firestore.FieldValue.increment(totalAwarded),
        totalPoints: admin.firestore.FieldValue.increment(totalAwarded),
        currentStreak: streak,
        longestStreak: Math.max(Number((_g = user.longestStreak) !== null && _g !== void 0 ? _g : 0), streak),
        lastPrayedDate: now,
    }, { merge: true });
    const refreshedUser = (_h = (await userRef.get()).data()) !== null && _h !== void 0 ? _h : {};
    await updateLeaderboardCollections(uid, refreshedUser);
    logger.info('Prayer log processed', { uid, totalAwarded, streak, yesterday: yesterday.toISOString() });
});
exports.logPrayerCallable = (0, https_1.onCall)(async (request) => {
    var _a, _b, _c, _d;
    const uid = (_a = request.auth) === null || _a === void 0 ? void 0 : _a.uid;
    if (!uid) {
        throw new https_1.HttpsError('unauthenticated', 'User must be authenticated.');
    }
    const hour = Number(request.data.hour);
    if (Number.isNaN(hour)) {
        throw new https_1.HttpsError('invalid-argument', 'hour must be a number.');
    }
    if (!ALLOWED_HOURS.has(hour)) {
        throw new https_1.HttpsError('invalid-argument', 'hour is not an Agpeya hour.');
    }
    const dateKey = new Date().toISOString().slice(0, 10);
    const docRef = db.collection('prayerLogs').doc(uid).collection('logs').doc(dateKey);
    const snap = await docRef.get();
    const existing = (_b = snap.data()) !== null && _b !== void 0 ? _b : {};
    const set = new Set(((_c = existing.hoursCompleted) !== null && _c !== void 0 ? _c : []));
    set.add(hour);
    await docRef.set({
        hoursCompleted: Array.from(set),
        gospelRead: (_d = existing.gospelRead) !== null && _d !== void 0 ? _d : false,
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
    logger.info('Prayer hour logged from callable', { uid, hour });
    return { success: true };
});
exports.migrateGuestLogsCallable = (0, https_1.onCall)(async (request) => {
    var _a;
    const uid = (_a = request.auth) === null || _a === void 0 ? void 0 : _a.uid;
    if (!uid) {
        throw new https_1.HttpsError('unauthenticated', 'User must be authenticated.');
    }
    const logs = request.data.logs;
    if (!logs) {
        throw new https_1.HttpsError('invalid-argument', 'logs payload is required.');
    }
    const keys = Object.keys(logs);
    if (keys.length > 45) {
        throw new https_1.HttpsError('invalid-argument', 'logs payload too large.');
    }
    const tasks = Object.entries(logs).map(async ([dateKey, csv]) => {
        var _a, _b, _c;
        if (!/^\d{4}-\d{2}-\d{2}$/.test(dateKey))
            return;
        const hours = (csv || '')
            .split(',')
            .map((x) => Number(x))
            .filter((x) => !Number.isNaN(x) && ALLOWED_HOURS.has(x));
        if (hours.length === 0)
            return;
        const ref = db.collection('prayerLogs').doc(uid).collection('logs').doc(dateKey);
        const snap = await ref.get();
        const existing = (_a = snap.data()) !== null && _a !== void 0 ? _a : {};
        const set = new Set([...((_b = existing.hoursCompleted) !== null && _b !== void 0 ? _b : []), ...hours]);
        await ref.set({
            hoursCompleted: Array.from(set),
            gospelRead: (_c = existing.gospelRead) !== null && _c !== void 0 ? _c : false,
            completedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });
    });
    await Promise.all(tasks);
    logger.info('Guest logs migrated', { uid, count: Object.keys(logs).length });
    return { success: true };
});
exports.weeklyReset = (0, scheduler_1.onSchedule)({
    schedule: '0 0 * * 0',
    timeZone: 'Africa/Cairo',
}, async () => {
    const users = await db.collection('users').get();
    const batch = db.batch();
    users.docs.forEach((doc) => {
        batch.set(doc.ref, { weeklyPoints: 0 }, { merge: true });
    });
    await batch.commit();
    logger.info('Weekly reset completed', { users: users.size });
});
exports.monthlyReset = (0, scheduler_1.onSchedule)({
    schedule: '0 0 1 * *',
    timeZone: 'Africa/Cairo',
}, async () => {
    const users = await db.collection('users').get();
    const batch = db.batch();
    users.docs.forEach((doc) => {
        batch.set(doc.ref, { monthlyPoints: 0 }, { merge: true });
    });
    await batch.commit();
    logger.info('Monthly reset completed', { users: users.size });
});
exports.sendPrayerReminder = (0, scheduler_1.onSchedule)({
    schedule: 'every 60 minutes',
    timeZone: 'Africa/Cairo',
}, async () => {
    const users = await db.collection('users').where('notificationsEnabled', '==', true).get();
    const messages = [];
    users.docs.forEach((doc) => {
        var _a;
        const data = doc.data();
        const token = data.fcmToken;
        if (!token)
            return;
        messages.push({
            token,
            notification: {
                title: `وقت الصلاة يا ${(_a = data.name) !== null && _a !== void 0 ? _a : 'حبيب المسيح'}`,
                body: 'قم وصلِ من الأجبية الآن',
            },
        });
    });
    await Promise.all(messages.map((m) => admin.messaging().send(m)));
    logger.info('Prayer reminders sent', { count: messages.length });
});
//# sourceMappingURL=index.js.map