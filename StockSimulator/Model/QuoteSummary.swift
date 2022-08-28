//
//  QuoteSummary.swift
//  StockSimulator
//
//  Created by Christopher Walter on 8/2/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quoteSummary = try? newJSONDecoder().decode(QuoteSummary.self, from: jsonData)

import Foundation

// MARK: - QuoteSummary
struct Summary: Codable {
    let quoteSummary: QuoteSummaryClass
}

// MARK: - QuoteSummaryClass
struct QuoteSummaryClass: Codable {
    let error: JSONNull?
    let result: [QuoteSummary]
}

// MARK: - Result
struct QuoteSummary: Codable {
    let assetProfile: AssetProfile?
//    let defaultKeyStatistics: DefaultKeyStatistics?
    let earnings: Earnings?
}

// PYPL does not have description....
// MARK: - AssetProfile
struct AssetProfile: Codable {
//    let address1: String
//    let auditRisk, boardRisk: Int
//    let city: String
//    let companyOfficers: [CompanyOfficer]
//    let compensationAsOfEpochDate, compensationRisk: Int
//    let country: String
//    let fullTimeEmployees, governanceEpochDate: Int
//    let industry: String
    let longBusinessSummary: String?
    let description: String?
//    let maxAge, overallRisk: Int
//    let phone, sector: String
//    let shareHolderRightsRisk: Int
//    let state: String
    let website: String?
//    let zip: String
    
    var wrappedDescription : String {
        if let longBusinessSummary = longBusinessSummary {
            return longBusinessSummary
        }
        else if let description = description {
            return description
        }
        else {
            return "No Description Found"
        }
    }
}

// MARK: - CompanyOfficer
//struct CompanyOfficer: Codable {
//    let age: Int
//    let exercisedValue: EnterpriseValue
//    let fiscalYear, maxAge: Int
//    let name, title: String
//    let totalPay, unexercisedValue: EnterpriseValue
//    let yearBorn: Int
//}


// MARK: - EnterpriseValue
struct EnterpriseValue: Codable {
    let fmt: String?
    let longFmt: String
    let raw: Int
}

// MARK: - DefaultKeyStatistics
struct DefaultKeyStatistics: Codable {
    let the52WeekChange, sandP52WeekChange: The52_WeekChange?
//    let annualHoldingsTurnover, annualReportExpenseRatio: AnnualHoldingsTurnover?
    let beta: The52_WeekChange?
//    let beta3Year: AnnualHoldingsTurnover?
    let bookValue: The52_WeekChange?
//    let category: JSONNull?
    let dateShortInterest, earningsQuarterlyGrowth, enterpriseToEbitda, enterpriseToRevenue: The52_WeekChange?
    let enterpriseValue: EnterpriseValue?
//    let fiveYearAverageReturn: AnnualHoldingsTurnover?
    let floatShares: EnterpriseValue?
    let forwardEps, forwardPE: The52_WeekChange?
//    let fundFamily: JSONNull?
//    let fundInceptionDate: AnnualHoldingsTurnover?
    let heldPercentInsiders, heldPercentInstitutions: The52_WeekChange?
//    let lastCapGain, lastDividendValue: AnnualHoldingsTurnover?
    let lastFiscalYearEnd, lastSplitDate: The52_WeekChange?
    let lastSplitFactor: String?
//    let legalType: JSONNull?
    let maxAge: Int?
//    let morningStarOverallRating, morningStarRiskRating: AnnualHoldingsTurnover?
    let mostRecentQuarter: The52_WeekChange?
    let netIncomeToCommon: EnterpriseValue?
    let nextFiscalYearEnd, pegRatio: The52_WeekChange?
    let priceHint: EnterpriseValue?
    let priceToBook: The52_WeekChange?
//    let priceToSalesTrailing12Months: AnnualHoldingsTurnover?
    let profitMargins: The52_WeekChange?
//    let revenueQuarterlyGrowth: AnnualHoldingsTurnover?
    let sharesOutstanding: EnterpriseValue?
    let sharesPercentSharesOut: The52_WeekChange?
    let sharesShort: EnterpriseValue?
    let sharesShortPreviousMonthDate: The52_WeekChange?
    let sharesShortPriorMonth: EnterpriseValue?
    let shortPercentOfFloat, shortRatio: The52_WeekChange?
//    let threeYearAverageReturn, totalAssets: AnnualHoldingsTurnover?
    let trailingEps: The52_WeekChange?
//    let yield, ytdReturn: AnnualHoldingsTurnover?

