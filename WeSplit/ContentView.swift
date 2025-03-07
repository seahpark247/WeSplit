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
    // @State: automatically watch the changes!
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalForCheck: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        
        return grandTotal
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople) + 2
        let amountPerPerson = totalForCheck / peopleCount
        
        return amountPerPerson
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                                        
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
//                    .pickerStyle(.navigationLink)
                }
                
                Section("How much tip?") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text($0, format: .percent)
                        }
                    }
//                    .pickerStyle(.segmented)
                    .pickerStyle(.navigationLink)
                }
                
                Section("Amount for check") {
                    Text(totalForCheck, format: .currency(code: Locale.current.currency?.identifier ?? "USD")).tipWarning(with: tipPercentage)
                }
                
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
