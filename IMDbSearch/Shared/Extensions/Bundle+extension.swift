import Foundation


extension Bundle {
    /// Decode into a known JSON type
    func decode<T: Decodable>(_ type: T.Type, from data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Failed to decode from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
            return nil
        } catch DecodingError.typeMismatch(_, let context) {
            print("Failed to decode from bundle due to type mismatch – \(context.debugDescription)")
            return nil
        } catch DecodingError.valueNotFound(let type, let context) {
            print("Failed to decode from bundle due to missing \(type) value – \(context.debugDescription)")
            return nil
        } catch DecodingError.dataCorrupted(_) {
            print("Failed to decode from bundle because it appears to be invalid JSON")
            return nil
        } catch {
            print("Failed to decode from bundle: \(error.localizedDescription)")
            return nil
        }
    }
}
