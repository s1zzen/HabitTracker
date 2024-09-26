//
//  UITextField+Extension.swift
//  HabitTracker
//
//  Created by Сергей Баскаков on 28.07.2024.
//

import UIKit

extension UITextField {

    func indent(size: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
