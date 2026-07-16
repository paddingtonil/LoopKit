//
//  SyncCarbObject.swift
//  LoopKit
//
//  Created by Darin Krauss on 8/10/20.
//  Copyright © 2020 LoopKit Authors. All rights reserved.
//

import Foundation
import HealthKit

public enum Operation: Int, CaseIterable, Codable {
    case create
    case update
    case delete
}

public struct SyncCarbObject: Codable, Equatable {
    public let absorptionTime: TimeInterval?
    public let createdByCurrentApp: Bool
    public let foodType: String?
    public let grams: Double
    /// Fat-protein-unit carbs (dosing device, not real carbohydrate).
    public let isFPU: Bool
    public let startDate: Date
    public let uuid: UUID?
    public let provenanceIdentifier: String
    public let syncIdentifier: String?
    public let syncVersion: Int?
    public let userCreatedDate: Date?
    public let userUpdatedDate: Date?
    public let userDeletedDate: Date?
    public let operation: Operation
    public let addedDate: Date?
    public let supercededDate: Date?

    public init(absorptionTime: TimeInterval?,
                createdByCurrentApp: Bool,
                foodType: String?,
                grams: Double,
                isFPU: Bool = false,
                startDate: Date,
                uuid: UUID?,
                provenanceIdentifier: String,
                syncIdentifier: String?,
                syncVersion: Int?,
                userCreatedDate: Date?,
                userUpdatedDate: Date?,
                userDeletedDate: Date?,
                operation: Operation,
                addedDate: Date?,
                supercededDate: Date?) {
        self.absorptionTime = absorptionTime
        self.createdByCurrentApp = createdByCurrentApp
        self.foodType = foodType
        self.grams = grams
        self.isFPU = isFPU
        self.startDate = startDate
        self.uuid = uuid
        self.provenanceIdentifier = provenanceIdentifier
        self.syncIdentifier = syncIdentifier
        self.syncVersion = syncVersion
        self.userCreatedDate = userCreatedDate
        self.userUpdatedDate = userUpdatedDate
        self.userDeletedDate = userDeletedDate
        self.operation = operation
        self.addedDate = addedDate
        self.supercededDate = supercededDate
    }

    public var quantity: HKQuantity { HKQuantity(unit: .gram(), doubleValue: grams) }

    /// Explicit decoding so payloads encoded before FPU support (which carry no
    /// `isFPU` key) still decode — the synthesized decoder would throw
    /// `keyNotFound` for a non-optional property even though it has a default.
    /// Encoding stays synthesized; older peers ignore the extra key.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.absorptionTime = try container.decodeIfPresent(TimeInterval.self, forKey: .absorptionTime)
        self.createdByCurrentApp = try container.decode(Bool.self, forKey: .createdByCurrentApp)
        self.foodType = try container.decodeIfPresent(String.self, forKey: .foodType)
        self.grams = try container.decode(Double.self, forKey: .grams)
        self.isFPU = try container.decodeIfPresent(Bool.self, forKey: .isFPU) ?? false
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid)
        self.provenanceIdentifier = try container.decode(String.self, forKey: .provenanceIdentifier)
        self.syncIdentifier = try container.decodeIfPresent(String.self, forKey: .syncIdentifier)
        self.syncVersion = try container.decodeIfPresent(Int.self, forKey: .syncVersion)
        self.userCreatedDate = try container.decodeIfPresent(Date.self, forKey: .userCreatedDate)
        self.userUpdatedDate = try container.decodeIfPresent(Date.self, forKey: .userUpdatedDate)
        self.userDeletedDate = try container.decodeIfPresent(Date.self, forKey: .userDeletedDate)
        self.operation = try container.decode(Operation.self, forKey: .operation)
        self.addedDate = try container.decodeIfPresent(Date.self, forKey: .addedDate)
        self.supercededDate = try container.decodeIfPresent(Date.self, forKey: .supercededDate)
    }
}

extension SyncCarbObject {
    init(managedObject: CachedCarbObject) {
        self.init(absorptionTime: managedObject.absorptionTime,
                  createdByCurrentApp: managedObject.createdByCurrentApp,
                  foodType: managedObject.foodType,
                  grams: managedObject.grams,
                  isFPU: managedObject.isFPU,
                  startDate: managedObject.startDate,
                  uuid: managedObject.uuid,
                  provenanceIdentifier: managedObject.provenanceIdentifier,
                  syncIdentifier: managedObject.syncIdentifier,
                  syncVersion: managedObject.syncVersion,
                  userCreatedDate: managedObject.userCreatedDate,
                  userUpdatedDate: managedObject.userUpdatedDate,
                  userDeletedDate: managedObject.userDeletedDate,
                  operation: managedObject.operation,
                  addedDate: managedObject.addedDate,
                  supercededDate: managedObject.supercededDate)
    }
}
