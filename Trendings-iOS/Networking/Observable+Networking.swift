//
//  Observable+Networking.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/3/27.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import RxSwift
import Argo
import Moya


enum ORMError : ErrorType {
    case ORMNoRepresentor
    case ORMNotSuccessfulHTTP
    case ORMNoData
    case ORMCouldNotMakeObjectError
}

extension Observable {
    private func resultFromJSON<T: Decodable>(object:[String: AnyObject], classType: T.Type) -> T? {
        let decoded = classType.decode(JSON.parse(object))
        switch decoded {
        case .Success(let result):
            return result as? T
        case .Failure(let error):
            NSLog("\(error)")
            return nil
            
        }
    }
    
    func mapSuccessfulHTTPToObject<T: Decodable>(type: T.Type) -> Observable<T> {
        return map { representor in
            guard let response = representor as? Response else {
                throw ORMError.ORMNoRepresentor
            }
            guard ((200...209) ~= response.statusCode) else {
                if let json = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] {
                    NSLog("Got error message: \(json)")
                }
                throw ORMError.ORMNotSuccessfulHTTP
            }
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] else {
                    throw ORMError.ORMCouldNotMakeObjectError
                }
                return self.resultFromJSON(json, classType:type)!
            } catch {
                throw ORMError.ORMCouldNotMakeObjectError
            }
        }
    }
    
    func mapSuccessfulHTTPToObjectArray<T: Decodable>(type: T.Type) -> Observable<[T]> {
        return map { response in
            guard let response = response as? Response else {
                throw ORMError.ORMNoRepresentor
            }
            
            // Allow successful HTTP codes
            guard ((200...209) ~= response.statusCode) else {
                if let json = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] {
                    NSLog("Got error message: \(json)")
                }
                throw ORMError.ORMNotSuccessfulHTTP
            }
            
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [[String : AnyObject]] else {
                    throw ORMError.ORMCouldNotMakeObjectError
                }
                
                // Objects are not guaranteed, thus cannot directly map.
                var objects = [T]()
                for dict in json {
                    if let obj = self.resultFromJSON(dict, classType:type) {
                        objects.append(obj)
                    }
                }
                return objects
                
            } catch {
                throw ORMError.ORMCouldNotMakeObjectError
            }
        }
    }
}