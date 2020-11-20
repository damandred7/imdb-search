import Foundation


public protocol TitleDetail {
    var title: String { get }
    var year: String { get }
    var rated: String { get }
    var released: String { get }    // TODO: make date object
    var runtimeMinutes: String { get }
    var directors: [String] { get }
    var writers: [String] { get }
    var actors: [String] { get }
    var plot: String { get }
    var posterURL: URL? { get }
    var ratings: [Rating] { get }
    var metascore: String { get }
    var imdbRating: String { get }
    var imdbVotes: String { get }
    var imdbID: String { get }
}


extension TitleDetail {
    var description: String {
        return """
            Title: \(title)
            Year: \(year)
            Rating: \(rated)
            Release Date: \(released)
            Runtime: \(runtimeMinutes) min
            Director(s): \(directors)
            Writer(s): \(writers)
            Actors: \(actors)
            Plot: \(plot)
            Poster URL: \(posterURL?.description ?? "nil")
            Ratings: \(ratings.map { $0.description })
            Metascore: \(metascore)
            IMDB Rating: \(imdbRating) (\(imdbVotes) votes)
            IMDB ID: \(imdbID)
            """
    }
}


public protocol Rating {
    var source: RatingSource { get }
    var value: String { get }
}


extension Rating {
    var description: String {
        return "\(source): \(value)"
    }
}


public enum RatingSource {
    case imdb
    case rottenTomatoes
    case metacritic
    case unknown(String)

    static func from(string: String) -> RatingSource {
        switch string {
            case "Internet Movie Database":
                return .imdb
            case "Rotten Tomatoes":
                return .rottenTomatoes
            case "Metacritic":
                return .metacritic
            default:
                return .unknown(string)
        }
    }
}
