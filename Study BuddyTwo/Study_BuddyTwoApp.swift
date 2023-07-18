//
//  Study_BuddyTwoApp.swift
//  Study BuddyTwo
//
//  Created by Dagmar Beckel on 7/18/23.
//

import SwiftUI

@main
struct Study_BuddyTwoApp: App {
    //MARK: Since We're doing Background fetching Intilizing Here
    @StateObject var pomodoroModel: PomodoroModel = .init()
    var body: some Scene{
        WindowGroup{
            ContentView()
                .environmentObject(pomodoroModel)
        }
    }
}
