//
//  CarouselView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 20/07/23.
//

import SwiftUI

struct CarouselView: View {
    
    @State var selection: Int = 1
    @State var timerAdded: Bool = false
    
    // total images
    let maxCount: Int = 8
    
    var body: some View {
        TabView(selection: $selection, content: {
            ForEach(1..<maxCount, id: \.self) { count in
                Image("dog\(count)")
                    .resizable()
                    .scaledToFill()
                    .tag(count)
            }
        })
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .animation(.default)
        .onAppear(perform: {
            // to prevent addTimer called multile times
            if !timerAdded {
                // call the function immediately when this screen is on focus
                addTimer()
            }
        })
    }
    
    // MARK: FUNCTIONS
    
    func addTimer() {
        timerAdded = true
        // every 5 seconds this function will update
        // the $selection var so the carousel slides automatically
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
            
            if selection == (maxCount - 1) {
                // reset the selection and start from the first image
                selection = 1
            } else {
                selection += 1
            }
        }
        
        timer.fire()
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
            .previewLayout(.sizeThatFits)
    }
}
