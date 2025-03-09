//
//  ContentView.swift
//  WeSplit
//
//  Created by Seah Park on 2/16/25.
//

import SwiftUI

struct TipWarning: ViewModifier {
    var tip: Int
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(tip == 0 ? .red : .primary)
    }
}

extension View {
    func tipWarning(with tip: Int) -> some View {
        modifier(TipWarning(tip: tip))
    }
}

struct ContentView: View {
    @State private var money = 0.0
    @State private var people = 2
    @State private var tipPercentage = 0
    @FocusState private var isFocused: Bool
    
    let tipPercentages: [Int] = [10, 15, 18, 20, 0]
    
    var total: Double {
        let tip = money / 100 * Double(tipPercentage)
        return tip + money
    }
    
    var split: Double {
        return total / Double(people + 2)
        // people + 2 !!!
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Text("").frame(maxWidth: .infinity, maxHeight: .infinity).background(.green.gradient).ignoresSafeArea()
                
                Form {
                    Section("How much money") {
                        TextField("Amount", value: $money, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                        
                        Picker("Number of people", selection: $people) {
                            ForEach(2..<100){
                                Text("\($0) people")
                            }
                        }
                    }
                    
                    Section("How much tip?") {
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                                // 포멧을 바로주니까-> Text($0, format: .percent)
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    Section("Amount for check") {
                        Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD")).tipWarning(with: tipPercentage)
                    }
                    
                    Section("Amount per person") {
                        Text(split, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }
                .navigationTitle("WeSplit6")
                .toolbar {
                    if isFocused {
                        Button("Done") {
                            isFocused = false
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        // .scrollContentBackgorund(.hidden)
    }
}

#Preview {
    ContentView()
}
