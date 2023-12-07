//
//  CurrencyConverter.swift
//  CurrencyConverter
//
//  Created by Tony Santiago on 07/12/23.
//

import Foundation

struct CurrencyRelation: Hashable {
    let currency: String
    var relatedCurrencies: Set<String>
}

struct CurrencyExchangeRate: Decodable {
    var bid: String
}

class CurrencyService {
    func fetchCurrencyRelations(completion: @escaping (Result<([String: Set<String>], [String: String]), Error>) -> Void) {
        guard let url = URL(string: "https://economia.awesomeapi.com.br/xml/available") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            let parser = CurrencyXMLParser(data: data)
            let (currencyRelations, currencyNames) = parser.parse()
            completion(.success((currencyRelations, currencyNames)))
        }.resume()
    }
    
    func fetchExchangeRate(from baseCurrency: String, to targetCurrency: String, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: "https://economia.awesomeapi.com.br/last/\(baseCurrency)-\(targetCurrency)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let exchangeRateResponse = try? JSONDecoder().decode([String: CurrencyExchangeRate].self, from: data),
                  let exchangeRate = exchangeRateResponse["\(baseCurrency)\(targetCurrency)"]?.bid else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }
            
            if let rate = Double(exchangeRate) {
                completion(.success(rate))
            } else {
                completion(.failure(URLError(.cannotParseResponse)))
            }
        }.resume()
    }
}


class CurrencyXMLParser: NSObject, XMLParserDelegate {
    private var data: Data
    private var currencyRelations = [String: Set<String>]()
    private var currencyNames = [String: String]()
    private var currentElement = ""
    private var foundCharacters = ""
    
    init(data: Data) {
        self.data = data
    }
    
    func parse() -> ([String: Set<String>], [String: String]) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return (currencyRelations, currencyNames)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        let components = elementName.components(separatedBy: "-")
        if components.count == 2 {
            let baseCurrency = components[0]
            let relatedCurrency = components[1]
            
            addRelation(from: baseCurrency, to: relatedCurrency)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let components = elementName.components(separatedBy: "-")
        if components.count == 2 {
            let currencyNamesArray = foundCharacters.components(separatedBy: "/")
            if currencyNamesArray.count == 2 {
                currencyNames[components[0]] = currencyNamesArray[0].trimmingCharacters(in: .whitespacesAndNewlines)
                currencyNames[components[1]] = currencyNamesArray[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            foundCharacters = ""
        }
    }
    
    private func addRelation(from baseCurrency: String, to relatedCurrency: String) {
        if var relations = currencyRelations[baseCurrency] {
            relations.insert(relatedCurrency)
            currencyRelations[baseCurrency] = relations
        } else {
            currencyRelations[baseCurrency] = [relatedCurrency]
        }
    }
}
