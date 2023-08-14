//
//  LazyView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 14/08/23.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    
    var content: () -> Content
    
    var body: some View {
        self.content()
    }
}
