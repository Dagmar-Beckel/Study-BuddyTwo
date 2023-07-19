//
//  PomodoroModel.swift
//  Study BuddyTwo
//
//  Created by Dagmar Beckel on 7/18/23.
//

import SwiftUI

class PomodoroModel: NSObject,ObservableObject{
    //MARK: Timer Properties
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    //MARK: Total Seconds
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    //MARK: Starting Timer
    func startTimer(){
        withAnimation(.easeInOut(duration: 0.25)){isStarted = true}
        //MARK: Setiing String Time
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)")\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        //MARK: Calculating Total Seconds For Timer Animation
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
    }
    
    //MARK: Stopping Timer
    func stopTimer(){
        
    }
    
    //MARK: Updating Timer
    func updateTimer(){
        totalSeconds -= 1
        //60 Minutes * 60 Seconds
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)")\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        if hour == 0 && seconds == 0 && minutes == 0{
            isStarted = false
            print("Finished")
        }
    }
    
}


