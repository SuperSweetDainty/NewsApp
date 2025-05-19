import Foundation

enum NewsCategory: String, CaseIterable {
    case general
    case science
    case sports
    case technology

    var displayName: String {
        switch self {
        case .general: return "Общее"
        case .science: return "Наука"
        case .sports: return "Спорт"
        case .technology: return "Технологии"
        }
    }
}
