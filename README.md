### Network Connection Monitor

This SwiftUI application monitors the network connectivity status of an iOS device and provides visual feedback to the user when the connection is lost or restored. It uses the `Network` framework to observe network changes in real-time and updates the UI accordingly.

 Features

- Real-time Network Monitoring: Detects changes in network connectivity status.
- User Notification: Shows a notification banner when the network connection is lost or restored.
- Wi-Fi Settings Shortcut: Provides a button to open the Wi-Fi settings if the connection is lost.

 Screenshots

*Add screenshots of your app here.*

 How It Works

 1. Network Monitoring
The app uses `NWPathMonitor` from the `Network` framework to observe the network status. When the network status changes, the app updates the UI to reflect the current state.

```swift
let monitor = NWPathMonitor()
let queue = DispatchQueue(label: "NetworkMonitor")
```

 2. UI Structure

- `ContentView`: The main view that holds the logic for showing the connection status.
- `ConnectionLost`: A custom view that is displayed when the network connection is lost.
- `WifiNotifications`: Displays a banner notification when the connection is lost or restored.

 3. ConnectionLost View
When the network connection is lost, this view is displayed to inform the user and provide a shortcut to the Wi-Fi settings.

```swift
@ViewBuilder
func ConnectionLost() -> some View {
    VStack(spacing: 10) {
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
    }
}
```

 4. Opening Wi-Fi Settings
The app includes a button that allows users to quickly navigate to the Wi-Fi settings if their connection is lost.

```swift
func openWifiSetting() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
```

 5. Network State Change Handling
The app checks the network status and displays the appropriate UI based on whether the device is connected to the internet or not.

```swift
func startMonitoring() {
    monitor.pathUpdateHandler = { path in
        DispatchQueue.main.async {
            let currentState = path.status == .satisfied
            if self.isConnected != currentState {
                if currentState {
                    if self.wasDisconnected {
                        self.showNotification = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.showNotification = false
                            }
                        }
                    }
                } else {
                    self.showNotification = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.showNotification = false
                        }
                    }
                    self.wasDisconnected = true
                }
                self.isConnected = currentState
            }
        }
    }
    monitor.start(queue: queue)
}
```

 Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/network-connection-monitor.git
   ```

2. Open the project:
   Open the `Network Connection.xcodeproj` file in Xcode.

3. Run the app:
   Run the app on a simulator or physical device to monitor network connectivity.

 Requirements

- Xcode 12 or later
- iOS 14.0 or later
- Swift 5.0 or later

 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

 Contributing

If you'd like to contribute to this project, feel free to open an issue or submit a pull request.
