//
//  ContentView.swift
//  coreDataTest
//
//  Created by Kaua Miguel on 11/08/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //Managed Object Context
    @Environment(\.managedObjectContext) private var viewContext
    
    //Busca os elementos do banco através do Fetch e organiza em ordem crescente
    @FetchRequest (entity: FruitEntity.entity(),
                   sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    var fruits : FetchedResults<FruitEntity>
    
    @State var addFruitName : String = ""
    
    var body: some View {
        NavigationView {
            VStack (spacing: 20) {
                
                TextField("Add here", text: $addFruitName)
                    .padding()
                Button {
                    addItem()
                } label: {
                    Text("Add")
                        .font(.headline)
                }
                
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                //Ao clicar, chamar a função de update
                                updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteFruit)
                }
            }
        }
    }
    
    private func addItem(){
        //Cria-se um nome objeto do tipo FruitEntity e adciona no banco
        let newFruit = FruitEntity(context: viewContext)
        newFruit.name = addFruitName
        save()
        addFruitName = ""
    }
    
    private func updateItem(fruit : FruitEntity){
        withAnimation {
            //Atualiza a variavel e seus atributos
            let newName = fruit.name! + "AAAAA"
            fruit.name = newName
            save()
        }
    }
    
    private func deleteFruit(offsets: IndexSet){
        
        //Ao selecionar a fruta na view, pega-se o index dela
        if let index = offsets.first{
            let fruit = fruits[index]
            //Remove o elemento através do managed object context
            viewContext.delete(fruit)
        }
        save()
    }
    
    private func save(){
        do{
            try viewContext.save()
        }catch{
            fatalError("TryHardado")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