    enum CodingKeys: String, CodingKey {
        case the52WeekChange = "52WeekChange"
        case sandP52WeekChange = "SandP52WeekChange"
//        case annualHoldingsTurnover,
//             annualReportExpenseRatio,
        case beta,
//             beta3Year,
             bookValue,
//             category,
             dateShortInterest,
             earningsQuarterlyGrowth,
             enterpriseToEbitda,
             enterpriseToRevenue,
             enterpriseValue,
//             fiveYearAverageReturn,
             floatShares,
             forwardEps,
             forwardPE,
//             fundFamily,
//             fundInceptionDate,
             heldPercentInsiders,
             heldPercentInstitutions,
//             lastCapGain,
//             lastDividendValue,
             lastFiscalYearEnd,
             lastSplitDate,
             lastSplitFactor,
//             legalType,
             maxAge,
//             morningStarOverallRating,
//             morningStarRiskRating,
             mostRecentQuarter,
             netIncomeToCommon,
             nextFiscalYearEnd,
             pegRatio,
             priceHint,
             priceToBook,
//             priceToSalesTrailing12Months,
             profitMargins,
//             revenueQuarterlyGrowth,
             sharesOutstanding,
             sharesPercentSharesOut,
             sharesShort,
             sharesShortPreviousMonthDate,
             sharesShortPriorMonth,
             shortPercentOfFloat,
             shortRatio,
//             threeYearAverageReturn,
//             totalAssets,
             trailingEps
//             yield,
//             ytdReturn
    }
}

//// MARK: - AnnualHoldingsTurnover
//struct AnnualHoldingsTurnover: Codable {
//    let fmt: String?
//    let longFmt: String?
//    let raw: Int?
//}

// MARK: - The52_WeekChange
struct The52_WeekChange: Codable {
    let fmt: String
    let raw: Double
}

// MARK: - Earnings
struct Earnings: Codable {
    let maxAge: Int
    let earningsChart: EarningsChart
    let financialsChart: FinancialsChart
    let financialCurrency: String
    
    // computed property to figure out the EPS, earnings, and revenue
    var earningsModels: [EarningsModel] {
        var result = [EarningsModel]()
        
        for q in earningsChart.quarterly {
            let title = q.date
            let actual = q.actual.raw
            let estimate = q.estimate.raw
            
            let model = EarningsModel(title: title, actual: actual, estimate: estimate)
            result.append(model)
        }
        return result
    }
}

// MARK: - EarningsChart
struct EarningsChart: Codable {
    let quarterly: [EarningsChartQuarterly]
    let currentQuarterEstimate: The52_WeekChange? // this was causing the data not to load for PYPL, so I made it optional... It loads great now for PYPL 8/27/22
    let currentQuarterEstimateDate: String?
    let currentQuarterEstimateYear: Int?
    let earningsDate: [The52_WeekChange?]
}

// MARK: - EarningsChartQuarterly
struct EarningsChartQuarterly: Codable {
    let date: String
    let actual, estimate: The52_WeekChange
}

// MARK: - FinancialsChart
struct FinancialsChart: Codable {
    let yearly: [Yearly]
    let quarterly: [FinancialsChartQuarterly]
}

// MARK: - FinancialsChartQuarterly
struct FinancialsChartQuarterly: Codable {
    let date: String
    let revenue, earnings: EnterpriseValue
}

// MARK: - Yearly
struct Yearly: Codable {
    let date: Int
    let revenue, earnings: EnterpriseValue
}




