//
//  SegmentedControlExtension.swift
//  Messager
//
//  Created by Сергей on 06.11.2021.
//

import UIKit

// extension with custon init for UISegmentedControl class,
// init with two string params to name segments of UISegmentedControl
extension UISegmentedControl {
    
    convenience init (first: String, second: String) {
        self.init()
        self.insertSegment(withTitle: first, at: 0, animated: true)
        self.insertSegment(withTitle: second, at: 1, animated: true)
        self.selectedSegmentIndex = 0
    }
    
}
