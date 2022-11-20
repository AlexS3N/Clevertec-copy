//
//  SecondViewController.swift
//  Clevertec
//
//  Created by Mac on 13.11.22.
//

import UIKit
import Foundation

class SecondViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TransportManager.share.loadTransport()
//        TransportManager.share.loadReloadTransport(brand: .Mercedes, model: .Actros, year: 1997)
    }
}

// Тип кузова(для грузовых)
enum TypeBody {
    case tilt
    case refrigerator
    case tank
}

// Тип груза(для грузовых)
enum TypeFreight {
    case manufacturedGoods
    case perishableProducts
    case liquids
}

//  Вид топлива
enum TypeFuel {
    case diesel
    case petrol
    case gas
}
// Марка траспорта
enum CarBrand {
    case Scania
    case Volvo
    case Mercedes
    case Volkswagen
    case Ikarus
}
// Модель транспорта
enum CarModel {
    case R420
    case Transporter
    case FH500
    case Actros
    case C56
}


// описание 3 видов транспорта с помощью классов НИЖЕ, класс Transport общий(базовый) для всех остальных
class Transport {
    var yearIssue: Int
    var carBrand: CarBrand
    var carModel: CarModel
    var orders: [Order] = []
    
    var typeFuel: TypeFuel
    var currentAmountFuel: Double {
        didSet {
            if currentAmountFuel < (0.1 * volumeFuelTank) {
                currentAmountFuel = volumeFuelTank
                print("DID Set on refuel")
            }
        }
    }
    var fuelConsumption: Double
    var volumeFuelTank: Double
            
    init(year: Int, brand: CarBrand, model: CarModel, fuel: TypeFuel, currentAmountFuel: Double, fuelConsumption: Double, volumeFuelTank: Double) {
        self.yearIssue = year
        self.carBrand = brand
        self.carModel = model
        self.typeFuel = fuel
        self.currentAmountFuel = currentAmountFuel
        self.fuelConsumption = fuelConsumption
        self.volumeFuelTank = volumeFuelTank
    }
    
    func repair() {
        print("Repairing...")
    }
    
    // MARK: - Attention!!
    func viewOrders() {
        if !orders.isEmpty {
            if let orders = orders as? [CargoOrder] {
                var count = 1
                orders.forEach {
                    print(" \(count) order:")
                    print("  Start point is \($0.startPoint)")
                    print("  End point is \($0.endPoint)")
                    print("  Volume of freight is \($0.freightVolume)")
                    print("  Weight of freight is \($0.freightWeight)")
                    print("  Type of freight is \($0.freightType)")
                    if let orders = orders as? [CargoPassengerOrder] {
                        orders.forEach { print(" Passenger's amount is \($0.passengerAmount)") }
                    }
                    count += 1
                }
            }
            if let orders = orders as? [PassengerOrder] {
                var count = 1
                orders.forEach {
                    print(" \(count) order:")
                    print("  Start point is \($0.startPoint)")
                    print("  End point is \($0.endPoint)")
                    print("  Passenger's amount is \($0.passengerAmount)")
                    count += 1
                }
            }
        } else {
            print("\(self.carBrand) \(self.carModel) \(self.yearIssue) isn't loaded.")
        }
    }
}

// Грузовой транспорт
class Cargo: Transport {
    var bodyVolume: Double
    var loadCapacity: Int
    var bodyType: TypeBody
        
    // проверка свободной грузоподъёмности
    var freeLoadCapacity: Int {
        var occupiedLoadCapacity = 0
        if let orders = self.orders as? [CargoOrder] {
            if !orders.isEmpty {
                orders.forEach { occupiedLoadCapacity += $0.freightWeight }
                return (loadCapacity - occupiedLoadCapacity)
            }
        }
        return loadCapacity
    }
 
    // проверка свободного объёма кузова
    var freeBodyVolume: Double {
        var occupiedBodyVolume: Double = 0
        if let orders = self.orders as? [CargoOrder] {
            if !orders.isEmpty {
                orders.forEach { occupiedBodyVolume += $0.freightVolume }
                return (bodyVolume - occupiedBodyVolume)
            }
        }
        return bodyVolume
    }
    
