//
//  StorageError.swift
//  HabitTracker
//
//  Created by Сергей Баскаков on 25.08.2024.
//

import Foundation

enum StorageError: Error {
    case failedToWrite
    case failedReading
    case failedDecoding
    case failedGettingTitle
    case failedActionDelete
    case failedActionUpdate
    case trackerNotFound
}
