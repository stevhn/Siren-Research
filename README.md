# Siren
[Siren Github](https://github.com/ArtSabintsev/Siren)

A Library to check if user's currently installed version of iOS app is same with the version that is currently available in the App Store.
If different version then present alert / custom view.

## Installation
### Cocoapods
`Default` (`Swift 5.5+`)
```swift
pod 'Siren'
```

`Version Specific`
```swift
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift5.0'
```

## Implementation
### Default Configuration
```swift
Siren.shared.wail()
```
This will check current version with AppStore version using default configuration.

### Custom Configurations
We can declare set of rules for the frequency of version check or customize the Update app prompt UI.

Steps:
1. Use the shared instance of Siren
```swift
let siren = Siren.shared
```

2. Set the RulesManager
instantiate the `RulesManager object` that requires `Rules object` to `rulesManager` property of Siren.

we can set global rules
```swift
siren.rulesManager = RulesManager(globalRules: {RulesObject})
```
or with Major, Minor, Patch, and Revision specific rules implementations
```swift
siren.rulesManager = RulesManager(
    majorUpdateRules: {RulesObject},
    minorUpdateRules: {RulesObject},
    patchUpdateRules: {RulesObject},
    revisionUpdateRules: {RulesObject})
```

note: Check Example of `RulesObject` instantiation in [Rules Section](#rules).

3. Set the PresentationManager (Unnecessary if using custom UI)
```swift
siren.presentationManager = PresentationManager(
    alertTintColor: .brown,
    appName: "My Example App",
    alertTitle: "Please, Update Now!",
    skipButtonTitle: "Click here to skip!")
```

4. Perform version check
```swift
siren.wail { results in
    switch results {
    case .success:
        // do something
    case .failure(let error):
        // do something
    }
}
```

#### Rules
Set certain rules for how the app do the version check. Create an object `Rules` set it to `RulesManager` parameters.

`Rules` has two params:
```swift
Rules(
    promptFrequency frequency: UpdatePromptFrequency,
    forAlertType alertType: AlertType)
```
- `UpdatePromptFrequency`

How often a user should be prompted to update the app once a new version is available in the App Store.

`.immediately` = Version check performed every time the app is launched.

`.daily` = Version check performed once a day.

`.weekly` = Version check performed once a week.

- `AlertType`:

The type of alert that should be presented.

`.force` = Forces the user to update your app (native alert with 1 button).
![alt text](https://github.com/ArtSabintsev/Siren/blob/master/Assets/picForcedUpdate.png?raw=true)

`.option` = Presents the user with option to update app now or at next launch (native alert with 2 button).
![alt text](https://github.com/ArtSabintsev/Siren/blob/master/Assets/picOptionalUpdate.png?raw=true)


`.skip` = resends the user with option to update the app now, at next launch, or to skip this version all together (native alert with 3 button).
![alt text](https://github.com/ArtSabintsev/Siren/blob/master/Assets/picSkippedUpdate.png?raw=true)

`.none` = Doesn't present the native alert. Use this option to present a custom UI to the end-user.

Examples of `RulesObject` and aliases(static Rules variable):
```swift
1. Rules(promptFrequency: .immediately, forAlertType: .force) alias .critical
2. Rules(promptFrequency: .immediately, forAlertType: .option) alias .annoying
3. Rules(promptFrequency: .immediately, forAlertType: .skip) alias `default`
4. Rules(promptFrequency: .immediately, forAlertType: .none)

5. Rules(promptFrequency: .daily, forAlertType: .force)
6. Rules(promptFrequency: .daily, forAlertType: .option) alias .persistent
7. Rules(promptFrequency: .daily, forAlertType: .skip)
8. Rules(promptFrequency: .daily, forAlertType: .none)

9. Rules(promptFrequency: .weekly, forAlertType: .force)
10. Rules(promptFrequency: .weekly, forAlertType: .option) alias .hinting
11. Rules(promptFrequency: .weekly, forAlertType: .skip) alias .relaxed
12. Rules(promptFrequency: .weekly, forAlertType: .none)
```

#### Presentation Manager
Customization of the native alert UI. Only applies to `AlertType` other than `.none`.

note: Skip this step if using Custom UI and go to [Custom UI Section](#custom-ui).

`PresentationManager` params:
```swift
siren.presentationManager = PresentationManager(
    alertTintColor tintColor: UIColor? = nil,
    appName: String? = nil,
    alertTitle: String  = AlertConstants.alertTitle,
    alertMessage: String  = AlertConstants.alertMessage,
    updateButtonTitle: String  = AlertConstants.updateButtonTitle,
    nextTimeButtonTitle: String  = AlertConstants.nextTimeButtonTitle,
    skipButtonTitle: String  = AlertConstants.skipButtonTitle,
    forceLanguageLocalization forceLanguage: Localization.Language? = nil)
```
`alertTintColor` = The alert's tintColor. Settings this to `nil` defaults to the system default color.

`appName` = The name of the app (overrides the default/bundled name).

`alertTitle` = The title field of the `UIAlertController`.

`alertMessage` = The `message` field of the `UIAlertController`.

`nextTimeButtonTitle` = The "Next time" button text of the `UIAlertController`.

`updateButtonTitle` = The `title` field of the Update Button `UIAlertAction`.

`nextTimeButtonTitle` = The `title` field of the Next Time Button `UIAlertAction`.

`skipButtonTitle` = The `title` field of the Skip Button `UIAlertAction`.

`forceLanguage` = The language the alert to which the alert should be set. If `nil`, it falls back to the device's preferred locale.

Example:
```swift
let siren = Siren.shared
let rules = Rules(promptFrequency: .immediately, forAlertType: .skip)
siren.rulesManager = RulesManager(globalRules: rules)

siren.presentationManager = PresentationManager(
    alertTintColor: .purple,
    alertTitle: "Please Update My App",
    alertMessage: "We have New Features for you",
    updateButtonTitle: "Update Now",
    nextTimeButtonTitle: "Ask me Next Time",
    skipButtonTitle: "Skip this update")

siren.wail { results in
  switch results {
  case .success(let updateResults):
    print("AlertAction ", updateResults.alertAction)
    print("Localization ", updateResults.localization)
    print("Model ", updateResults.model)
    print("UpdateType ", updateResults.updateType)
  case .failure(let error):
    print(error.localizedDescription)
  }
}
```

![alt text](https://i.postimg.cc/4y0ZFZRC/Screen-Shot-2022-06-30-at-12-43-43.png)

#### Custom UI
Allows present our own view controller to handle the user action after Siren do the version check.

Example:

Assuming we're using storyboard and we have
- `ViewController.swift` -> VC where we want to perform check.
- `UpdateNowViewController.swift` -> Custom VC to prompt update.

then we want user to do checks each time app opened

We can do something like this
```swift
import UIKit
import Siren

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    checkWithCustomUI()
  }

  private func checkWithCustomUI() {
    let siren = Siren.shared
    let rules = Rules(promptFrequency: .immediately, forAlertType: .none)
    siren.rulesManager = RulesManager(globalRules: rules)

    siren.wail { results in
      switch results {
      case .success:
        self.presentVC()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func presentUpdateVC() {
    let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateNowViewController") as? UpdateNowViewController
    updateVC?.modalPresentationStyle = .overFullScreen
    updateVC?.modalTransitionStyle = .coverVertical
    self.navigationController?.present(updateVC!, animated: true)
  }
}
```

---
## Note:

More Examples on `ViewController.swift`, clone or download the repo. 

Reference [Siren Github](https://github.com/ArtSabintsev/Siren)
