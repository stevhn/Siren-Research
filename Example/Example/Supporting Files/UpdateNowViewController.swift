//
//  UpdateNowViewController.swift
//  Example
//
//  Created by Stevhen on 30/06/22.
//  Copyright © 2022 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

protocol UpdateNowViewControllerDelegate: AnyObject {
  func didTapUpdate()
}

final class UpdateNowViewController: UIViewController {
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var mainView: UIView!

  // MARK: - Variables
  private let maxDimmedAlpha: CGFloat = 0.6
  weak var delegate: UpdateNowViewControllerDelegate?

  // MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundView.alpha = 0
    mainView.clipsToBounds = true
    mainView.layer.cornerRadius = 10.0
    mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateDismissView))
    backgroundView.addGestureRecognizer(tapGesture)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateShowDimmedView()
  }

  func animateShowDimmedView() {
    UIView.animate(withDuration: 0.5) {
      self.backgroundView.alpha = self.maxDimmedAlpha
    }
  }

  @objc func animateDismissView() {
    // hide main container view
    UIView.animate(withDuration: 0.3) {
      self.mainView.isHidden = true
    }

    // hide blur view
    backgroundView.alpha = maxDimmedAlpha
    UIView.animate(withDuration: 0.4) {
      self.backgroundView.alpha = 0
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }

  @IBAction func didTapUpdate(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      self.mainView.isHidden = true
    }

    // hide blur view
    backgroundView.alpha = maxDimmedAlpha
    UIView.animate(withDuration: 0.4) {
      self.backgroundView.alpha = 0
    } completion: { _ in
      self.dismiss(animated: true) {
        self.delegate?.didTapUpdate()
      }
    }
  }
}
