//
//  DatabaseHelper.swift
//  Zeus
//
//  Created by Renchi Liu on 3/30/25.
//

import Foundation
import SQLite

//TODO: Implementing Multi-Level Caching
//TODO: Add ordering and List return

struct ProfileDB {
    static let shared = ProfileDB()
    private let db: Connection
    private let profiles = Table(Constants.Database.tableName)
    
    private init(fileManager: FileManager = .default, bundle: Bundle = .main, databasePath: String? = nil) {
        let dbPath: String
        if let databasePath = databasePath {
            dbPath = databasePath
        } else {
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            dbPath = documentsURL.appendingPathComponent(Constants.Database.fileName).path
        }
        
        if !fileManager.fileExists(atPath: dbPath) {
            if let sourceURL = bundle.url(forResource: Constants.Database.fileName, withExtension: nil) {
                do {
                    try fileManager.copyItem(at: sourceURL, to: URL(fileURLWithPath: dbPath))
                    print(ProfileDBMessages.databaseCopied)
                } catch {
                    fatalError(String(format: ProfileDBMessages.databaseCopyFailed, "\(error)"))
                }
            } else {
                fatalError(ProfileDBMessages.databaseNotFound)
            }
        } else {
            print(ProfileDBMessages.databaseExists)
        }
        
        do {
            db = try Connection(dbPath)
        } catch {
            fatalError(String(format: ProfileDBMessages.databaseConnectionFailed, "\(error)"))
        }
    }
    
    func searchNameOrIDRawSQL(service: String, forName query: String) -> (id: String, name: String)? {
        let likeQuery = "%\(query)%"
        do {
            let statement = try db.prepare(Constants.SQLQueries.searchProfile)
            var fallback: (String, String)?
            
            for row in try statement.run(service, likeQuery) {
                guard let idValue = row[0] as? String,
                      let nameValue = row[1] as? String else { continue }
                
                if nameValue == query {
                    return (id: idValue, name: nameValue)
                }
                
                if fallback == nil {
                    fallback = (idValue, nameValue)
                }
            }
            
            return fallback.map { (id: $0.0, name: $0.1) }
            
        } catch {
            print(String(format: ProfileDBMessages.sqlQueryFailed, "\(error)"))
            return nil
        }
    }
    
    func fetchRandomProfile() -> (id: String, name: String, service: ServiceType)? {
        for service in ServiceType.allCases.shuffled() {
            do {
                let statement = try db.prepare(Constants.SQLQueries.fetchRandomProfile)
                for row in try statement.run(service.rawValue) {
                    if let id = row[0] as? String,
                       let name = row[1] as? String {
                        return (id: id, name: name, service: service)
                    }
                }
            } catch {
                print(String(format: ProfileDBMessages.randomFetchFailed, service.rawValue, "\(error)"))
            }
        }
        return nil
    }
    
    func fetchSuperLuckyProfile() -> (id: String, name: String, service: ServiceType)? {
        for service in ServiceType.allCases.shuffled() {
            do {
                let statement = try db.prepare(Constants.SQLQueries.fetchSuperLuckyProfile)
                for row in try statement.run(service.rawValue) {
                    if let id = row[0] as? String,
                       let name = row[1] as? String {
                        return (id: id, name: name, service: service)
                    }
                }
            } catch {
                print(String(format: ProfileDBMessages.superLuckyFetchFailed, service.rawValue, "\(error)"))
            }
        }
        return nil
    }
}

struct ProfileDBMessages {
    static let databaseCopied = "✅ Database successfully copied to Documents directory"
    static let databaseCopyFailed = "❌ Failed to copy database file: %@"
    static let databaseNotFound = "❌ profiles.sqlite3 not found in app bundle"
    static let databaseExists = "✅ Database file already exists in Documents directory"
    static let databaseConnectionFailed = "❌ Failed to connect to database: %@"
    static let sqlQueryFailed = "❌ SQL query failed: %@"
    static let randomFetchFailed = "❌ Random fetch failed (%@): %@"
    static let superLuckyFetchFailed = "❌ Super lucky fetch failed (%@): %@"
}
