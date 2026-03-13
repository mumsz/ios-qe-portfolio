import Foundation
import SwiftData

@Model
class Member {
    var name: String
    var age: Int
    var colorHex: String
    var emoji: String

    init(name: String, age: Int, colorHex: String, emoji: String) {
        self.name = name
        self.age = age
        self.colorHex = colorHex
        self.emoji = emoji
    }
}


