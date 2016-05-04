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

let endpointClosure = { (target: GitHubAPI) -> Endpoint<GitHubAPI> in
    let endpoint: Endpoint<GitHubAPI> = Endpoint<GitHubAPI>(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
    return endpoint.endpointByAddingHTTPHeaderFields(["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36"])
}



private let trendingProvider = RxMoyaProvider<TrendingAPI>()
private let githubProvider = RxMoyaProvider<GitHubAPI>(endpointClosure: endpointClosure)
private var disposeBag = DisposeBag()


//MARK: GitHub API

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
        //disposeBag = DisposeBag()
        trendingProvider.request(.Trending(language, since))
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
        //disposeBag = DisposeBag()
        trendingProvider.request(.Developer(language, since))
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


//MARK: GitHub API

public enum GitHubAPI {
    case SearchRepos(String, String)
    case SearchUsers(String, String)
    case TopRepos(String, String)
    case TopUsers(String, String, String)
}

extension GitHubAPI: TargetType {
    public var baseURL: NSURL { return NSURL(string : "https://api.github.com/search")! }
    public var path: String {
        switch self {
        case .TopRepos(_, _):
            fallthrough
        case .SearchRepos(_):
            return "/repositories"
        case .TopUsers(_, _, _):
            fallthrough
        case .SearchUsers(_):
            return "/users"
        }
    }
    
    public var method: Moya.Method {
        return .GET
    }
    
    public var parameters: [String: AnyObject]? {
        switch self {
        case .SearchRepos(let keyword, let page):
            return ["q": keyword, "page": page]
        case .SearchUsers(let keyword, let page):
            return ["q": keyword, "page": page]
        case .TopRepos(let language, let page):
            return ["q": "language:\(language)", "page": page, "sort": "stars", "order": "desc"]
        case .TopUsers(let location, let language, let page):
            return ["q": "location:\(location) language:\(language)", "page": page, "sort": "followers", "order": "desc"]
        }
    }
    
    public var sampleData: NSData {
        switch self {
        default:
            return NSData()
        }
        
    }
}

extension GitHubAPI {
    static func searchRepos(keyword: String, page: String, completion: GithubRepos -> Void, fail: ErrorType -> Void) {
        githubProvider.request(.SearchRepos(keyword, page))
            .mapSuccessfulHTTPToObject(GithubRepos)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { items in
                    completion(items)
                }, onError: { error in
                    fail(error)
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    static func searchUsers(keyword: String, page: String, completion: GithubUsers -> Void, fail: ErrorType -> Void) {
        githubProvider.request(.SearchUsers(keyword, page))
            .mapSuccessfulHTTPToObject(GithubUsers)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { items in
                    completion(items)
                }, onError: { error in
                    fail(error)
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    static func topRepos(language: String, page: String, completion: GithubRepos -> Void, fail: ErrorType -> Void) {
        githubProvider.request(.TopRepos(language, page))
            .mapSuccessfulHTTPToObject(GithubRepos)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { items in
                    completion(items)
                }, onError: { error in
                    fail(error)
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    static func topUsers(location: String, language: String, page: String, completion: GithubUsers -> Void, fail: ErrorType ->Void) {
        githubProvider.request(.TopUsers(location, language, page))
            .mapSuccessfulHTTPToObject(GithubUsers)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {items in
                    completion(items)
                }, onError: { error in
                    fail(error)
                }
            ).addDisposableTo(disposeBag)
    }

    
}

