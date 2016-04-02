//
//  File.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/3/27.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire


private let provider = RxMoyaProvider<TrendingAPI>()
private var disposeBag = DisposeBag()


public enum TrendingAPI {
    case Trending(String, String)
    case Developer(String, String)
    case Support
}


extension TrendingAPI: TargetType {
    public var baseURL: NSURL { return NSURL(string : "http://162.243.45.82")! }
    public var path: String {
        switch self {
        case .Trending(_, _):
            return "/v2/trendings"
        case .Developer(_, _):
            return "/v2/developers"
        case .Support:
            return "/v2/support"
        }
    }
    
    public var method: Moya.Method {
        return .GET
    }
    
    public var parameters: [String: AnyObject]? {
        switch self {
        case .Trending(let language, let since):
            return ["language": language, "since": since]
        case .Developer(let language, let since):
            return ["language": language, "since": since]
        default:
            return nil
        }
    }
    
    public var sampleData: NSData {
        switch self {
        default:
            return NSData()
        }
        
    }
}

extension TrendingAPI {
    static func getTrendings(language: String, since: String, completion: RepoItems -> Void) {
        disposeBag = DisposeBag()
        provider.request(.Trending(language, since))
            .mapSuccessfulHTTPToObject(RepoItems)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { items in
                    completion(items)
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    static func getDevelopers(language: String, since: String, completion: DevItems -> Void) {
        disposeBag = DisposeBag()
        provider.request(.Developer(language, since))
            .mapSuccessfulHTTPToObject(DevItems)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { items in
                    completion(items)
                }
            )
            .addDisposableTo(disposeBag)
    }
}


private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}
