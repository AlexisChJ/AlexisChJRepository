//
//  Water.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 06/10/24.
//

import Foundation

class AP: Identifiable{
    var value:Int
    var timeStamp:Date
    init(value: Int, timeStamp: Date) {
        self.value = value
        self.timeStamp = timeStamp
    }
}
