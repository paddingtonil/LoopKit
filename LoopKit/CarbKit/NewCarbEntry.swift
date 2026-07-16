//
//  NewCarbEntry.swift
//  CarbKit
//
//  Created by Nathan Racklyeft on 1/15/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

import Foundation
import HealthKit


public struct NewCarbEntry: CarbEntry, Equatable, RawRepresentable {
    public typealias RawValue = [String: Any]

    public let date: Date
    public let quantity: HKQuantity
    public let startDate: Date
    public let foodType: String?
    public let absorptionTime: TimeInterval?

    /// Marks this entry as fat-protein-unit (FPU) carbs rather than real
    /// carbohydrate. FPU carbs are a dosing device — they are not expected to
    /// raise glucose the way food carbs do, so consumers may exclude them from
    /// prediction-driven dose recommendations. Defaults to `false` so every
    /// existing call site keeps its current meaning.
    public let isFPU: Bool

    public init(date: Date = Date(), quantity: HKQuantity, startDate: Date, foodType: String?, absorptionTime: TimeInterval?, isFPU: Bool = false) {
        self.date = date
        self.quantity = quantity
        self.startDate = startDate
        self.foodType = foodType
        self.absorptionTime = absorptionTime
        self.isFPU = isFPU
    }

    public init?(rawValue: RawValue) {
        guard
            let date = rawValue["date"] as? Date,
            let grams = rawValue["grams"] as? Double,
            let startDate = rawValue["startDate"] as? Date
        else {
            return nil
        }

        self.init(
            date: date,
            quantity: HKQuantity(unit: .gram(), doubleValue: grams),
            startDate: startDate,
            foodType: rawValue["foodType"] as? String,
            absorptionTime: rawValue["absorptionTime"] as? TimeInterval,
            // Absent in raw values written before FPU support — treat as normal carbs.
            isFPU: rawValue["isFPU"] as? Bool ?? false
        )
    }

    public var rawValue: RawValue {
        var rawValue: RawValue = [
            "date": date,
            "grams": quantity.doubleValue(for: .gram()),
            "startDate": startDate
        ]

        rawValue["foodType"] = foodType
        rawValue["absorptionTime"] = absorptionTime
        // Only written when set, so raw values for normal carbs are unchanged.
        if isFPU {
            rawValue["isFPU"] = true
        }

        return rawValue
    }
}
