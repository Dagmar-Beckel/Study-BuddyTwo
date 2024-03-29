//
//  Home.swift
//  Study BuddyTwo
//
//  Created by Dagmar Beckel on 7/18/23.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        //ZStack for Color
        ZStack{
            Color("PastelGreenDark")
                .ignoresSafeArea()
            VStack{
                Text("Pomodoro Timer")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                GeometryReader{proxy in
                    VStack(spacing:15){
                        //MARK: Timer Ring
                        ZStack{
                            Circle()
                                .fill(Color("PastelGreen"))
                                .padding(-40)
                            
                            Circle()
                                .trim(from: 0, to: 0.5)
                                .stroke(.white.opacity(0.03),lineWidth: 80)
                            
                            //MARK: Shadow
                            Circle()
                                .stroke(Color("PastelBlueOne"),lineWidth:5)
                                .blur(radius: 15)
                                .padding(-2)
                            
                            Circle()
                                .fill(Color("PastelGreenDark"))

                            Circle()
                                .trim(from:0, to: pomodoroModel.progress)
                                .stroke(Color("PastelBlueOne").opacity(0.7),lineWidth:10)
                            
                            //MARK: Knob
                            GeometryReader{proxy in
                                let size = proxy.size

                                Circle()
                                    .fill(Color("PastelBlueOne"))
                                    .frame(width: 30, height: 30)
                                    .overlay(content: {
                                        Circle()
                                            .fill(.white)
                                            .padding(5)
                                    })
                                    .frame(width: size.width, height: size.height, alignment: .center)
                                //MARK:Since View is Rotated, That's Why Using X
                                    .offset(x: size.height / 2)
                                    .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                            }
                            Text(pomodoroModel.timerStringValue)
                                .font(.system(size: 45, weight: .light))
                                .rotationEffect(.init(degrees:-90))
                                .animation(.none, value: pomodoroModel.progress)
                            /*.onTapGesture(perform: {
                                pomodoroModel.progress = 0.5
                            })*/
                        }
                        .padding(60)
                        .frame(height: proxy.size.width)
                        .rotationEffect(.init(degrees:-90))
                        .animation(.easeInOut, value: pomodoroModel.progress)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        
                        Button{
                            if pomodoroModel.isStarted{
                                pomodoroModel.stopTimer()
                            }else{
                                pomodoroModel.addNewTimer = true
                            }
                        }label:{
                            Image(systemName: !pomodoroModel.isStarted ? "timer": "pause")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background{
                                    Circle()
                                        .fill(Color("PastelBlueOne"))
                                }
                                .shadow(color: Color("PastelBlueOne"),radius: 8, x: 0, y: 0)
                        }
                        
                    }

                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .padding()
            .overlay(content:{
                ZStack{
                    Color.black
                        .opacity(pomodoroModel.addNewTimer ? 0.25 : 0 )
                        .onTapGesture{
                            pomodoroModel.hour = 0
                            pomodoroModel.minutes = 0
                            pomodoroModel.seconds = 0
                            pomodoroModel.addNewTimer = false
                        }
                    
                    NewTimerView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: pomodoroModel.addNewTimer ? 0 : 400)
                }
                .animation(.easeInOut, value: pomodoroModel.addNewTimer)
            })
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()){
                _ in
                if pomodoroModel.isStarted{
                    pomodoroModel.updateTimer()
                }
            }
        }
    }
    //MARK: New Timer Bottom Sheet
    @ViewBuilder
    func NewTimerView()->some View{
        VStack(spacing: 15){
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.top,10)
            HStack(spacing:15){
                Text("\(pomodoroModel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.2))
                    .padding(.horizontal,20)
                    .padding(.vertical,12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.2))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 12, hint: "hr"){value in
                            pomodoroModel.hour = value
                        }
                        
                    }
                
                Text("\(pomodoroModel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.2))
                    .padding(.horizontal,20)
                    .padding(.vertical,12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.2))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "min"){value in
                            pomodoroModel.minutes = value
                        }
                        
                    }
                
                Text("\(pomodoroModel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.2))
                    .padding(.horizontal,20)
                    .padding(.vertical,12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.2))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "sec"){value in
                            pomodoroModel.seconds = value
                        }
                        
                    }
            }
            .padding(.top,20)
            
            Button{
                pomodoroModel.startTimer()
            }label:{
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,100)
                    .background{
                        Capsule()
                            .fill(Color("PastelBlueOne"))
                    }
            }
            .disabled(pomodoroModel.seconds == 0)
            .opacity(pomodoroModel.seconds == 0 ? 0.5 : 1)
            .padding(.top)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("PastelGreenDark"))
                .ignoresSafeArea()
        }
    }
    //MARK: Reusable Context Menu Options
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int,hint: String,onClick: @escaping (Int)->())-> some View{
        ForEach(0...maxValue,id: \.self){value in
            Button("\(value) \(hint)"){
                onClick(value)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomodoroModel())
    }
}

