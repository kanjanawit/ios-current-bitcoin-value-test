//
//  GetLatestBitcoinValueUseCase.swift
//  CurrentBitCoinValue
//
//  Created by Kan MacBook Pro on 18/9/2566 BE.
//

import Foundation
protocol GetLatestBitcoinValueUseCaseProtocol: AnyObject {
    func execute() async -> Swift.Result<LatestBitcoinValueResponseModel, Error>
}

class GetLatestBitcoinValueUseCase: GetLatestBitcoinValueUseCaseProtocol {
    func execute() async -> Result<LatestBitcoinValueResponseModel, Error> {
        let result: Result<LatestBitcoinValueResponseModel, Error> = await withCheckedContinuation({ continuation in
            guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else {
                continuation.resume(returning: .failure(AppError.convertToUrlError))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) {
                data, response, error in
                if let data = data {
                    if let string = String(data: data, encoding: .utf8){
                        print(string)
                        
                    }
                    let decoder = JSONDecoder()
                    
                    do {
                        let responseObject = try decoder.decode(LatestBitcoinValueResponseModel.self, from: data)
                        continuation.resume(returning: .success(responseObject))
                    } catch {
                        continuation.resume(returning: .failure(AppError.convertObjectError))
                    }
                }
                
                if let error = error {
                    continuation.resume(returning: .failure(error))
                    return
                }
            }
            
            task.resume()
        })
        return result
    }
}
