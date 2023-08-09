//
//  PostImageView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 29/07/23.
//

import SwiftUI

struct PostImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var captionText: String = ""
    @Binding var  imageSelected: UIImage
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            HStack {
                Button(action: {
                    // dismiss the view
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                })
                .accentColor(.primary)
                
                Spacer()
            }
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    Image(uiImage: imageSelected)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200, alignment: .center)
                        .cornerRadius(12)
                        .clipped()
                    
                    TextField("Add your caption here..", text: $captionText)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor)
                        .cornerRadius(12)
                        .font(.headline)
                        .padding(.horizontal)
                        .autocapitalization(.sentences)
                    
                    Button(action: {
                        postPicture()
                    }, label: {
                        Text("Post picture".uppercased())
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                            .cornerRadius(12)
                            .padding()
                    })
                    .accentColor(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
                })
        })
    }
    
    // MARK: FUNCTIONS
    
    func postPicture() {
        print("Posting the picture...")
    }
    
}

struct PostImageView_Previews: PreviewProvider {
    
    @State static var image = UIImage(named: "dog1")!
    static var previews: some View {
        PostImageView(imageSelected: $image)
    }
}
