import UIKit
import Flutter
import Tambourine

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.yourapp/native_channel",
            binaryMessenger: controller.binaryMessenger
        )
        
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "simpleFunction" {
                self.simpleFunction()
                result(nil)  // Return nothing
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func simpleFunction() {
        // Your iOS code here
        print("Simple function called from Flutter!")
        TambourinePlayerService.shared.play(Podcast())
        
        // Do whatever you want
        // Example: Show alert, save data, access native features, etc.
    }
}

class Chapters: ChapterText {
    var name: String
    var time: Float

    init(name: String, time: Float) {
        self.name = name
        self.time = time
    }
}

class Podcast: PodcastMedia,
    Downloadable,
    Followable,
    Enqueable,
    Likable,
    Shareable,
    SeekableDataSource
{
    func updateDuration(_ duration: Double) {
        self.totalDuration = duration
    }
    
    var isHiddenLikeFeature: Bool { return false }
    
    var isHiddenFollowFeature: Bool { return false }
    
    var mediaHeader: String?

    var header: String?

    var resumeTime: Double {
        return 0.0
    }

    var chapterTexts: [ChapterText] = [Chapters(name: "Stroke among younger age groups", time: 75),
                                       Chapters(name: "Stroke survivors disabled after 1 year", time: 195),
                                       Chapters(name: "Risk of recurring stroke", time: 250),
                                       Chapters(name: "How low can monthly CI coverage go?", time: 399),
                                       Chapters(name: "Case of patient with small ischaemic stroke", time: 551),
                                       Chapters(name: "Critical illness: Riders to cover recurrence", time: 714)]

    var isLiked: Bool = false
    var enqueable: MediaStatus = .eNotQueued
    var followed: MediaStatus = .eUnfollowed
    var downloadState: DownloadState = .eNotDownloaded

    var filePath: String?

    var mediaId: String = "d843c814-bbee-4705-8b84-af4d00e6cffd"

    var mediaType: PlayerMediaType = .ePodcast

    var title: String = "Protect your health and your wealth from your 20s"

    var subtitle: String? = "15 Nov, 2022"

    var coverImage: String? = "https://www.omnycontent.com/d/clips/d9486183-3dd4-4ad6-aebe-a4c1008455d5/7b9454a5-2183-42b4-882a-abdb0017cb67/d843c814-bbee-4705-8b84-af4d00e6cffd/image.jpg?t=1668434609&in_playlist=4a788df0-c9e7-49c2-bf28-abdb0017cb6c&size=Medium"

    // Total duration in seconds
    var totalDuration: Double = 802.873

    var shareUrl: String? = "https://stg.awedio.sg/podcast-ep/d843c814-bbee-4705-8b84-af4d00e6cffd"

    var audioUrl: String? = "https://chrt.fm/track/8B5GC9/traffic.omny.fm/d/clips/d9486183-3dd4-4ad6-aebe-a4c1008455d5/7b9454a5-2183-42b4-882a-abdb0017cb67/d843c814-bbee-4705-8b84-af4d00e6cffd/audio.mp3?in_playlist=4a788df0-c9e7-49c2-bf28-abdb0017cb6c"

    var color: UIColor?
}

protocol TambourinePlayerServiceProtocol {
    func play(_ media: PlayerMedia?)
    func stopAudio()
    func getCurrentMedia() -> PlayerMedia?
    func updateLanguage(language: Language)
    func gotoTimeStamp(timeInSeconds: Float)
    func adjustFloatingPlayer(bottomConstant: CGFloat, includesSafeAreaInset: Bool, isTabBarHidden: Bool)
}

extension TambourinePlayerServiceProtocol {

    func adjustFloatingPlayer(bottomConstant: CGFloat = .zero, includesSafeAreaInset: Bool = true, isTabBarHidden: Bool = false) {
        adjustFloatingPlayer(bottomConstant: bottomConstant, includesSafeAreaInset: includesSafeAreaInset, isTabBarHidden: isTabBarHidden)
    }
}

class TambourinePlayerService: TambourinePlayerServiceProtocol {
    static let shared: TambourinePlayerServiceProtocol = TambourinePlayerService()

    private init() {
        let config = TambourineConfiguration(language: .english,
                                             isHiddenSeeAllButton: false,
                                             showButtonDescription: true,
                                             showHeaderListingFor: [.eTts],
                                             ttsSpeed: 0.5,
                                             floatingPlayerFrameConstraints: .init(bottomConstraint: .zero,
                                                                                   includesSafeAreaInset: true,
                                                                                   isTabBarHidden: false))
        
        SPHAudioPlayer.shared.setupPlayer(configuration: config,
                                          tambourinePlayerInput: self,
                                          tambourinePlayerListener: self,
                                          tambourineTextToSpeechInput: self,
                                          tambourineTextToSpeechListener: self,
                                          tambourineCarPlayListener: self)
    }

