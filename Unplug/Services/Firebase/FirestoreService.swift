import FirebaseFirestore
import Foundation

final class FirestoreService {
    private lazy var db: Firestore = {
        let firestore = Firestore.firestore()
        let settings = firestore.settings
        settings.cacheSettings = PersistentCacheSettings(
            sizeBytes: 100 * 1024 * 1024 as NSNumber
        )
        firestore.settings = settings
        return firestore
    }()

    /// Returns the Firestore instance or throws if Firebase is not configured.
    /// This prevents crashes when GoogleService-Info.plist is missing (CI, first launch).
    private func requireDB() throws -> Firestore {
        guard FirebaseConfig.isConfigured else {
            throw FirestoreError.notConfigured
        }
        return db
    }

    enum FirestoreError: Error {
        case notConfigured
    }

    // MARK: - User

    func createUser(_ user: UnplugUser) async throws {
        guard let userId = user.id else { return }
        try requireDB().collection("users").document(userId).setData(from: user)
    }

    func getUser(id: String) async throws -> UnplugUser? {
        let doc = try await requireDB().collection("users").document(id).getDocument()
        return try? doc.data(as: UnplugUser.self)
    }

    func updateUser(_ user: UnplugUser) async throws {
        guard let userId = user.id else { return }
        try requireDB().collection("users").document(userId).setData(from: user, merge: true)
    }

    // MARK: - Mood Entries

    func saveMoodEntry(_ entry: MoodEntry) async throws {
        let userId = entry.userId
        try requireDB().collection("users")
            .document(userId)
            .collection("moods")
            .addDocument(from: entry)
    }

