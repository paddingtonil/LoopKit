//
//  HKQuantitySample.swift
//  CarbKit
//
//  Created by Nathan Racklyeft on 1/10/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

import HealthKit


let LegacyMetadataKeyAbsorptionTime = "com.loudnate.CarbKit.HKMetadataKey.AbsorptionTimeMinutes"
let MetadataKeyAbsorptionTime = "com.loopkit.AbsorptionTime"
let MetadataKeyUserCreatedDate = "com.loopkit.CarbKit.HKMetadataKey.UserCreatedDate"
let MetadataKeyUserUpdatedDate = "com.loopkit.CarbKit.HKMetadataKey.UserUpdatedDate"
let MetadataKeyIsFPU = "com.loopkit.CarbKit.HKMetadataKey.IsFPU"

extension HKQuantitySample {
    public var foodType: String? {
        return metadata?[HKMetadataKeyFoodType] as? String
    }

    public var absorptionTime: TimeInterval? {
        return metadata?[MetadataKeyAbsorptionTime] as? TimeInterval
            ?? metadata?[LegacyMetadataKeyAbsorptionTime] as? TimeInterval
    }

    public var createdByCurrentApp: Bool {
        return sourceRevision.source == HKSource.default()
    }

    public var userCreatedDate: Date? {
        return metadata?[MetadataKeyUserCreatedDate] as? Date
    }

    public var userUpdatedDate: Date? {
        return metadata?[MetadataKeyUserUpdatedDate] as? Date
    }

    /// Whether this entry represents fat-protein-unit (FPU) carbs rather than
    /// real carbohydrate. FPU carbs are a dosing device: they are not expected to
    /// raise glucose the way food carbs do, so consumers may choose to exclude
    /// them from glucose-prediction-driven dose recommendations.
    /// Absent metadata (any entry not written as FPU) reads as `false`.
    public var isFPU: Bool {
        return metadata?[MetadataKeyIsFPU] as? Bool ?? false
    }
}