    // MARK: - Public methods

    func play(_ media: PlayerMedia? = nil) {
        SPHAudioPlayer.shared.play(media)
    }

    func stopAudio() {
        SPHAudioPlayer.shared.stop()
    }

    func getCurrentMedia() -> PlayerMedia? {
        SPHAudioPlayer.shared.getCurrentMedia()
    }

    func updateLanguage(language: Language) {
        SPHAudioPlayer.shared.updateLanguage(language: language)
    }

    func gotoTimeStamp(timeInSeconds: Float) {
        SPHAudioPlayer.shared.gotoTimeStamp(timeInSeconds: timeInSeconds)
    }

    func setSpeed(newSpeed: Float) {
        SPHAudioPlayer.shared.setSpeed(newSpeed: newSpeed)
    }

    // Get Mini or floating player height
    func floatingPlayerHeight() -> CGFloat {
        SPHAudioPlayer.shared.floatingPlayerHeight
    }

    /// Update Floating player bottom constraint whenever requried
    /// - Parameters:
    ///   - bottomConstant: Bottom constraint for the floating player
    ///   - includesSafeAreaInset: Set true if needs to add SafeAreaInset to the bottom constraint of the floating player
    func adjustFloatingPlayer(bottomConstant: CGFloat, includesSafeAreaInset: Bool, isTabBarHidden: Bool) {
        let frameConstraints = FloatingPlayerFrameConstraints(bottomConstraint: bottomConstant, includesSafeAreaInset: includesSafeAreaInset, isTabBarHidden: isTabBarHidden)
        SPHAudioPlayer.shared.adjustFloatingPlayer(frameConstraints: frameConstraints)
    }
}

extension TambourinePlayerService: TambourinePlayerInput {
    func getPreviousAndNextMedia(for media: PlayerMedia) -> (previousMedia: PlayerMedia?, nextMedia: PlayerMedia?) {
        return (nil, nil)
    }

    func getRadioStreamer() -> Streamer? {
        return nil
    }

    func getRadioStationInfo(for _: PlayerMedia, completion _: (String, String?, String?) -> Void) {}
}

// MARK: - TambourinePlayerListener

extension TambourinePlayerService: TambourinePlayerListener {
    func onLoggingError(error: any Error) {
        debugPrint(error)
    }
    
    func onLoggingError(message: String) {}
    
    func showAllEpisode() {}
    
    func tapOnMediaTitle() {}
    
    func closeFloatingPlayer() {}
    
    func viewWillAppear() {}

    func clickAction(type _: Tambourine.PlayerType, media _: Tambourine.PlayerMedia, buttonType _: Tambourine.PlayerButtonType) {}

    func playerStateDidChange(_: PlayerState, media _: PlayerMedia) {}

    func performMediaAction(for status: MediaStatus, media _: PlayerMedia, completion: @escaping (Result<MediaStatus, NSError>) -> Void) {
        completion(.success(status))
    }

    func mediaAction(for status: MediaStatus, type _: PlayerMediaType, media _: PlayerMedia, completion: @escaping (MediaStatus) -> Void) {
        completion(status)
    }
}

extension TambourinePlayerService: TambourineCarPlayListener {
    func playerStateDidChange(_ state: PlayerState) {
        debugPrint("TambourineCarPlayListener :: playerStateDidChange : ", state)
    }

    func userSelect(mediaSequence: MediaSequence) {
        debugPrint("TambourineCarPlayListener :: userSelect mediaSequence: ", mediaSequence)
    }
}

// MARK: TambourineTextToSpeechInput

extension TambourinePlayerService: TambourineTextToSpeechInput {
    ///  array of TextToSpeechMedia to display in listing page
    /// - Returns: array of  model confrims TextToSpeechMedia
    func getAllArticles() -> [TextToSpeechMedia] {
        return []
    }
}

// MARK: TambourineTextToSpeechListener

extension TambourinePlayerService: TambourineTextToSpeechListener {
    func speedDidChanged(_ speed: Float) {
        debugPrint("speed changes", speed)
    }

    func didSelectListing(media: TextToSpeechMedia, completion: ((Bool) -> Void)?) {
        completion?(true)
        SPHAudioPlayer.shared.play(media)
    }

    func didSelectArticle(article _: TextToSpeechMedia) {
        debugPrint("didSelectArticle")
    }
}


