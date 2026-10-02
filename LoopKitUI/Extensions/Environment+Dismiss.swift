//
//  Environment+Dismiss.swift
//  Loop
//
//  Created by Michael Pangburn on 4/15/20.
//  Copyright © 2020 LoopKit Authors. All rights reserved.
//

import SwiftUI


private struct PresentationDismissalKey: EnvironmentKey {
    static let defaultValue = {}
}


extension EnvironmentValues {
    public var dismissAction: () -> Void {
        get { self[PresentationDismissalKey.self] }
        set { self[PresentationDismissalKey.self] = newValue }
    }
}

// MARK: - Therapy Help Registry

/// Static registry so Loop can inject a "Get help" destination without environment propagation.
/// Set `TherapyHelpRegistry.destination` once at app startup; TherapySettingsView reads it directly.
public final class TherapyHelpRegistry {
    public static var destination: AnyView? = nil
}
