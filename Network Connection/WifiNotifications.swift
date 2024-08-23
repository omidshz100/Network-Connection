//
//  WifiNotifications.swift
//  Network Connection
//
//  Created by Omid Shojaeian Zanjani on 24/08/24.
//

import SwiftUI

struct WifiNotifications: View {
    
    @Binding var isConnected:Bool
    
    
    var body: some View {
        HStack(spacing: 16, content: {
            Image(systemName: isConnected ? "wifi":"wifi.slash")
                .foregroundStyle(isConnected ? .green:.red)
                .font(.title2)
            
            Text(isConnected ? "Internet connection restored!":"Internet connection lost")
        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(.thinMaterial, in: .rect(cornerRadius: 20))
        
    }
}

#Preview {
    ContentView()
}
