//
//  ContentView.swift
//  Network Connection
//
//  Created by Omid Shojaeian Zanjani on 23/08/24.
//

import SwiftUI
import Network

struct ContentView: View {
    
    
    // ٰView Properties
    @State var isConnected:Bool = false
    @State var showNotification:Bool = false
    @State var wasDisconnected:Bool = false
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    var body: some View {
        ZStack {
            if !isConnected {
                ConnectionLost()
            }else{
                Text("our view for showing we have Connection")
                    .bold()
                    .font(.largeTitle)
                
            }
            
            WifiNotifications(isConnected: $isConnected)
                .frame(maxHeight: .infinity, alignment: .top)
                .offset(y: showNotification ? 0: -200)
        }
        .padding()
        .onAppear(){
            startMonitoring()
        }
    }
    
    // View for when connection is not available
    @ViewBuilder
    func ConnectionLost() -> some View {
        VStack(spacing: 10, content: {
            Image(systemName: "wifi.slash")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            
            Text("Internet Connection lost")
                .font(.title.bold())
                .foregroundStyle(.primary)
            Text("Please check your connection or go to wifi settings to reconnect.")
                .font(.caption)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
            Button(action: {
                openWifiSetting()
            }) {
                Text("Open Setting")
                    .font(.headline)
            }
            .tint(.blue)
            .buttonStyle(BorderedButtonStyle.bordered)
        })
    }
    
    func openWifiSetting(){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // check if connection is available
    func startMonitoring(){
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let currectState = path.status == .satisfied
                if self.isConnected != currectState {
                    if currectState{
                        if self.wasDisconnected {
                            self.showNotification = true
                            
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2){
                                withAnimation {
                                    self.showNotification = false
                                }
                            }
                        }
                    }else {
                        self.showNotification = true
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2){
                            withAnimation {
                                self.showNotification = false
                            }
                        }
                        self.wasDisconnected = true
                    }
                    
                    self.isConnected = currectState
                }
            }
        }
        
        monitor.start(queue: queue)
    }
}

#Preview {
    ContentView()
}


