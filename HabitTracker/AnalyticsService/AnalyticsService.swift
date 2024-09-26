//
//  AnalyticsService.swift
//  HabitTracker
//
//  Created by Сергей Баскаков on 09.09.2024.
//

import Foundation
import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "6eeedadb-8645-467b-9774-a5c68e02f1f6") else { return }

        AppMetrica.activate(with: configuration)
    }

    func report(event: Events, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
