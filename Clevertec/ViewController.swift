

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(checkTicket(ticketNumber: -223))
    }

    func checkTicket(ticketNumber: Int) -> Bool {
        if ticketNumber < 0 {
            return false
        }
        let array = self.numberToArray(number: ticketNumber)
        let countNumeric = array.count
        if countNumeric % 2 == 0 && countNumeric >= 2 && countNumeric <= 8 {
            let leftHalf = sumLeftAndRightHalfs(numberArray: array).left
            let rightHalf = sumLeftAndRightHalfs(numberArray: array).right
            let result = self.compareHalfs(left: leftHalf, right: rightHalf)
            return result
        } else {
            print("You enter incorrect ticketNumber!")
            return false
        }
        
    }
    
    func numberToArray(number: Int) -> [Int] {
        
        let stringNumber = String(number)
        let newStringNumber = stringNumber.map { String($0)}.map {Int($0)!}
        
        return newStringNumber
    }
    
    func sumLeftAndRightHalfs(numberArray: [Int]) -> (left: Int, right: Int) {
        // дележка массива пополам
        let half = numberArray.count / 2
        let leftSide = Array(numberArray[0..<half])
        let rightSide = Array(numberArray[half..<numberArray.count])
        
        let sumLeft = leftSide.reduce(0, +)
        let sumRight = rightSide.reduce(0, +)
        
        return (left: sumLeft, right: sumRight)
    }

    func compareHalfs(left: Int, right: Int) -> Bool {
        if left == right {
            return true
        }
        return false
    }
}

