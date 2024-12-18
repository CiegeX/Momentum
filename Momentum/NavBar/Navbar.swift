//
//  SwiftUIView.swift
//  Momentum
//
//  Created by Auggie Dev on 12/17/24.
//

import SwiftUI

struct Navbar: View {
    var body: some View {
        TabView {
            Tab("Timer", systemImage: "clock"){
                Timer()
            }
            Tab("LockApp", systemImage: "lock"){
                LockApp()
            }
            Tab( "AI" , systemImage: "plus"){
                AI()
            }
            Tab("Social", systemImage: "person"){
                Social()
            }
            Tab( "Account" , systemImage: "gear"){
                Account()
            }
            
        
            
        }
    }
}

#Preview {
    Navbar()
}
