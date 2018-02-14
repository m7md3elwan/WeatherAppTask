//
//  Cachable.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

public protocol Cachable: Codable {
    var url: URL { get }
    func store()
    mutating func retrieve()
    func clear()
}

extension Cachable {
    
    var url: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(String(describing: type(of: self)), isDirectory: false)
    }
    
    func store() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    mutating func retrieve()  {
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                self = try decoder.decode(type(of: self), from: data)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func clear() {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func fileExists(_ fileName: String) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
}
