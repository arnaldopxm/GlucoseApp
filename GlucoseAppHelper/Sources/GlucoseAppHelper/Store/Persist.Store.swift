//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 27/1/22.
//

import Foundation

@available(watchOS 6.0, *)
@available(iOS 13.0, *)
public class PersistStore {
    
    public static var singleton = PersistStore()
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("glucose.data")
    }
    
    public static func load(completion: @escaping (Result<StoreModel?, Error>)->Void) {
        DispatchQueue.global(qos: .background).sync {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.sync {
                        completion(.success(nil))
                    }
                    return
                }
                let currentData = try JSONDecoder().decode(StoreModel.self, from: file.availableData)
                DispatchQueue.main.sync {
                    completion(.success(currentData))
                }
            } catch {
                DispatchQueue.main.sync {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public static func save(glucoseData: StoreModel?, completion: @escaping (Result<Int, Error>)->Void) {
        if glucoseData == nil {
            DispatchQueue.main.sync {
                completion(.success(0))
            }
        }
        DispatchQueue.global(qos: .background).sync {
            do {
                let data = try JSONEncoder().encode(glucoseData)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.sync {
                    completion(.success(1))
                }
            } catch {
                DispatchQueue.main.sync {
                    completion(.failure(error))
                }
            }
        }
    }
}



