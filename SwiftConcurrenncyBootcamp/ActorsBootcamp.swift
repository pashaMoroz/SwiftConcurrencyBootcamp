//
//  ActorsBootcamp.swift
//  SwiftConcurrenncyBootcamp
//
//  Created by Moroz Pavlo on 2023-03-13.
//

import SwiftUI
import Foundation

class MyDataManager {
    static let instance = MyDataManager()
    private init () { }
    
    var data: [String] = []
    private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init () { }
    
    var data: [String] = []
    
    nonisolated let myRandomText = "afafafwaf"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "NEW DATA"
    }
}

class MyDataSimpleManager {
    static let instance = MyDataSimpleManager()
    private init () { }
    
    var data: [String] = []
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.0001, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onAppear {
            
        }
        .onReceive(timer) { _ in
            
//            DispatchQueue.global(qos: .background).async {
//                if let text = manager.getRandomData() {
//                    DispatchQueue.main.async {
//                        self.text = text
//                    }
//                }
//            }
            
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        text = data
                    }
                }
            }
            
            //            DispatchQueue.global(qos: .background).async {
            //                manager.getRandomData { title in
            //                    if let data  = title {
            //                        DispatchQueue.main.async {
            //                            self.text = data
            //                        }
            //                    }
            //                }
            //            }
            
        }
    }
}

struct BrowseView: View {
    
    let manager = MyDataSimpleManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            
            
            DispatchQueue.global(qos: .default).async {
                if let text = manager.getRandomData() {
                    DispatchQueue.main.async {
                        self.text = text
                    }
                }
            }
            
//            Task {
//                if let data = await manager.getRandomData() {
//                    await MainActor.run {
//                        text = data
//                    }
//                }
//            }
            
            //            DispatchQueue.global(qos: .background).async {
            //                manager.getRandomData { title in
            //                    if let data = title {
            //                        DispatchQueue.main.async {
            //                            self.text = data
            //                        }
            //                    }
            //                }
            //            }
        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "house.fill")
                }
        }
    }
}

struct ActorsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ActorsBootcamp()
    }
}