    func getRecentMoods(userId: String, limit: Int = 7) async throws -> [MoodEntry] {
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("moods")
            .order(by: "createdAt", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: MoodEntry.self) }
    }

    // MARK: - Streaks

    func getStreak(userId: String, type: StreakType) async throws -> Streak? {
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("streaks")
            .whereField("type", isEqualTo: type.rawValue)
            .limit(to: 1)
            .getDocuments()

        return snapshot.documents.first.flatMap { try? $0.data(as: Streak.self) }
    }

    func saveStreak(_ streak: Streak) async throws {
        let db = try requireDB()
        if let streakId = streak.id {
            try db.collection("users")
                .document(streak.userId)
                .collection("streaks")
                .document(streakId)
                .setData(from: streak, merge: true)
        } else {
            try db.collection("users")
                .document(streak.userId)
                .collection("streaks")
                .addDocument(from: streak)
        }
    }

    func getAllStreaks(userId: String) async throws -> [Streak] {
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("streaks")
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Streak.self) }
    }

    // MARK: - Scroll Sessions

    func saveSession(_ session: ScrollSession) async throws {
        try requireDB().collection("users")
            .document(session.userId)
            .collection("sessions")
            .addDocument(from: session)
    }

    func getTodaySessions(userId: String) async throws -> [ScrollSession] {
        let startOfToday = Calendar.current.startOfDay(for: .now)
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("sessions")
            .whereField("startedAt", isGreaterThanOrEqualTo: startOfToday)
            .order(by: "startedAt", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: ScrollSession.self) }
    }

    func getSessions(userId: String, from: Date, to: Date) async throws -> [ScrollSession] {
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("sessions")
            .whereField("startedAt", isGreaterThanOrEqualTo: from)
            .whereField("startedAt", isLessThan: to)
            .order(by: "startedAt", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: ScrollSession.self) }
    }

    // MARK: - Mood Entries (Date Range)

    func getMoods(userId: String, from: Date, to: Date) async throws -> [MoodEntry] {
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("moods")
            .whereField("createdAt", isGreaterThanOrEqualTo: from)
            .whereField("createdAt", isLessThan: to)
            .order(by: "createdAt", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: MoodEntry.self) }
    }

    // MARK: - Achievements

    func saveAchievement(_ achievement: Achievement) async throws {
        try requireDB().collection("users")
            .document(achievement.userId)
            .collection("achievements")
            .addDocument(from: achievement)
    }

    func getAchievements(userId: String) async throws -> [Achievement] {
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("achievements")
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Achievement.self) }
    }

    // MARK: - Challenges

    func saveChallenge(_ challenge: Challenge, userId: String) async throws {
        let db = try requireDB()
        if let challengeId = challenge.id {
            try db.collection("users")
                .document(userId)
                .collection("challenges")
                .document(challengeId)
                .setData(from: challenge)
        } else {
            try db.collection("users")
                .document(userId)
                .collection("challenges")
                .addDocument(from: challenge)
        }
    }

    func getActiveChallenges(userId: String) async throws -> [Challenge] {
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("challenges")
            .whereField("isActive", isEqualTo: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Challenge.self) }
    }

    func updateChallengeProgress(_ challenge: Challenge, userId: String) async throws {
        guard let challengeId = challenge.id else { return }
        try requireDB().collection("users")
            .document(userId)
            .collection("challenges")
            .document(challengeId)
            .setData(from: challenge, merge: true)
    }

    // MARK: - Invite Codes

    func generateInviteCode(userId: String) async throws -> String {
        let db = try requireDB()
        let characters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        var code: String
        var exists = true

        repeat {
            code = String((0..<6).map { _ in characters.randomElement()! })
            let doc = try await db.collection("inviteCodes").document(code).getDocument()
            exists = doc.exists
        } while exists

        let inviteCode = InviteCode(code: code, userId: userId)
        try db.collection("inviteCodes").document(code).setData(from: inviteCode)
        return code
    }

    func lookupInviteCode(_ code: String) async throws -> String? {
        let doc = try await requireDB().collection("inviteCodes").document(code.uppercased()).getDocument()
        guard let inviteCode = try? doc.data(as: InviteCode.self), !inviteCode.isUsed else {
            return nil
        }
        return inviteCode.userId
    }

    func markInviteCodeUsed(_ code: String) async throws {
        try await requireDB().collection("inviteCodes").document(code.uppercased()).updateData([
            "isUsed": true,
        ])
    }

    // MARK: - Buddies

    func addBuddy(userId: String, buddyId: String) async throws {
        let db = try requireDB()
        let userBuddy = BuddyInfo(userId: buddyId)
        let buddyEntry = BuddyInfo(userId: userId)

        try db.collection("users").document(userId)
            .collection("buddies").document(buddyId)
            .setData(from: userBuddy)

        try db.collection("users").document(buddyId)
            .collection("buddies").document(userId)
            .setData(from: buddyEntry)
    }

    func getBuddies(userId: String) async throws -> [BuddyInfo] {
        let snapshot = try await requireDB().collection("users")
            .document(userId)
            .collection("buddies")
            .getDocuments()

        var buddies: [BuddyInfo] = []
        for doc in snapshot.documents {
            guard var buddy = try? doc.data(as: BuddyInfo.self) else { continue }
            if let buddyUser = try? await getUser(id: buddy.userId) {
                buddy.displayName = buddyUser.displayName ?? String(localized: "social.buddy.anonymous")
            }
            if let streak = try? await getStreak(userId: buddy.userId, type: .checkIn) {
                buddy.streakCount = streak.currentCount
                buddy.lastActiveAt = streak.lastDate
            }
            buddies.append(buddy)
        }
        return buddies
    }

    func getBuddyProgress(buddyId: String) async throws -> BuddyProgress {
        let sessions = try await getTodaySessions(userId: buddyId)
        let streak = try await getStreak(userId: buddyId, type: .checkIn)
        let moods = try await getRecentMoods(userId: buddyId, limit: 1)

        let allSessions = try await getSessions(
            userId: buddyId,
            from: Calendar.current.date(byAdding: .day, value: -30, to: .now) ?? .now,
            to: .now
        )

        return BuddyProgress(
            todaySessionCount: sessions.count,
            currentStreak: streak?.currentCount ?? 0,
            latestMoodLevel: moods.first?.moodLevel,
            totalMinutesSaved: InsightsCalculator.totalMinutesSaved(sessions: allSessions)
        )
    }
}
