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

    // MARK: - User

    func createUser(_ user: UnplugUser) async throws {
        guard let userId = user.id else { return }
        try db.collection("users").document(userId).setData(from: user)
    }

    func getUser(id: String) async throws -> UnplugUser? {
        let doc = try await db.collection("users").document(id).getDocument()
        return try? doc.data(as: UnplugUser.self)
    }

    func updateUser(_ user: UnplugUser) async throws {
        guard let userId = user.id else { return }
        try db.collection("users").document(userId).setData(from: user, merge: true)
    }

    // MARK: - Mood Entries

    func saveMoodEntry(_ entry: MoodEntry) async throws {
        guard let userId = entry.userId as String? else { return }
        try db.collection("users")
            .document(userId)
            .collection("moods")
            .addDocument(from: entry)
    }

    func getRecentMoods(userId: String, limit: Int = 7) async throws -> [MoodEntry] {
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("moods")
            .order(by: "createdAt", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: MoodEntry.self) }
    }

    // MARK: - Streaks

    func getStreak(userId: String, type: StreakType) async throws -> Streak? {
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("streaks")
            .whereField("type", isEqualTo: type.rawValue)
            .limit(to: 1)
            .getDocuments()

        return snapshot.documents.first.flatMap { try? $0.data(as: Streak.self) }
    }

    func saveStreak(_ streak: Streak) async throws {
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
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("streaks")
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Streak.self) }
    }

    // MARK: - Scroll Sessions

    func saveSession(_ session: ScrollSession) async throws {
        try db.collection("users")
            .document(session.userId)
            .collection("sessions")
            .addDocument(from: session)
    }

    func getTodaySessions(userId: String) async throws -> [ScrollSession] {
        let startOfToday = Calendar.current.startOfDay(for: .now)
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("sessions")
            .whereField("startedAt", isGreaterThanOrEqualTo: startOfToday)
            .order(by: "startedAt", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: ScrollSession.self) }
    }

    func getSessions(userId: String, from: Date, to: Date) async throws -> [ScrollSession] {
        let snapshot = try await db.collection("users")
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
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("moods")
            .whereField("createdAt", isGreaterThanOrEqualTo: from)
            .whereField("createdAt", isLessThan: to)
            .order(by: "createdAt", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: MoodEntry.self) }
    }
}
