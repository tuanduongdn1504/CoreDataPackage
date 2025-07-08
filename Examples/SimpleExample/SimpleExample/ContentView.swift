//
//  ContentView.swift
//  SimpleExample
//
//  Created by Duong Tuan on 28/06/2025.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: []) var products: FetchedResults<Product>
    
    var body: some View {
        VStack {
            List(products) { product in
                Text(product.name ?? "Unknown")
            }
            Button("Add") {
                let productNames = ["Screen", "Iphone", "App Watch"]
                
                let product = Product(context: managedObjectContext)
                product.id = UUID()
                product.name = "\(productNames.randomElement()!)"
                
                try? managedObjectContext.save()
            }
        }
        .padding()
    }
}
