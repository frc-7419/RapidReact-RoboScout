//
//  AppDelegate.swift
//  RapidReactFKLEWJF
//
//  Created by William Chen on 2/21/22.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST_Sheets
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    var window: UIWindow?
    @Published var signedInUser: GIDGoogleUser?
    
    // MARK: - App Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Task {
            // We try to restore the signed-in user from the device Keychain (secure store)
            signedInUser = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
        // We could potentially have more URL handling parts of the code, so it's wise to check the return code of the `handle(_:)` call above.
        // However in this demo we will not have any more URL handlers
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    // MARK: - Google Sign-in Support
    // (Could also have this in a helper class instead of in the AppDelegate)
    /// Asynchronously attempts to sign in or restore a user's session. Will pop up an authentication browser as needed.
    @discardableResult
    func signInOrRestore(presenting viewController: UIViewController) async throws -> GIDGoogleUser {
        var user: GIDGoogleUser!
        do {
            user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        } catch {
            user = try await GIDSignIn.sharedInstance.signIn(presenting: viewController)
        }
        
        signedInUser = user
        return user
    }
    
    /// Sign out the user
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        signedInUser = nil
    }
}

// MARK: - Helper Extensions

extension UIApplication {
    static var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
}

extension Bundle {
    var googleSignInPlist: [String: String] {
        guard
            let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let plistData = try? Data(contentsOf: URL(fileURLWithPath: plistPath))
        else {
            preconditionFailure("Developer error, check if GoogleService-Info.plist is included in bundle!")
        }
        
        guard let plist = try? PropertyListSerialization.propertyList(from: plistData, options: .mutableContainers, format: nil) as? [String: String] else {
            preconditionFailure("Developer error, check if GoogleService-Info.plist is correctly formatted")
        }
        
        return plist ?? [:]
    }
}

extension GIDGoogleUser {
    var hasSheetsScope: Bool {
        grantedScopes?.contains(kGTLRAuthScopeSheetsSpreadsheets) ?? false
    }
}

extension GIDSignIn {
    var config: GIDConfiguration {
        GIDConfiguration(clientID: Bundle.main.googleSignInPlist["CLIENT_ID"] ?? "")
    }
    
    /*
     Below are just some wrapper functions I made in order to use the older-style API from the GoogleSignIn
     library with some new Swift 5.5 featues (async/await)
     
     Else we would have to use nested completion handlers and other stuff. This way, it's easier to read but
     async/await comes with a learning curve.
     */
    
    func restorePreviousSignIn() async throws -> GIDGoogleUser {
        try await withCheckedThrowingContinuation { continuation in
            restorePreviousSignIn { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(domain: GIDSignInError.errorDomain, code: GIDSignInError.unknown.rawValue, userInfo: nil))
                }
            }
        }
    }
    
    func signIn(presenting viewController: UIViewController) async throws -> GIDGoogleUser {
        try await withCheckedThrowingContinuation { continuation in
            let config = self.config
            DispatchQueue.main.async {
                // Calls to this function from the `catch` in `signInOrRestore(_:)` above may not run on the main thread.
                // Explicitly dispatch to main as a workaround
                self.signIn(with: config, presenting: viewController) { user, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    } else if let user = user {
                        continuation.resume(returning: user)
                    } else {
                        continuation.resume(throwing: NSError(domain: GIDSignInError.errorDomain, code: GIDSignInError.unknown.rawValue, userInfo: nil))
                    }
                }
            }
        }
    }
    
    func addScopes(scopes: [String], presenting viewController: UIViewController) async throws -> GIDGoogleUser {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                // Calls to this function from the `catch` in `signInOrRestore(_:)` above may not run on the main thread.
                // Explicitly dispatch to main as a workaround
                self.addScopes(scopes, presenting: viewController) { user, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    } else if let user = user {
                        for requestedScope in scopes {
                            if !(user.grantedScopes?.contains(requestedScope) ?? false) {
                                continuation.resume(throwing: NSError(domain: GIDSignInError.errorDomain, code: GIDSignInError.Code.canceled.rawValue, userInfo: nil))
                                return
                            }
                        }
                        UIApplication.appDelegate.signedInUser = user
                        continuation.resume(returning: user)
                    } else {
                        continuation.resume(throwing: NSError(domain: GIDSignInError.errorDomain, code: GIDSignInError.unknown.rawValue, userInfo: nil))
                    }
                }
            }
        }
    }
}
