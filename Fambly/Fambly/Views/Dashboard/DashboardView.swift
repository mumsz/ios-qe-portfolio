import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var members: [Member]
    @Query private var tasks: [ChoreTask]

    var todaysTasks: [ChoreTask] {
        tasks.filter {
            Calendar.current.isDateInToday($0.dueDate) && !$0.isComplete
        }
    }

    var completedToday: [ChoreTask] {
        tasks.filter {
            Calendar.current.isDateInToday($0.dueDate) && $0.isComplete
        }
    }

    var overdueTasks: [ChoreTask] {
        tasks.filter {
            $0.dueDate < Calendar.current.startOfDay(for: Date()) && !$0.isComplete
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Summary Cards
                    HStack(spacing: 12) {
                        SummaryCard(
                            title: "Due Today",
                            count: todaysTasks.count,
                            color: .blue,
                            icon: "calendar"
                        )
                        SummaryCard(
                            title: "Overdue",
                            count: overdueTasks.count,
                            color: .red,
                            icon: "exclamationmark.circle"
                        )
                        SummaryCard(
                            title: "Done Today",
                            count: completedToday.count,
                            color: .green,
                            icon: "checkmark.circle"
                        )
                    }
                    .padding(.horizontal)

                    // Overdue Section
                    if !overdueTasks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            SectionHeader(title: "Overdue", color: .red)
                            ForEach(overdueTasks) { task in
                                TaskRowView(task: task)
                                    .padding(.horizontal)
                            }
                        }
                    }

                    // Due Today Section
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "Due Today", color: .blue)
                        if todaysTasks.isEmpty {
                            EmptyStateRow(message: "Nothing due today")
                        } else {
                            ForEach(todaysTasks) { task in
                                TaskRowView(task: task)
                                    .padding(.horizontal)
                            }
                        }
                    }

                    // Family Progress Section
                    if !members.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            SectionHeader(title: "Family Progress", color: .purple)
                            ForEach(members) { member in
                                MemberProgressRow(
                                    member: member,
                                    tasks: tasks.filter {
                                        $0.assignedMemberName == member.name
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
}

// MARK: - Supporting Views

struct SummaryCard: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SectionHeader: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(color)
            .padding(.horizontal)
    }
}

struct EmptyStateRow: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
    }
}

struct MemberProgressRow: View {
    let member: Member
    let tasks: [ChoreTask]

    var completedCount: Int {
        tasks.filter { $0.isComplete }.count
    }

    var progress: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedCount) / Double(tasks.count)
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(member.emoji)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(member.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(completedCount)/\(tasks.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                ProgressView(value: progress)
                    .tint(Color(hex: member.colorHex))
            }
        }
        .padding()
        .background(Color(hex: member.colorHex).opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
