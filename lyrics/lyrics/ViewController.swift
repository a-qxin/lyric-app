// https://lyricsovh.docs.apiary.io/#reference/0/lyrics-of-a-song/search?console=1
// https://api.lyrics.ovh/v1/Madeon/Miracle



struct SongService {
   func lyrics(artist: String, songTitle: String, callback: @escaping (Lyrics) -> Void) {
      guard let url = URL(string: "https://api.lyrics.ovh/v1/\(artist)/\(songTitle)") else {
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
            print("got to this sicc response here")
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

   @IBOutlet var artistField: UITextField!
   @IBOutlet var songTitleField: UITextField!
   @IBOutlet var submitButton: UIButton!

   let service = SongService()
   weak var delegate: SetLyricsDelegateProtocol?

   var artist: String = "Madeon"
   var songTitle: String = "Miracle"

   var takeUserInputArtist: String {
      guard
         let userInputArtist = artistField.text,
         !userInputArtist.isEmpty
      else {
//         return nil
         return ""
      }
         return userInputArtist
   }

   var takeUserInputTitle: String {
      guard
         let userInputTitle = songTitleField.text,
         !userInputTitle.isEmpty
      else {
//         return nil
         return ""
      }
         return userInputTitle
   }

   @IBAction func showLyrics(_ sender: Any) {
//      let controller = SongViewController()
//      controller.delegate = self
      service.lyrics(artist: takeUserInputArtist , songTitle: takeUserInputTitle) { lyrics in
         print("before delEgate stuff in showLyrics ibaction submit")
//         self.delegate?.lyricsSet(lyrics)
         print("after delegatestuff")
      }
   }

   override func viewDidLoad() {
      super.viewDidLoad()
   }
}

class SongViewController: UIViewController {

   @IBOutlet weak var lyricsOutput: UILabel!

   weak var delegate: SetLyricsDelegateProtocol?

//   var lyrics: Lyrics?
//
//   func lyricsSet(_ lyrics: Lyrics) {
//      self.lyrics = lyrics
//   }

   func applyLyrics(_ lyrics: Lyrics) {
//      print(lyrics)
      print("Got to applyLyrics")
      lyricsOutput.text = "Lyrics\n $\(lyrics.lyrics)"
   }

}

protocol SetLyricsDelegateProtocol: AnyObject {
   func lyricsSet(_ lyrics: Lyrics)
}

extension SongViewController: SetLyricsDelegateProtocol {
   func lyricsSet(_ lyrics: Lyrics) {
      applyLyrics(lyrics)
      print("we are SETTINg lyrics in set lyrics delegate protocol")
   }
}
