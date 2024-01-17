//
//  URLSessionConfiguration+HttpProxy.swift
//  SSGaming
//
//  Created by kamoguai on 2023/12/26.
//  Copyright © 2023 Bohan. All rights reserved.
//

import Foundation

fileprivate let httpProxyKey = kCFNetworkProxiesHTTPEnable as String
fileprivate let httpHostKey = kCFNetworkProxiesHTTPProxy as String
fileprivate let httpPortKey = kCFNetworkProxiesHTTPPort as String
fileprivate let httpsProxyKey = "HTTPSEnable"
fileprivate let httpsHostKey = "HTTPSProxy"
fileprivate let httpsPortKey = "HTTPSPort"

typealias HttpProxyConfig = (host: String, port: Int)
let httpSchemes = ["http", "https"]

extension URLSessionConfiguration {
    func addProxyConfig(_ config: HttpProxyConfig) {
        let (host, port) = config
        let proxyDict: [String: Any] = [httpProxyKey: true,
                                        httpHostKey: host,
                                        httpPortKey: port,
                                        httpsProxyKey: true,
                                        httpsHostKey: host,
                                        httpsPortKey: port]
        connectionProxyDictionary = proxyDict
    }
     
    func hasProxyConfig(_ config: HttpProxyConfig) -> Bool {
        guard let proxyDic = connectionProxyDictionary,
              let host = proxyDic[httpHostKey] as? String,
              let port = proxyDic[httpPortKey] as? Int,
              config == (host, port)
        else {
            return false
        }
        return true
    }
}


