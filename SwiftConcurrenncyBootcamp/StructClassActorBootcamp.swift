//
//  StructClassActorBootcamp.swift
//  SwiftConcurrenncyBootcamp
//
//  Created by Moroz Pavlo on 2023-03-12.
//

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                rucTest()
            }
    }
}

struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp()
    }
}

struct MyStruct {
    var title: String
}



extension StructClassActorBootcamp {
    
    private func rucTest() {
        print("Test started")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//          structTest2()
//        printDivider()
//        calssTest2()
    }
    
    private func printDivider() {
        print("""
- - - - - - - - - -
""")
    }
    
    private func structTest1() {
        let objectA = MyStruct(title: "Starting title!")
        print("ObjectA:", objectA.title)
        
        print("Pass the VALUES of objectA to objectB")
        var objectB = objectA
        print("ObjectB:", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA:", objectA.title)
        print("ObjectB:", objectB.title)
    }
    
    private func classTest1() {
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA:", objectA.title)
        
        print("Pass the REFERENCE  of objectA to objectB")
        let objectB = objectA
        print("ObjectB:", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA:", objectA.title)
        print("ObjectB:", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA:", objectA.title)
            
            print("Pass the REFERENCE  of objectA to objectB")
            let objectB = objectA
            await print("ObjectB:", objectB.title)
            
            await objectB.updatetitle(newTitle: "Second title")
           // objectB.title = "Second title!"
            print("ObjectB title changed.")
            
            await print("ObjectA:", objectA.title)
            await print("ObjectB:", objectB.title)
        }
    }
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updatetitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    private(set)var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updatetitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("structTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updatetitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4", struct4.title)
        struct4.updatetitle(newTitle: "Title2")
        print("Struct4", struct4.title)
    }
    
    class MyClass {
        var title: String
        
        init(title: String) {
            self.title = title
        }
        
         func updatetitle(newTitle: String) {
            title = newTitle
        }
    }
    
    actor MyActor {
        var title: String
        
        init(title: String) {
            self.title = title
        }
        
         func updatetitle(newTitle: String) {
            title = newTitle
        }
    }
}


extension StructClassActorBootcamp {
    
    private func calssTest2() {
        print("calssTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1: ", class1.title)
        class1.title = "Title2"
        print("Class1: ", class1.title)
        
        
        let class2 = MyClass(title: "Title1")
        print("Class2: ", class2.title)
        class2.updatetitle(newTitle: "Title2")
        print("Class2: ", class2.title)
        
    }
}
