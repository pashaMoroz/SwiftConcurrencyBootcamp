//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrenncyBootcamp
//
//  Created by Moroz Pavlo on 2023-03-14.
//

import SwiftUI
import Combine

class AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Appple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    
   @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSurscribers()
    }
    
    private func addSurscribers() {
        
        Task {
            for await value in manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
        
//        manager.$myData
//            .receive(on: DispatchQueue.main)
//            .sink { dataAray in
//                self.dataArray = dataAray
//            }
//            .store(in: &cancellables)
    }
    
    func start() async {
       await  manager.addData()
    }
}

struct AsyncPublisherBootcamp: View {
    
    @StateObject var viewModel = AsyncPublisherBootcampViewModel()
    
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
            await viewModel.start()
        }
    }
}

struct AsyncPublisherBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootcamp()
    }
}
