import Foundation


struct SongServiceResponse: Decodable {
   let lyrics: String?
}

extension SongServiceResponse: CustomStringConvertible {
   var description: String {
      return "Lyrics: \n \(lyrics)"
   }
}
