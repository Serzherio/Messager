//
//  SectionHeader.swift
//  Messager
//
//  Created by Сергей on 14.11.2021.
//

import Foundation
import UIKit


class SectionHeader: UICollectionReusableView {
    static let reuseId = "SectionHeader"
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: self.topAnchor),
            self.title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    func configure(text: String, font: UIFont?, textColor: UIColor) {
        self.title.text = text
        self.title.font = font
        self.title.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
