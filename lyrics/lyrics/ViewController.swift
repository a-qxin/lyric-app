// https://lyricsovh.docs.apiary.io/#reference/0/lyrics-of-a-song/search?console=1
// https://api.lyrics.ovh/v1/Madeon/Miracle

struct Lyrics {
   // empty for now
}

struct SongServiceResponse: Decodable {
   let lyrics: String
}

struct SongService {
   func lyrics(artist: String, title: String, callback: @escaping (Lyrics) -> Void) {
      guard let url = URL(string: "https://api.lyrics.ovh/v1/\(artist)/\(title)") else {
         assertionFailure("Invalid URL")
         return
      }
      let task = URLSession.shared.dataTask(with: url) { (maybeData: Data?, maybeUrlResponse: URLResponse?, maybeError: Error?) in
         guard let data = maybeData else {
            assertionFailure("No data response from API")
            return
         }
         let decoder = JSONDecoder()

         do {
            let response = try decoder.decode(SongServiceResponse.self, from: data)
            print(response)
         } catch {
            print(error)
         }
      }
      task.resume()
   }
}

import UIKit

class ViewController: UIViewController {

   let service = SongService()

   override func viewDidLoad() {
      super.viewDidLoad()
      
      let artist = "Madeon"
      let title = "Miracle"

      print("Before req")
      service.lyrics(artist: artist , title: title) { lyrics in
         print("Lyrics:")
         print(lyrics)
      }
      print("After req")
   }


}

