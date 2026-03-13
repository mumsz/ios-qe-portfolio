import Foundation
import SwiftData

@Observable
class MemberViewModel {
    var members: [Member] = []
    var errorMessage: String?

    func addMember(name: String, age: Int, colorHex: String, emoji: String, context: ModelContext) {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty else {
            errorMessage = "Name cannot be empty"
            return
        }

        guard age >= 1 && age <= 100 else {
            errorMessage = "Age must be between 1 and 100"
            return
        }

        let member = Member(name: trimmedName, age: age, colorHex: colorHex, emoji: emoji)
        context.insert(member)
        errorMessage = nil
    }

    func deleteMember(_ member: Member, context: ModelContext) {
        context.delete(member)
    }
}
