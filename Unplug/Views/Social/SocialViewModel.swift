import Foundation

@Observable
final class SocialViewModel {
    var buddies: [BuddyInfo] = []
    var buddyProgress: [String: BuddyProgress] = [:]
    var isLoading = false
    var inviteCode: String?
    var isGeneratingCode = false
    var enteredCode = ""
    var isConnecting = false
    var showError = false
    var errorMessage = ""

    func loadBuddies(userId: String, showSkeleton: Bool = true) async {
        if showSkeleton { isLoading = true }
        let firestoreService = FirestoreService()
        do {
            buddies = try await firestoreService.getBuddies(userId: userId)
            for buddy in buddies {
                if let progress = try? await firestoreService.getBuddyProgress(buddyId: buddy.userId) {
                    buddyProgress[buddy.userId] = progress
                }
            }
        } catch {
            // Offline fallback
        }
        isLoading = false
    }

    func generateCode(userId: String) async {
        isGeneratingCode = true
        let firestoreService = FirestoreService()
        do {
            inviteCode = try await firestoreService.generateInviteCode(userId: userId)
        } catch {
            showError = true
            errorMessage = String(localized: "social.error.generateCode")
        }
        isGeneratingCode = false
    }

    func connectWithCode(userId: String) async -> Bool {
        guard !enteredCode.isEmpty else { return false }
        isConnecting = true
        let firestoreService = FirestoreService()
        do {
            guard let buddyId = try await firestoreService.lookupInviteCode(enteredCode) else {
                showError = true
                errorMessage = String(localized: "social.error.invalidCode")
                isConnecting = false
                return false
            }

            guard buddyId != userId else {
                showError = true
                errorMessage = String(localized: "social.error.ownCode")
                isConnecting = false
                return false
            }

            try await firestoreService.addBuddy(userId: userId, buddyId: buddyId)
            try await firestoreService.markInviteCodeUsed(enteredCode)
            enteredCode = ""
            await loadBuddies(userId: userId)
            isConnecting = false
            return true
        } catch {
            showError = true
            errorMessage = String(localized: "social.error.connection")
            isConnecting = false
            return false
        }
    }
}
