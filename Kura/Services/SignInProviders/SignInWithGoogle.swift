//
//  SignInWithGoogle.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 10/08/23.
//

import Foundation
import SwiftUI
import GoogleSignIn
import FirebaseAuth

class SignInWithGoogle: NSObject, GIDSignInDelegate {
    
    static let instance = SignInWithGoogle()
    var onboardingView: OnboardingView!
    
    func startSignInWithGoogleFlow(view: OnboardingView) {
        self.onboardingView = view
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance().presentingViewController.modalPresentationStyle = .fullScreen
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("ERROR SIGN IN WITH GOOGLE")
            self.onboardingView.showError.toggle()
            return
        }
        
        let fullName: String = user.profile.name
        let email: String = user.profile.email
        
        let idToken: String = user.authentication.idToken
        let accessToken: String = user.authentication.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        print("SIGN IN TO FIREBASE NOW. NAME: \(fullName), EMAIL: \(email)")
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("USER DISCONNECTED FROM GOOGLE")
        self.onboardingView.showError.toggle()
    }
}
