import Foundation


class TitleDetailJSON: Codable {
    let Title: String
    let Year: String
    let Rated: String
    let Released: String
    let Runtime: String
    let Genre: String
    let Director: String
    let Writer: String
    let Actors: String
    let Plot: String
    let Language: String
    let Country: String
    let Awards: String
    let Poster: String
    let Ratings: [RatingJSON]
    let Metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let `Type`: String
    let DVD: String
    let BoxOffice: String
    let Production: String
    let Website: String
    let Response: String

    var description: String {
        return """
            Title: \(Title)
            Year: \(Year)
            Rated: \(Rated)
            Released: \(Released)
            Runtime: \(Runtime)
            Genre: \(Genre)
            Director: \(Director)
            Writer: \(Writer)
            Actors: \(Actors)
            Plot: \(Plot)
            Language: \(Language)
            Country: \(Country)
            Awards: \(Awards)
            Poster: \(Poster)
            Ratings: \(Ratings.map { $0.description })
            Metascore: \(Metascore)
            imdbRating: \(imdbRating)
            imdbVotes: \(imdbVotes)
            imdbID: \(imdbID)
            Type: \(`Type`)
            DVD: \(DVD)
            BoxOffice: \(BoxOffice)
            Production: \(Production)
            Website: \(Website)
            Response: \(Response)
        """
    }

    static func parse(from url: URL, completion: @escaping (TitleDetailJSON) -> Void) {
        url.fetch {
            guard let result = Bundle.main.decode(TitleDetailJSON.self, from: $0) else { return }
            completion(result)
        }
    }
}


extension TitleDetailJSON: TitleDetail {
    var title: String           { Title }
    var year: String            { Year }
    var rated: String           { Rated }
    var released: String        { Released }    // TODO: make date object
    var runtimeMinutes: String  { Runtime }
    var directors: [String]     { Director.splitAndTrim(separator: ",") }
    var writers: [String]       { Writer.splitAndTrim(separator: ",") }
    var actors: [String]        { Actors.splitAndTrim(separator: ",") }
    var plot: String            { Plot }
    var posterURL: URL?         { URL(string: Poster) }
    var ratings: [Rating]       { Ratings.map { $0 as Rating } }
    var metascore: String       { Metascore }
}


class RatingJSON: Codable {
    let Source: String
    let Value: String

    var description: String {
        return """
            Source: \(Source)
            Value: \(Value)
        """
    }
}


extension RatingJSON: Rating {
    var source: RatingSource    { RatingSource.from(string: Source) }
    var value: String           { Value }
}
