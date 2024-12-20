//
//  Account.swift
//  Momentum
//
//  Created by Auggie Dev on 12/17/24.
//

import SwiftUI

struct Account: View {

    var body: some View {
        NavigationView {
            VStack {
                
            }
            .navigationTitle("Account Page")
            .toolbar {
                          ToolbarItem(placement: .navigationBarTrailing) {
                              NavigationLink(destination: Settings()) {
                                  Image(systemName: "gearshape")
                                      .imageScale(.large)
                              }
                          }
                      }
        }


      
    }
}

#Preview {
    Account()
}
