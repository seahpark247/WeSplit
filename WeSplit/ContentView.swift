//
//  ContentView.swift
//  WeSplit
//
//  Created by Seah Park on 2/16/25.
//

import SwiftUI

struct tipWarning: ViewModifier {
    var tip: Int
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(tip == 0 ? .red : .primary)
    }
}

extension View {
    func tipWarningStyle(tip: Int) -> some View {
        modifier(tipWarning(tip: tip))
    }
}

struct ContentView: View {
    @State private var money = 0.0
    @State private var people = 2
    @State private var tipPercentage = 20
    @State private var isShowAlert = false
    @FocusState private var isFocused: Bool
    
    let tipPercentages = [10, 15, 18, 20, 0]
    
    var total: Double {
        let tip = money / 100 * Double(tipPercentage)
        return tip + money
    }
    
    var split: Double {
        return total / Double(people + 2)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Text("").frame(maxWidth: .infinity, maxHeight: .infinity).background(.green.gradient).ignoresSafeArea()
                
                Form {
                    Section("How Much Money") {
                        TextField("Amount", value: $money, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                        
                        Picker("Number of people", selection: $people) {
                            ForEach(2..<100) {
                                Text("\($0) people")
                            }
                        }
                    }
                    
                    Section("How Much Tip?") {
                        Picker("Tip percentages", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    Section("Amount For Check") {
                        Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .tipWarningStyle(tip: tipPercentage)
                    }
                    
                    Section("Amount Per Person") {
                        Text(split, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }
            }
            .navigationTitle("WeSplit7")
            .toolbar {
                // if isFocused!!
                if isFocused {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }.scrollContentBackground(.hidden)
        
    }

}
   
#Preview {
    ContentView()
}
