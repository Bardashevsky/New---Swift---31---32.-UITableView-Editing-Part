//
//  OBStudent.swift
//  New - Swift - 31 - 32. UITableView Editing Part
//
//  Created by Oleksandr Bardashevskyi on 3/25/19.
//  Copyright © 2019 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class OBStudent: NSObject {
    var firstName = String()
    var lastName = String()
    var averageGrade = Float()
    
    
    func randomStudent() -> OBStudent {
        let student = OBStudent()
        student.firstName = randomName()
        student.lastName = randomName()
        
        student.averageGrade = Float(arc4random()%301) / 100 + 2
        return student
    }
    
    private func randomName () -> String {
        
        func randomLetter(count: Int) -> Int {
            return Int(arc4random())%count
        }
        
        var name = ""
        var arrayLoud = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]
        var arrayVowels = ["a", "e", "i", "o", "u", "a", "e", "i", "o", "u", "a", "e", "i", "o", "u"]

        let randomCount = arc4random()
        for i in 0..<8 {
            if randomCount.isMultiple(of: 2) {
                name.append(i%2 == 0 ? arrayLoud[randomLetter(count: arrayLoud.count)] : arrayVowels[randomLetter(count: arrayVowels.count)])
            } else {
                name.append(i%2 == 1 ? arrayLoud[randomLetter(count: arrayLoud.count)] : arrayVowels[randomLetter(count: arrayVowels.count)])
            }
        }
        
        return name.capitalized
    }
}
