import Foundation

extension URL {
    /// Fetch the data at a URL and call the completion with the data (if the
    /// data was recieved)
    func fetch(completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
}
