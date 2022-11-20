

import Foundation

class TransportManager {
    
    static let share = TransportManager()
    private init() {}
    
    private var transport = [
        Cargo(year: 1990, brand: .Volvo, model: .FH500, fuel: .diesel, bodyVolume: 8, loadCapacity: 35, bodyType: .refrigerator, currentAmountFuel: 20, fuelConsumption: 15, volumeFuelTank: 400),
        CargoPassenger(year: 1995, brand: .Scania, model: .R420, fuel: .diesel, bodyVolume: 8, loadCapacity: 4, passengerCapacity: 5, bodyType: .tilt, currentAmountFuel: 20, fuelConsumption: 10, volumeFuelTank: 200),
        Passenger(year: 2000, brand: .Ikarus, model: .C56, fuel: .petrol, passengerCapacity: 48, currentAmountFuel: 100, fuelConsumption: 9, volumeFuelTank: 100),
        Cargo(year: 1997, brand: .Mercedes, model: .Actros, fuel: .petrol, bodyVolume: 10, loadCapacity: 6, bodyType: .tilt, currentAmountFuel: 10, fuelConsumption: 5, volumeFuelTank: 70)
    ]
    
//    private var transport = [Transport]()
    
    private var orders = [
        CargoOrder(startPoint: .London, endPoint: .Mexico, freightVolume: 4, freightWeight: 4, freightType: .manufacturedGoods),
        PassengerOrder(startPoint: .Oslo, endPoint: .Rome, passengerAmount: 40),
        CargoPassengerOrder(startPoint: .Venice, endPoint: .Rome, passengerAmount: 3, freightVolume: 3, freightWeight: 2, freightType: .manufacturedGoods),
        CargoOrder(startPoint: .London, endPoint: .Mexico, freightVolume: 5, freightWeight: 5, freightType: .perishableProducts),
        PassengerOrder(startPoint: .Oslo, endPoint: .Rome, passengerAmount: 7),
        CargoPassengerOrder(startPoint: .Rome, endPoint: .Venice, passengerAmount: 2, freightVolume: 3, freightWeight: 2, freightType: .manufacturedGoods)
    ]
    
    
    //MARK: - Functions
    
    // MARK: - Этот метод раскомментировать
//    func initialRefuel() {
//        transport.forEach {
//            if $0.currentAmountFuel < $0.volumeFuelTank {
//                $0.currentAmountFuel = $0.volumeFuelTank
//            }
//        }
//    }
    
//    func обслуживания пока оставим !!!!! _ __ __!! ! !! !
    
    // MARK: - этот метод закомментировать
    //погрузка заказов во все машины
    func loadTransport() {
         for item in transport {
             if let singleTransport = item as? Passenger {
                 for order in orders {
                     if let order = order as? PassengerOrder {
                         if singleTransport.freeAmountSeats >= order.passengerAmount && !order.isLoaded {
                             singleTransport.orders.append(order)
                             order.isLoaded = true
                         }
                     }
                 }
                 someInformation(transport: singleTransport)
             }
             if let singleTransport = item as? CargoPassenger {
                 for order in orders {
                     if let order = order as? CargoPassengerOrder {
                         if self.canLoadCargoPassenger(transport: singleTransport, order: order) {
                             singleTransport.orders.append(order)
                             order.isLoaded = true
                         }
                     }
                 }
                someInformation(transport: singleTransport)
             }
             if let singleTransport = item as? Cargo {
                 if singleTransport is CargoPassenger { continue }
                 for order in orders {
                     if let order = order as? CargoOrder {
                         if order is CargoPassengerOrder { continue }
                         if self.canLoadCargo(transport: singleTransport, order: order) {
                             singleTransport.orders.append(order)
                             order.isLoaded = true
                         }
                     }
                 }
                 someInformation(transport: singleTransport)
             }
         }
    }
    
    private func someInformation(transport: Transport) {
        print("TypeTransport: \(type(of: transport)) - \(transport.carBrand) - \(transport.carModel) - \(transport.yearIssue)")
        transport.viewOrders()
    }

    func canLoadCargo(transport: Cargo, order: CargoOrder) -> Bool {
        if transport.freeBodyVolume >= order.freightVolume && transport.freeLoadCapacity >= order.freightWeight && self.checkBodyTransport(oneTransport: transport, order: order) && !order.isLoaded {
            return true
        }
        return false
    }
    
    func canLoadCargoPassenger(transport: CargoPassenger, order: CargoPassengerOrder) -> Bool {
        if transport.freeAmountSeats >= order.passengerAmount && transport.freeBodyVolume >= order.freightVolume && transport.freeLoadCapacity >= order.freightWeight && self.checkBodyTransport(oneTransport: transport, order: order) && !order.isLoaded {
            return true
        }
        return false
    }
    
    // разгружаем весь транспорт
    func reloadTransport() {
        transport.forEach {
            if !$0.orders.isEmpty {
                $0.orders.removeAll()
                self.recoveryOrders()
            }
        }
    }
    
    func recoveryOrders() {
        orders.forEach {
            $0.isLoaded = false
        }
    }
    //MARK: - Загрузка и разгрузка одного конкретного транспорта
    func loadReloadTransport(brand: CarBrand, model: CarModel, year: Int) {
        guard let specificTransport = findSpecificTransport(brand: brand, model: model, year: year) else {
            print("Transport not found.")
            return
        }
        switch specificTransport {
        case let car as Cargo:
            print("Cargo - \(car.carBrand)")
            car.viewOrders()
        case let car as CargoPassenger:
            print("CargoPassenger - \(car.carBrand)")
        case let car as Passenger:
            print("Passenger - \(car.carBrand)")
        default:
            print("something else")
        }
    }
    
    func findSpecificTransport(brand: CarBrand, model: CarModel, year: Int) -> Transport? {
        for item in transport {
            if item.carBrand == brand && item.carModel == model && item.yearIssue == year {
                return item
            }
        }
        return nil
    }
    
    //MARK: - Этот метод закомментировать
    // Проверка какой груз(заказ) можно грузить
    private func checkBodyTransport(oneTransport: Cargo, order: CargoOrder) -> Bool {
        if oneTransport.bodyType == TypeBody.tilt && order.freightType == TypeFreight.manufacturedGoods {
            return true
        }
        if oneTransport.bodyType == TypeBody.refrigerator && order.freightType == TypeFreight.manufacturedGoods || oneTransport.bodyType == TypeBody.refrigerator && order.freightType == TypeFreight.perishableProducts {
            return true
        }
        if oneTransport.bodyType == TypeBody.tank && order.freightType == TypeFreight.liquids {
            return true
        }
        return false
    }
    
    
    // OPtional function
//    func dryFuelTank() {
//        self.firstTransport.currentAmountFuel = 0
//    }
}

