//
//  ------ Config ------.swift
//  SSGaming
//
//  Created by kamoguai on 2023/12/26.
//  Copyright © 2023 Bohan. All rights reserved.
//

import UIKit
let imageViewContentMode: UIView.ContentMode = .scaleAspectFill
let WEBVIEW_URL:String = WebViewURL(.ssapp0com).url
let proxyV4List:Array = ["34.92.220.7,3129,guest,Abc12345"]
let proxyV6List:Array = ["2600:1900:41a0:81ce:0:2:0:0,3129,guest,Abc12345"]
var enableProxy:Bool = true
var retryCount:Int = 3
///選擇proxy
func selectedProxy() {
    var isIpv4 = false
    if let ipVersion = getIpAddressVersin() {
        print("The device is connected to an \(ipVersion) network.")
        if ipVersion == "IPv4"{
            isIpv4 = true
        } else{
            isIpv4 = false
        }
    } else {
        print("No IP address found.")
    }
    var proxyStr = ""
    if isIpv4 {
        if let randomList = proxyV4List.randomElement() {
            proxyStr = randomList
        }
    }
    else {
        if let randomList = proxyV6List.randomElement() {
            proxyStr = randomList
        }
    }
    
    
   
    let split = proxyStr.split(separator: ",")
    isProxyAvailable(proxyHost: "\(split[0])", proxyPort: Int("\(split[1])")!){ available in
        if available {
            print("代理可用")
        } else {
            print("代理不可用, retry: \(retryCount)")
            ///重新三次機會
            if retryCount > 0 {
                selectedProxy()
            }
            retryCount -= 1
        }
    }
    ConfigVariables.proxyHost = "\(split[0])"
    ConfigVariables.proxyPort = Int("\(split[1])")!
    ConfigVariables.proxyUserName = "\(split[2])"
    ConfigVariables.proxyPassword = "\(split[3])"
    
}
///取得現在網路類型，並返回 ipv4 or ipv6
func getIpAddressVersin() -> String? {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while ptr != nil {
            defer {
                ptr = ptr?.pointee.ifa_next
            }
            guard let interface = ptr?.pointee else {continue}
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
                
                if addrFamily == UInt8(AF_INET) {
                    return "IPv4"
                } else if addrFamily == UInt8(AF_INET6) {
                    return "IPv6"
                }
            }
        }
        
      freeifaddrs(ifaddr)
    }
    return address != nil ? "Unknown" : nil
}

func isProxyAvailable(proxyHost: String, proxyPort: Int, completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: WEBVIEW_URL) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0 // 设置超时时间

        // 配置代理
        let config = URLSessionConfiguration.default
        config.connectionProxyDictionary = [
            kCFNetworkProxiesHTTPEnable as String: true,
            kCFNetworkProxiesHTTPProxy as String: proxyHost,
            kCFNetworkProxiesHTTPPort as String: proxyPort
        ]

        // 創建 URLSession
        let session = URLSession(configuration: config)
        
        // 發起請求
        let task = session.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // 請求成功，代理可用
                completion(true)
            } else {
                // 請求失敗，代理不可用
                completion(false)
            }
        }
        task.resume()
}


class ConfigVariables {
    static var proxyHost:String = ""
    static var proxyPort:Int = 0
    static var proxyUserName:String = ""
    static var proxyPassword:String = ""
}
