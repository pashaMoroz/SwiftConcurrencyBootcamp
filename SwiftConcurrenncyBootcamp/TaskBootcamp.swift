//
//  TaskBootcamp.swift
//  SwiftConcurrenncyBootcamp
//
//  Created by Moroz Pavlo on 2023-02-27.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
       try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
            })
           
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME!") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//               await viewModel.fetchImage()
//            }
//            Task {
//               await viewModel.fetchImage2()
//            }
            
//            Task(priority: .high) {
//                await Task.yield()
//                print("high : \(Thread.current): \(Task.currentPriority) ")
//            }
//
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current): \(Task.currentPriority) ")
//            }
//
//            Task(priority: .medium) {
//                print("medium : \(Thread.current): \(Task.currentPriority) ")
//            }
//
//            Task(priority: .low) {
//                print("lOW : \(Thread.current): \(Task.currentPriority) ")
//            }
//
//            Task(priority: .utility) {
//                print("utility : \(Thread.current): \(Task.currentPriority) ")
//            }
//            Task(priority: .background) {
//                print("background : \(Thread.current): \(Task.currentPriority) ")
//            }
            
            
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current): \(Task.currentPriority) ")
//
//                Task.detached {
//                    print("detached : \(Thread.current): \(Task.currentPriority) ")
//                }
//            }
           
            
            
            
        }
    }

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
