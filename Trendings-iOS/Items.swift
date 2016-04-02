//
//  Repo.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/3/27.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import Argo
import Curry

struct Contributor {
    let avatar: String
    let username: String
}

extension Contributor: Decodable {
    static func decode(j: JSON) -> Decoded<Contributor> {
        return curry(Contributor.init)
            <^> j <| "username"
            <*> j <| "avatar"
    }
}

struct Repo {
    let name: String
    let url: String
    let star: String
    let owner: String
    let language: String
    let description: String
    let contributors: [Contributor]
}

extension Repo: Decodable {
    static func decode(j: JSON) -> Decoded<Repo> {
        let f = curry(Repo.init)
            <^> j <| "name"
            <*> j <| "url"
            <*> j <| "star"
            <*> j <| "owner"
        
        return f
            <*> j <| "language"
            <*> j <| "description"
            <*> j <|| "contributors"
    }
}

struct RepoItems {
    let count: Int
    let status: String
    let items: [Repo]
}

extension RepoItems: Decodable {
    static func decode(j: JSON) -> Decoded<RepoItems> {
        return curry(RepoItems.init)
            <^> j <| "count"
            <*> j <| "status"
            <*> j <|| "items"
    }
}


struct Developers {
    let avatar: String
    let fullName: String
    let loginName: String
    let rank: Int
    let repoDesc: String
    let repoName: String
    let repoUrl: String
    let url: String
}

extension Developers: Decodable {
    static func decode(j: JSON) -> Decoded<Developers> {
        return curry(Developers.init)
            <^> j <| "avatar"
            <*> j <| "full_name"
            <*> j <| "login_name"
            <*> j <| "rank"
            <*> j <| "repo_desc"
            <*> j <| "repo_name"
            <*> j <| "repo_url"
            <*> j <| "url"
    }
}

struct DevItems {
    let count: Int
    let items: [Developers]
    let status: String
}

extension DevItems: Decodable {
    static func decode(j: JSON) -> Decoded<DevItems> {
        return curry(DevItems.init)
            <^> j <| "count"
            <*> j <|| "items"
            <*> j <| "status"
    }
}


