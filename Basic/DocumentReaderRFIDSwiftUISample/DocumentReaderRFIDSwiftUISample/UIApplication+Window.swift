//
//  UIApplication+Window.swift
//  DocumentReaderRFIDSwiftUISample
//
//  Created by Serge Rylko on 31.01.24.
//

import Foundation
import UIKit

extension UIApplication {
  var firstKeyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive }
      .first?.windows
      .first(where: \.isKeyWindow)
  }
}
