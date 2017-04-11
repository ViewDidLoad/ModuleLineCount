//
//  extensions.swift
//  ModuleLineCounter
//
//  Created by viewdidload on 2017. 4. 11..
//  Copyright © 2017년 ViewDidLoad. All rights reserved.
//

import Foundation

extension FileManager {
    func listFiles(path: String) -> [URL] {
        let baseurl: URL = URL(fileURLWithPath: path)
        var urls = [URL]()
        enumerator(atPath: path)?.forEach({ (e) in
            guard let s = e as? String else { return }
            let relativeURL = URL(fileURLWithPath: s, relativeTo: baseurl)
            let url = relativeURL.absoluteURL
            urls.append(url)
        })
        return urls
    }
}

class FileList {
    var name: String = ""
    var count: Int = 0
    var comment: String?
}
