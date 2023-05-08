//
//  GlobalActorBootcamp.swift
//  SwiftConcurrenncyBootcamp
//
//  Created by Moroz Pavlo on 2023-03-13.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five"]
    }
}

class GlobalActorBootcampViewModel: ObservableObject {
    
   @MainActor @Published var dataArray: [String] = []
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor
    //nonisolated
    func getData() {
        
        //Heavy COMPLEX METHODS
        
        Task {
            let data =  await manager.getDataFromDatabase()
            await MainActor.run(body: {
                self.dataArray = data
            })
             
        }
    }
}

struct GlobalActorBootcamp: View {
     
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
    
}

struct GlobalActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootcamp()
    }
}
