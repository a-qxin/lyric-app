// https://lyricsovh.docs.apiary.io/#reference/0/lyrics-of-a-song/search?console=1
// https://api.lyrics.ovh/v1/Madeon/Miracle
// https://www.appsdeveloperblog.com/uilabel-with-multiple-lines-example-in-swift/
// https://stackoverflow.com/questions/54170821/swift-error-uibutton-currenttitle-must-be-used-from-main-thread-only
// UIScrollView https://www.youtube.com/watch?v=orONrVT6CAg
// custom launch screen https://www.youtube.com/watch?v=kbGsI5O9rWY

struct SongService {
   func lyrics(artist: String, songTitle: String, callback: @escaping (String?) -> Void) {
      guard let url = URL(string: "https://api.lyrics.ovh/v1/\(artist)/\(songTitle)") else {
//         assertionFailure("Invalid URL")
//         response = "No lyrics found."
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
            callback(response.lyrics)
         } catch {
            print(error)
         }
      }
      task.resume()
   }
}

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var artistField: UITextField!
   @IBOutlet weak var songTitleField: UITextField!
   @IBOutlet var submitButton: UIButton!
   @IBOutlet var lyricOutput: UILabel!

   let service = SongService()
   weak var delegate: SetLyricsDelegateProtocol?

   var artist: String = "Madeon"
   var songTitle: String = "Miracle"
   var lyrics: Lyrics?

   var takeUserInputArtist: String {
      guard
         let userInputArtist = artistField.text?.replacingOccurrences(of: " ", with: "%20"),
         !userInputArtist.isEmpty
      else {
//         return nil
         return ""
      }
         return userInputArtist
   }

   var takeUserInputTitle: String {
      guard
         let userInputTitle = songTitleField.text?.replacingOccurrences(of: " ", with: "%20"),
         !userInputTitle.isEmpty
      else {
//         return nil
         return ""
      }
         return userInputTitle
   }

   @IBAction func showLyrics(_ sender: Any) {
      service.lyrics(artist: takeUserInputArtist , songTitle: takeUserInputTitle) { lyrics in
         guard let lyrics = lyrics else {
            return
         }
//         lyrics = lyrics.replacingOccurrences(of: "\r", with: "")
         let error = "No lyrics found."
         DispatchQueue.main.async {
            if lyrics != nil {
               self.lyricOutput.text = lyrics
            } else {
               self.lyricOutput.text = error // doesn't actually show
            }
         }
//         self.delegate?.lyricsSet(lyrics)
      }
   }

   override func viewDidLoad() {
      // allow infinite height/number of lyrics lines
      lyricOutput.numberOfLines = 0
   }

//   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      service.lyrics(artist: takeUserInputArtist , songTitle: takeUserInputTitle) { lyrics in
//         print("we get into service. lyrics: ")
//         guard let lyrics = lyrics else {
//            return
//         }
//         self.lyricOutput.text = lyrics
//         self.delegate?.lyricsSet(lyrics)
//      }
//   }
}

class SongViewController: UIViewController, SetLyricsDelegateProtocol {

   @IBOutlet weak var lyricsOutput: UILabel!

   var lyrics: String? = "Lyrics"

   // for delegate protocol
   func lyricsSet(_ lyrics: String) {
      self.lyrics = lyrics
   }

//   override func viewDidLoad() {
//      guard case lyricsOutput.text = lyrics?.lyrics else {
//         print("invalid lyrics") // prints
//         return
//      }
//      lyricsOutput.delegate = self
//      lyricsOutput.text = lyrics
//      print("lyricsin svc")
//      print(lyrics) // nil
//   }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? ViewController {
         destination.delegate = self
      }
   }

   @IBAction func showLyrics(_ sender: UIButton) {
      guard let lyrics = lyrics else {
         lyricsOutput.text = "Invalid Artist/Song title combo"
         return
      }
      print("in the show lyrics of svc")
      print(lyrics)
      lyricsOutput.text = "$\(lyrics)"
   }

//   func applyLyrics(_ lyrics: Lyrics) {
//      lyricsOutput.text = "Lyrics\n $\(lyrics.lyrics)"
//   }
}


//protocol SetLyricsDelegateProtocol: AnyObject {
//   func songViewController(_ viewController: SongViewController, didUpdateText text: String)
//}
//
//extension SongViewController: SetLyricsDelegateProtocol {
//   func songViewController(_ viewController: SongViewController, didUpdateText text: String) {
//      lyricsOutput.text = text
//   }
//}

protocol SetLyricsDelegateProtocol: AnyObject {
   func lyricsSet(_ lyrics: String)
}
//
//extension SongViewController: SetLyricsDelegateProtocol {
//   func lyricsSet(_ lyrics: Lyrics) {
//      applyLyrics(lyrics)
//   }
//}