    init(year: Int, brand: CarBrand, model: CarModel, fuel: TypeFuel, bodyVolume: Double, loadCapacity: Int, bodyType: TypeBody, currentAmountFuel: Double, fuelConsumption: Double, volumeFuelTank: Double) {
        self.bodyVolume = bodyVolume
        self.loadCapacity = loadCapacity
        self.bodyType = bodyType
        super.init(year: year, brand: brand, model: model, fuel: fuel, currentAmountFuel: currentAmountFuel, fuelConsumption: fuelConsumption, volumeFuelTank: volumeFuelTank)
    }
    
    func sealBody() {
        print("Sealing of body...")
    }
}

// Пассажирский транспорт
class Passenger: Transport {
    var passengerCapacity: Int
        
    // проверка свободных мест в транспорте
    var freeAmountSeats: Int {
        var occupiedSeats = 0
        if let orders = self.orders as? [PassengerOrder] {
            if !orders.isEmpty {
                orders.forEach { occupiedSeats += $0.passengerAmount }
                return (passengerCapacity - occupiedSeats)
            }
        }
        return passengerCapacity
    }
    
    init(year: Int, brand: CarBrand, model: CarModel, fuel: TypeFuel, passengerCapacity: Int, currentAmountFuel: Double, fuelConsumption: Double, volumeFuelTank: Double) {
        self.passengerCapacity = passengerCapacity
        super.init(year: year, brand: brand, model: model, fuel: fuel, currentAmountFuel: currentAmountFuel, fuelConsumption: fuelConsumption, volumeFuelTank: volumeFuelTank)
    }
    
    func disinfectSalon() {
        print("Disinfection...")
    }
}

// Грузопассажирский транспорт
class CargoPassenger: Cargo {
    var passengerCapacity: Int
    
    // проверка свободных мест в транспорте
    var freeAmountSeats: Int {
        var occupiedSeats = 0
        if let orders = self.orders as? [PassengerOrder] {
            if !orders.isEmpty {
                orders.forEach { occupiedSeats += $0.passengerAmount }
                return (passengerCapacity - occupiedSeats)
            }
        }
        return passengerCapacity
    }
    
    init(year: Int, brand: CarBrand, model: CarModel, fuel: TypeFuel, bodyVolume: Double, loadCapacity: Int, passengerCapacity: Int, bodyType: TypeBody, currentAmountFuel: Double, fuelConsumption: Double, volumeFuelTank: Double) {
        self.passengerCapacity = passengerCapacity
        super.init(year: year, brand: brand, model: model, fuel: fuel, bodyVolume: bodyVolume, loadCapacity: loadCapacity, bodyType: bodyType, currentAmountFuel: currentAmountFuel, fuelConsumption: fuelConsumption, volumeFuelTank: volumeFuelTank)
    }
    
    func disinfectSalon() {
        print("Disinfection...")
    }
    
}

enum StartPoint {
    case Mexico
    case London
    case Rome
    case Venice
    case Oslo
}

enum EndPoint {
    case Mexico
    case London
    case Rome
    case Venice
    case Oslo
}

// Заказ
class Order {
    var startPoint: StartPoint
    var endPoint: EndPoint
    var isLoaded = false
    
    init(startPoint: StartPoint, endPoint: EndPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

class CargoOrder: Order {
    var freightVolume: Double
    var freightWeight: Int
    var freightType: TypeFreight
    
    init(startPoint: StartPoint, endPoint: EndPoint, freightVolume: Double, freightWeight: Int, freightType: TypeFreight) {
        self.freightVolume = freightVolume
        self.freightWeight = freightWeight
        self.freightType = freightType
        super.init(startPoint: startPoint, endPoint: endPoint)
    }
}

class PassengerOrder: Order {
    var passengerAmount: Int
    
    init(startPoint: StartPoint, endPoint: EndPoint, passengerAmount: Int) {
        self.passengerAmount = passengerAmount
        super.init(startPoint: startPoint, endPoint: endPoint)
    }
}

class CargoPassengerOrder: CargoOrder {
    var passengerAmount: Int
    
    init(startPoint: StartPoint, endPoint: EndPoint, passengerAmount: Int, freightVolume: Double, freightWeight: Int, freightType: TypeFreight) {
        self.passengerAmount = passengerAmount
        super.init(startPoint: startPoint, endPoint: endPoint, freightVolume: freightVolume, freightWeight: freightWeight, freightType: freightType)
    }
}


// didSet для заправки и ремонта тачки можно попробовать юзать



//MARK: - Manager for logistic transport

