import Foundation


extension String {
    /// Split a string into an array using a given separator and trim whitespace
    /// from each of the array elements before returning
    func splitAndTrim(separator: Character) -> [String] {
        return split(separator: separator).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
