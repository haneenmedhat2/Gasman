# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GasMan is a native iOS app (Swift/UIKit) for on-demand gas/fuel delivery — an e-commerce model similar to DoorDash but for gas products. It supports Arabic and English with full RTL layout.

## Build & Run

```bash
open GasMan.xcodeproj
```

Build and run via Xcode (scheme: **GasMan**). Dependencies are managed via **Swift Package Manager** — Xcode resolves them automatically on first open. There are no Makefile, fastlane, or test runner scripts.

## Architecture

The app follows **MVVM** with feature-based modules and **Combine** for reactive bindings.

### Feature Modules (`GasMan/App/`)

| Module | Purpose |
|---|---|
| `Auth/` | Login, signup, OTP verification, password reset |
| `Home/` | Product browsing, categories, sliders, location |
| `Order/` | Order listing, status tracking, details |
| `Cart/` | Cart display, address selection, checkout |
| `Chat/` | Real-time messaging via Socket.IO |
| `More/` | Profile, addresses, ratings, complaints, wallet, settings |
| `Notification/` | Push notification management |
| `LocationManager/` | CLLocation integration |
| `Intro/` | Splash screen |

### Base Classes

Every screen inherits from:
- **`BaseViewController`** (`Shared/View/BaseViewController/`) — navigation bar styling, loading indicators, deinit logging for memory leak detection
- **`BaseViewModel`** (`Shared/View/BaseViewController/BaseViewModel.swift`) — exposes `isLoadingPublisher`, `errorPublisher`, and `networkService` to all ViewModels

ViewModel protocols follow the pattern:
```swift
protocol FooVMProtocol {
    var fooPublisher: Published<BaseResponse<FooResponse>?>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
}
```

### Networking (`GasMan/Networking/`)

- **`NetworkService.swift`** — async/await API calls using Alamofire
- **`NetworkConstants.swift`** — base URL (`https://gasman.sa/api/`) and socket port (4897)
- **`Endpoint.swift`** — generic struct for defining API requests
- **`ResponseHandler.swift`** — decodes `BaseResponse<T>` and maps errors; pretty-prints JSON in DEBUG builds
- **`RequestHeaderType`** — `.authorized` (adds Bearer token) vs `.unauthorized`
- **`ResponseError`** — custom error enum with `.serverError`, `.unauthorized`, `.blockedUser` cases

### Shared Utilities (`GasMan/Shared/`)

- **`Session.swift`** — user session (token, user data, guest flag) persisted in `UserDefaults`
- **`AppHelper.swift`** — root VC transitions, URL opening, geocoding, user block/logout
- **`ValidationService.swift`** — reusable input validation (name, email, phone, password)
- **`Language.swift`** — bilingual support; call to switch EN/AR triggers RTL/LTR layout adjustment

### Localization

Multiple `.strings` table names in use:
- `Localizable` (default UI)
- `CoreLocalizable`, `HelperLocalizable`, `ValidationLocalized`, `PayLocalizable`

### Key Dependencies

| Library | Use |
|---|---|
| Alamofire | HTTP networking |
| Socket.IO | Real-time chat |
| Firebase (full suite) | Auth, push notifications, analytics, Firestore, remote config |
| GoogleMaps | Maps and geocoding |
| Kingfisher / SDWebImage | Image loading & caching |
| Lottie | Animated popups and loading states |
| IQKeyboardManager | Keyboard avoidance |
| Cosmos | Star rating UI |
