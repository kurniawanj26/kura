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
    
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIView(context: Context) -> some UIView {
        return ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: colorScheme == .light ? .black : .white)
    }
        
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}
