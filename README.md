# SocialKit
Fetching user's' address book local contacts and built-in customizable screen for sending invitations or adding as friend.

<p align="center">
  <img src="https://github.com/macistador/SocialKit/blob/main/IconSocialKit.png" width="300" height="300"/>
</p>

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Other packages](#other-packages)
- [Credits](#credits)
- [License](#license)

## Features

- [x] Service for safely fetching local address book contacts
- [x] BuiltIn SwiftUI customizable Contacts Picker
- [x] BuiltIn send text message
- [x] Include your own custom user to the ContactPicker 
- [x] Enrich your custom users with address book matching data 
- [x] Include permission pre-prompt and reoptin 
- [x] Set custom CacheService to improve fetching performance
- [x] Set custom UploadContactsService to sync the address book contacts to your backend
- [ ] Write sample with cache

## Requirements

- iOS 15.0+
- Xcode 12.0+
- Swift 5.5+

## Installation

### SwiftPackageManager

```swift
dependencies: [
    .package(url: "https://github.com/macistador/ContactsKit", from: "0.0.1")
]
```

## Usage

### Preview

__BuiltIn SwiftUI View__
```swift
let sections: [ContactsPickerSection<User>] = [.localContacts(title: "My Contacts",
                                                              actionKind: .sendMessage(title: "invite", body: "Hey buddy, join me to this cool app!"))]

ContactsPicker<User, EmptyView>(sections: sections) { contact, actionResult in
    print("Contact tapped: \(contact)")
}
```

__Service only__
```swift
do {
    let contacts = try await contactsSerivce.fetchAllLocalContacts()
} catch {
    print("An error occurred: \(error.localizedDescription)")
}
```


For more details you may take a look at the sample project.

## Other packages

Meanwhile this library works well alone, it is meant to be complementary to the following app bootstrap packages suite: 

- [CoreKit](https://github.com/macistador/CoreKit): Foundation app requirements: Routing, State management, logging...
- [BackendKit](https://github.com/macistador/BackendKit): Handling remote requests, authentication for Firebase / Supabase
- [DesignKit](https://github.com/macistador/DesignKit): DesignSystem
- [VisualKit](https://github.com/macistador/VisualKit): UI components (SwiftUI Views, ViewModifiers)
- [MediasKit](https://github.com/macistador/MediasKit): Loading, caching & displaying Images, Videos, Audios
- [CameraKit](https://github.com/macistador/CameraKit): Capturing photos, videos and audio with effects
- [PermissionsKit](https://github.com/macistador/PermissionsKit): User permissions handling
- [SocialKit](https://github.com/macistador/SocialKit): Share, invite friends
- [CartoKit](https://github.com/macistador/CartoKit): Locate, display maps
- [AnalyzeKit](https://github.com/macistador/AnalyzeKit): Analytics
- [IntelligenceKit](https://github.com/macistador/IntelligenceKit): Integrate embedded AI models
- [AdsKit](https://github.com/macistador/AdsKit): Displaying ads
- [PayKit](https://github.com/macistador/PayKit): Handling paywalls & inApps

## Credits

SocialKit is developed and maintained by Michel-André Chirita. You can follow me on Twitter at @Macistador for updates.

## License

SocialKit is released under the MIT license. [See LICENSE](https://github.com/macistador/SocialKit/blob/master/LICENSE) for details.
