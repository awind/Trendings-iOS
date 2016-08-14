//
//  Repo.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/3/27.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import Argo
import Curry

//MARK: Trending API Model

struct Contributor {
    let avatar: String
    let username: String
}

extension Contributor: Decodable {
    static func decode(j: JSON) -> Decoded<Contributor> {
        return curry(Contributor.init)
            <^> j <| "avatar"
            <*> j <| "username"
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


struct Developer {
    let avatar: String
    let fullName: String
    let loginName: String
    let rank: Int
    let repoDesc: String
    let repoName: String
    let repoUrl: String
    let url: String
}

extension Developer: Decodable {
    static func decode(j: JSON) -> Decoded<Developer> {
        return curry(Developer.init)
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
    let items: [Developer]
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


// MARK: GitHub API Model

struct Owner {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
    let type: String
}

extension Owner: Decodable {
    static func decode(json: JSON) -> Decoded<Owner> {
        return curry(Owner.init)
            <^> json <| "id"
            <*> json <| "login"
            <*> json <| "avatar_url"
            <*> json <| "html_url"
            <*> json <| "type"
    }
}

struct Repositiory {
    let id: Int
    let name: String
    let fullname: String
    let owner: Owner
    let url: String
    let description: String?
    let forks: Int
    let stars: Int
    let issues: Int
    let language: String?
}

extension Repositiory: Decodable {
    static func decode(json: JSON) -> Decoded<Repositiory> {
        
        let f = curry(Repositiory.init)
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "full_name"
            <*> json <| "owner"
            <*> json <| "html_url"
        return f
            <*> json <|? "description"
            <*> json <| "forks_count"
            <*> json <| "stargazers_count"
            <*> json <| "open_issues_count"
            <*> json <|? "language"
    }
}

struct GithubRepos {
    let count: Int
    let incomplete: Bool
    let items: [Repositiory]
}

extension GithubRepos: Decodable {
    static func decode(json: JSON) -> Decoded<GithubRepos> {
        return curry(GithubRepos.init)
            <^> json <| "total_count"
            <*> json <| "incomplete_results"
            <*> json <|| "items"
    }
}

struct User {
    let id: Int
    let login: String
    let avatar: String
    let url: String
}

extension User: Decodable {
    static func decode(json: JSON) -> Decoded<User> {
        return curry(User.init)
            <^> json <| "id"
            <*> json <| "login"
            <*> json <| "avatar_url"
            <*> json <| "html_url"
    }
}

struct GithubUsers {
    let count: Int
    let incomplete: Bool
    let items: [User]
}

extension GithubUsers: Decodable {
    static func decode(json: JSON) -> Decoded<GithubUsers> {
        return curry(GithubUsers.init)
            <^> json <| "total_count"
            <*> json <| "incomplete_results"
            <*> json <|| "items"
    }
}

