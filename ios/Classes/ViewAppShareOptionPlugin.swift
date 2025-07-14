import Flutter
import UIKit
import UniformTypeIdentifiers
import MobileCoreServices

public class ViewAppShareOptionPlugin: NSObject, FlutterPlugin {
  private var sharedFileChannel: FlutterMethodChannel?
  private let supportedExtensions = ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx"]

  private static var instance: ViewAppShareOptionPlugin?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = ViewAppShareOptionPlugin()
    instance.sharedFileChannel = FlutterMethodChannel(name: "view_app_share_option", binaryMessenger: registrar.messenger())
    registrar.addApplicationDelegate(instance)
    instance.sharedFileChannel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getSharedFile" {
        if let filePath = UserDefaults.standard.string(forKey: "lastSharedFilePath") {
          result(filePath)
        } else {
          result("")
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    Self.instance = instance
  }

  public func application(_ application: UIApplication,
                         open url: URL,
                         options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("open url received: \(url)")
    return handleIncomingURL(url)
  }

  public func application(_ application: UIApplication,
                         continue userActivity: NSUserActivity,
                         restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    print("userActivity received: \(userActivity.activityType)")
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      return handleIncomingURL(url)
    } else if userActivity.activityType == "com.apple.documentManager.documentInteraction",
              let url = userActivity.userInfo?["url"] as? URL {
      return handleIncomingURL(url)
    }
    return false
  }

  private func handleIncomingURL(_ url: URL) -> Bool {
    print("Received URL: \(url)")
    let fileExtension = url.pathExtension.lowercased()

    guard supportedExtensions.contains(fileExtension) else {
      print("Unsupported file type: \(fileExtension)")
      return false
    }

    let fileManager = FileManager.default
    let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destinationPath = documentsPath.appendingPathComponent(url.lastPathComponent)

    do {
      if fileManager.fileExists(atPath: destinationPath.path) {
        try fileManager.removeItem(at: destinationPath)
      }

      if url.isFileURL {
        let isSecurityScoped = url.startAccessingSecurityScopedResource()
        defer {
          if isSecurityScoped {
            url.stopAccessingSecurityScopedResource()
          }
        }
        try fileManager.copyItem(at: url, to: destinationPath)
      } else {
        let data = try Data(contentsOf: url)
        try data.write(to: destinationPath)
      }

      UserDefaults.standard.set(destinationPath.path, forKey: "lastSharedFilePath")

      DispatchQueue.main.async {
        self.sharedFileChannel?.invokeMethod("onFileShared", arguments: nil)
      }

      return true
    } catch {
      print("Error handling file: \(error)")
      return false
    }
  }
}