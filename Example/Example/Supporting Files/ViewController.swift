//
//  ViewController.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit
import Siren

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

//    defaultExampleUsingCompletionHandler()
//    manualExampleWithCompletionHandler()
//    minimalCustomizationPresentationExample()
//    customMessagingPresentationExample()
//    annoyingRuleExample()
//    updateSpecificRulesExample()
//    customPresentationManager()
//    complexExample()
    checkWithCustomUI()
  }

  // MARK: - Implementation Examples
  /// All default rules are implemented and the
  /// results of the completion handler are returned or an error is returned.
  func defaultExampleUsingCompletionHandler() {
    Siren.shared.wail { results in
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
  }

  /// Siren's version checking and alert presentation methods will be triggered each time this method is called.
  func manualExampleWithCompletionHandler() {
    Siren.shared.wail(performCheck: .onDemand) { results in
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
  }

  /// Minor customization to Siren's update alert presentation.
  func minimalCustomizationPresentationExample() {
    let siren = Siren.shared
    siren.rulesManager = RulesManager(globalRules: .annoying)
    siren.presentationManager = PresentationManager(
      alertTintColor: .purple,
      appName: "Siren Example App Override!")
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
  }

  /// Example on how to change specific strings in the update alert.
  func customMessagingPresentationExample() {
    let siren = Siren.shared
    siren.presentationManager = PresentationManager(
      alertTitle: "Update Now, OK?",
      nextTimeButtonTitle: "Next time, please!?")
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
  }

  /// How to present an alert every time the app is foregrounded.
  func annoyingRuleExample() {
    let siren = Siren.shared
    siren.rulesManager = RulesManager(globalRules: .annoying)

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
  }

  /// Major, Minor, Patch, and Revision specific rules implementations.
  func updateSpecificRulesExample() {
    let siren = Siren.shared
    siren.rulesManager = RulesManager(
      majorUpdateRules: .critical,
      minorUpdateRules: .annoying,
      patchUpdateRules: .default,
      revisionUpdateRules: Rules(promptFrequency: .weekly, forAlertType: .option))

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
  }

  /// An example on how to present your own custom alert.
  private func customPresentationManager() {
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
  }

  /// An example on how to customize multiple managers at once.
  func complexExample() {
    let siren = Siren.shared
    siren.presentationManager = PresentationManager(
      alertTintColor: .brown,
      appName: "Siren's Complex Rule Example App",
      alertTitle: "Please, Update Now!",
      skipButtonTitle: "Click here to skip!")
    siren.rulesManager = RulesManager(
      majorUpdateRules: .critical,
      minorUpdateRules: .annoying,
      patchUpdateRules: .default,
      revisionUpdateRules: .relaxed)

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
  }

  /// An example on show check with custom UI.
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

  private func presentVC() {
    let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateNowViewController") as? UpdateNowViewController
    updateVC?.delegate = self
    updateVC?.modalPresentationStyle = .overFullScreen
    updateVC?.modalTransitionStyle = .coverVertical
    self.navigationController?.present(updateVC!, animated: true)
  }
}

extension ViewController: UpdateNowViewControllerDelegate {
  func didTapUpdate() {
    print("Update App - Direct to AppStore")
  }
}
