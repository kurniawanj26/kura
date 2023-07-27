//
//  BrowseView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 20/07/23.
//

import SwiftUI

struct BrowseView: View {
    
    var posts = PostArrayObject()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            CarouselView()
            ImageGridView(posts: posts)
        })
        .navigationTitle("Browse")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        
        // need to wrap the BrowseView
        // so the title shows up
        NavigationView {
            BrowseView()
        }
    }
}
