//
//  SignInWithAppleButtonCustom.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 08/08/23.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonCustom: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        return ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    }
        
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}
