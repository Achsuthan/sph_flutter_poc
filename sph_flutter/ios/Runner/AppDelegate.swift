import UIKit
import Flutter
import Tambourine

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        flutterEngine.run()
        
        // Get Flutter view controller
        let controller = window?.rootViewController as! FlutterViewController
        
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.setNavigationBarHidden(true, animated: false) // Hide nav bar
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // Setup method channels
        setupNavigationChannel(controller: controller)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupNavigationChannel(controller: FlutterViewController) {
        let channel = FlutterMethodChannel(
            name: "com.yourapp/native_channel",
            binaryMessenger: controller.binaryMessenger
        )
        
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            
            if call.method == "simpleFunction" {
                self.simpleFunction()
                result(nil)
            }
            else if call.method == "pushNativeScreen" {
                let args = call.arguments as? [String: Any]
                let screenName = args?["screenName"] as? String ?? ""
                let data = args?["data"] as? [String: Any]
                
                self.pushNativeScreen(screenName: screenName, data: data)
                result(nil)
                
            } else if call.method == "popScreen" {
                self.popScreen()
                result(nil)
                
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func pushNativeScreen(screenName: String, data: [String: Any]?) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first,
                  let navController = window.rootViewController as? UINavigationController else {
                print("❌ No navigation controller found")
                return
            }
            
            var nativeVC: UIViewController
            
            switch screenName {
            case "Profile":
                let profileVC = ProfileViewController()
                profileVC.userId = data?["userId"] as? String
                nativeVC = profileVC
                
            case "Settings":
                nativeVC = SettingsViewController()
                
            case "AudioPlayer":
                nativeVC = AudioPlayerViewController()
                
            default:
                nativeVC = UIViewController()
                nativeVC.view.backgroundColor = .white
            }
            
            nativeVC.title = screenName
            navController.pushViewController(nativeVC, animated: true)
        }
    }
    
    // Pop back to Flutter
    private func popScreen() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first,
                  let navController = window.rootViewController as? UINavigationController else {
                return
            }
            navController.popViewController(animated: true)
        }
    }
    
    // Your existing function (keep this)
    private func simpleFunction() {
        print("Simple function called from Flutter!")
        TambourinePlayerService.shared.play(Podcast())
    }
}


// ProfileViewController.swift
class ProfileViewController: UIViewController {
    
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Native Profile"
        
        // Show back button
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "Native iOS Profile Screen\nUser ID: \(userId ?? "N/A")\n\n✅ Pushed from Flutter!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide nav bar when going back to Flutter
        if isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
}

// SettingsViewController.swift
class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Native Settings"
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "Native iOS Settings Screen\n\n✅ Pushed from Flutter!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
}

// AudioPlayerViewController.swift (Example with Tambourine integration)
class AudioPlayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Audio Player"
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupUI()
    }
    
    private func setupUI() {
        let playButton = UIButton(type: .system)
        playButton.setTitle("Play Podcast from Native", for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        playButton.backgroundColor = .systemBlue
        playButton.setTitleColor(.white, for: .normal)
        playButton.layer.cornerRadius = 12
        playButton.addTarget(self, action: #selector(playPodcast), for: .touchUpInside)
        
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 300),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func playPodcast() {
        // Use your existing Tambourine integration
        TambourinePlayerService.shared.play(Podcast())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
}

// Keep all your existing Tambourine code below...
// (Chapters, Podcast, TambourinePlayerService, etc.)

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


