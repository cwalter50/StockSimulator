//
//  SettingsView.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/3/22.
//


import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let defaultURL = URL(string: "https://www.google.com")!

//    let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let yahooFinanceURL = URL(string: "https://financeapi.net/")!
    let personalURL = URL(string: "https://www.cwalterbuilds.com")!
    let githubURL = URL(string: "https://github.com/cwalter50/StockSimulator")!
    let personalGithubURL = URL(string: "https://github.com/cwalter50")!
    
    
    var body: some View {
        NavigationView {
            List {
                developerSection
                yahooFinanceSection
                applicationSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
//    private var swiftfulThinkingSection: some View {
//        Section(header: Text("SwiftfulThinking")) {
//            VStack(alignment: .leading) {
//                Image("logo")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                Text("This app was made by following a @SwiftfulThinking course on YouTube. It uses MVVM Architecture, Combine, and CoreData!")
//                    .font(.callout)
//                    .fontWeight(.medium)
//                    .foregroundColor(Color.theme.accent)
//            }
//            .padding(.vertical)
////            Link("Support his coffee addiction ☕️", destination: coffeeURL)
//        }
//    }
    
    private var yahooFinanceSection: some View {
        Section(header: Text("YahooFinance")) {
            VStack(alignment: .leading) {
                Image("yahooLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The stock data that is used in this app comes from Yahoo Finance API. Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Yahoo Finance API 💲", destination: yahooFinanceURL)
        }
    }
    
    private var developerSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading) {
                Image("CWBuildsLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Chris Walter. It uses SwiftUI and is written 100% in Swift. The project benenfits from multi-threading, MVVM Architecture, CoreData, YahooFinanceAPI, and much more.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit My Portfolio 😀", destination: personalURL)
            Link("Visit My Github 💻", destination: personalGithubURL)
            Link("See the projects code 💾", destination: githubURL)
        }
    }
    
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: personalURL)
            Link("Learn More", destination: defaultURL)
        }
    }
}

