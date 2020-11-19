import Foundation

extension URL {
    func fetch(completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
}
