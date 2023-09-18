//
//  CurrencyHistoryView.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import SwiftUI

struct CurrencyHistoryView: View {
    @StateObject var viewModel: CurrencyHistoryViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.displayLogs, id: \.date) { displayLog in
                    CurrencyLogView(displayLog: displayLog)
                }
            }
            
            Spacer()
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CurrencyLogView: View {
    var displayLog: CurrencyLogDisplayModel
    var body: some View {
        VStack {
            Text(displayLog.date)
                .font(.title3)
            
            HStack {
                Spacer()
                
                VStack {
                    Text("USD")
                    Text(displayLog.usdRate)
                }
                
                Spacer()
                
                VStack {
                    Text("GBP")
                    Text(displayLog.gbpRate)
                }
                
                Spacer()
                
                VStack {
                    Text("EUR")
                    Text(displayLog.eurRate)
                }
                
                Spacer()
            }
            .padding(.bottom, 5)
            .fixedSize(horizontal: true, vertical: true)
            
            Divider()
                .frame(height: 2)
                .foregroundColor(.gray)
        }
    }
}

struct CurrencyHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyHistoryView(viewModel: CurrencyHistoryViewModel())
    }
}
