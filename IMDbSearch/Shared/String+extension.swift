import Foundation


extension String {
    func splitAndTrim(separator: Character) -> [String] {
        return split(separator: separator).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
