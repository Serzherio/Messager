//
//  ConfigureCellProtocol.swift
//  Messager
//
//  Created by Сергей on 09.11.2021.
//

import Foundation

protocol ConfiguringCell {
    static var reuseId: String {get}
    func configure<U: Hashable>(with value: U)
}
