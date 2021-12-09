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

//class SearchViewController: UIViewController {
//
//   @IBOutlet var artistField: UITextField!
//   @IBOutlet var titleField: UITextField!
//   @IBOutlet var submitButton: UIButton!
//
//   let service = SongService()
//
//   var artist: String = "Madeon"
//   var songTitle: String = "Miracle"
//
//   var takeUserInputArtist: String? {
//      guard
//         let userInputArtist = artistField.text,
//         !userInputArtist.isEmpty
//      else {
//         return nil
//      }
//         return userInputArtist
//   }
//
//   var takeUserInputTitle: String? {
//      guard
//         let userInputTitle = titleField.text,
//         !userInputTitle.isEmpty
//      else {
//         return nil
//      }
//         return userInputTitle
//   }
//
////   func artistSet(_ artist: String) {
////      self.artist = artist
////   }
////   func songTitleSet(_ songTitle: String) {
////      self.songTitle = songTitle
////   }
//
//   @IBAction func buttonTapped() {
//      artistField.resignFirstResponder()
//      titleField.resignFirstResponder()
//
//      guard let artist = takeUserInputArtist else {
//         // TODO: make labels for errors
//         //         artistField.text = "No artist input"
//         return
//      }
//      guard let songTitle = takeUserInputTitle else {
//         // TODO: make labels for errors
//         //         titleField.text = "No title input"
//         return
//      }
//      // TODO: output lyrics based on user input artist and song title
//      //      songTitle.text = "Artist: $\(artist)"
//   }
//
//
//   override func viewDidLoad() {
//      super.viewDidLoad()
//
//      print("Before req")
//      service.lyrics(artist: artist, songTitle: songTitle) { lyrics in
//         print("Lyrics:")
//         print(lyrics)
//      }
//      print("After req")
//   }
//}
