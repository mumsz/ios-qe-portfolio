import SwiftUI

struct MemberRowView: View {
    let member: Member

    var body: some View {
        HStack(spacing: 12) {
            Text(member.emoji)
                .font(.largeTitle)
                .frame(width: 44, height: 44)
                .background(Color(hex: member.colorHex).opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(member.name)
                    .font(.headline)
                Text("Age \(member.age)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