// I built this struct to dsiply earnings, revenue, and more all together based on a date
struct EarningsModel: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let actual: Double?
    let estimate: Double?

    
    init(title: String, actual: Double? = nil, estimate: Double? = nil)
    {
        self.title = title
        self.actual = actual
        self.estimate = estimate

    }
    
}










//// MARK: - DefaultKeyStatistics
//struct DefaultKeyStatistics: Codable {
//    let maxAge: Int
//    let priceHint, enterpriseValue: EnterpriseValue
//    let forwardPE: AnnualHoldingsTurnover
//    let profitMargins: The52_WeekChange
//    let floatShares, sharesOutstanding, sharesShort, sharesShortPriorMonth: EnterpriseValue
//    let sharesShortPreviousMonthDate, dateShortInterest, sharesPercentSharesOut, heldPercentInsiders: The52_WeekChange
//    let heldPercentInstitutions, shortRatio, shortPercentOfFloat, beta: The52_WeekChange
//    let impliedSharesOutstanding: EnterpriseValue
//    let morningStarOverallRating, morningStarRiskRating: AnnualHoldingsTurnover
//    let category: JSONNull?
//    let bookValue, priceToBook: The52_WeekChange
//    let annualReportExpenseRatio, ytdReturn, beta3Year, totalAssets: AnnualHoldingsTurnover
//    let yield: AnnualHoldingsTurnover
//    let fundFamily: JSONNull?
//    let fundInceptionDate: AnnualHoldingsTurnover
//    let legalType: JSONNull?
//    let threeYearAverageReturn, fiveYearAverageReturn, priceToSalesTrailing12Months: AnnualHoldingsTurnover
//    let lastFiscalYearEnd, nextFiscalYearEnd, mostRecentQuarter: The52_WeekChange
//    let earningsQuarterlyGrowth, revenueQuarterlyGrowth: AnnualHoldingsTurnover
//    let netIncomeToCommon: EnterpriseValue
//    let trailingEps, forwardEps: The52_WeekChange
//    let pegRatio: AnnualHoldingsTurnover
//    let lastSplitFactor: JSONNull?
//    let lastSplitDate: AnnualHoldingsTurnover
//    let enterpriseToRevenue, enterpriseToEbitda, the52WeekChange, sandP52WeekChange: The52_WeekChange
//    let lastDividendValue, lastDividendDate, lastCapGain, annualHoldingsTurnover: AnnualHoldingsTurnover
//
//    enum CodingKeys: String, CodingKey {
//        case maxAge, priceHint, enterpriseValue, forwardPE, profitMargins, floatShares, sharesOutstanding, sharesShort, sharesShortPriorMonth, sharesShortPreviousMonthDate, dateShortInterest, sharesPercentSharesOut, heldPercentInsiders, heldPercentInstitutions, shortRatio, shortPercentOfFloat, beta, impliedSharesOutstanding, morningStarOverallRating, morningStarRiskRating, category, bookValue, priceToBook, annualReportExpenseRatio, ytdReturn, beta3Year, totalAssets, yield, fundFamily, fundInceptionDate, legalType, threeYearAverageReturn, fiveYearAverageReturn, priceToSalesTrailing12Months, lastFiscalYearEnd, nextFiscalYearEnd, mostRecentQuarter, earningsQuarterlyGrowth, revenueQuarterlyGrowth, netIncomeToCommon, trailingEps, forwardEps, pegRatio, lastSplitFactor, lastSplitDate, enterpriseToRevenue, enterpriseToEbitda
//        case the52WeekChange = "52WeekChange"
//        case sandP52WeekChange = "SandP52WeekChange"
//        case lastDividendValue, lastDividendDate, lastCapGain, annualHoldingsTurnover
//    }
//}
//
//// MARK: - AnnualHoldingsTurnover
//struct AnnualHoldingsTurnover: Codable {
//}
//
//// MARK: - The52_WeekChange
//struct The52_WeekChange: Codable {
//    let raw: Double
//    let fmt: String
//}
//




