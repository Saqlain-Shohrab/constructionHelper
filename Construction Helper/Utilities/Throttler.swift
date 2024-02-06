//
//  Throttler.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 06/02/2024.
//

import Foundation

class Throttler {
    private var workItem: DispatchWorkItem?
    private var lastRun: Date?
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval

    init(minimumDelay: TimeInterval, queue: DispatchQueue = .main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }

    func throttle(_ block: @escaping () -> Void) {
        workItem?.cancel()

        let workItem = DispatchWorkItem(block: block)
        self.workItem = workItem

        let delay = lastRun.map { minimumDelay - Date().timeIntervalSince($0) } ?? minimumDelay
        queue.asyncAfter(deadline: .now() + max(0, delay), execute: workItem)
        lastRun = Date()
    }
}
