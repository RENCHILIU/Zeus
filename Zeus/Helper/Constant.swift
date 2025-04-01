//
//  Constant.swift
//  Zeus
//
//  Created by Renchi Liu on 3/30/25.
//

let BASEURL = "https://renchiliu.com"
enum ServiceType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case S1 = "s1"
    case S2 = "s2"
}

struct Constants {
    struct Database {
        static let fileName = "profiles.sqlite3"
        static let tableName = "profiles"
    }
    
    struct SQLQueries {
        static let searchProfile = """
        SELECT id, name FROM profiles WHERE service = ? AND name LIKE ?
        """
        static let fetchRandomProfile = """
        SELECT id, name FROM profiles WHERE service = ? ORDER BY RANDOM() LIMIT 1
        """
        static let fetchSuperLuckyProfile = """
        SELECT id, name FROM profiles WHERE service = ? AND favorited > 1000 ORDER BY RANDOM() LIMIT 1
        """
    }
}
