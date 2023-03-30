//
//  UIColor+Extension.swift
//  MoneyLover
//
//  Created by xhieu21 on 14/03/2023.
//

import UIKit

extension UIColor {

  convenience init(hexString: String, alpha: CGFloat = 1.0) {
    var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if cString.hasPrefix("#") {
      cString.remove(at: cString.startIndex)
    }

    if cString.count != 6 {
      self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: alpha)
      return
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }

}
