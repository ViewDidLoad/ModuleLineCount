//
//  ViewController.swift
//  ModuleLineCounter
//
//  Created by viewdidload on 2017. 4. 11..
//  Copyright © 2017년 ViewDidLoad. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var fileButton: NSButton!
    @IBOutlet weak var chooseDirectoryLabel: NSTextField!
    @IBOutlet weak var lineTableView: NSTableView!
    
    var files: [URL] = []
    var fileList: [FileList] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lineTableView.delegate = self
        lineTableView.dataSource = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func FileBrowserClick(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        // directory choose
        dialog.canChooseDirectories = true
        if (dialog.runModal() == NSModalResponseOK) {
            if let chooseDir = dialog.url {
                fileList.removeAll()
                chooseDirectoryLabel.stringValue = chooseDir.absoluteString
                let fileManager = FileManager()
                files = fileManager.listFiles(path: (dialog.url?.path)!).filter {$0.absoluteString.hasSuffix(".h") || $0.absoluteString.hasSuffix(".m")}//.map {$0.lastPathComponent}
                files.forEach {
                    let item = FileList()
                    item.name = "\($0.lastPathComponent)"
                    do {
                        let data = try String(contentsOf: $0, encoding: .utf8)
                        item.count = data.components(separatedBy: CharacterSet.newlines).count
                    } catch { print("error") }
                    
                    item.comment = ""
                    fileList.append(item)
                }
                //fileList.sort(by: {$0.count! < $1.count!})
                lineTableView.reloadData()
                let nameColumn = lineTableView.tableColumns.first
                nameColumn?.headerCell.stringValue = "파일명 (\(fileList.count)개)"
            }
        }
        
    }

    // TableView Delegate
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let item = fileList[row]
        if tableColumn?.identifier == "name" {
            return item.name
        } else if tableColumn?.identifier == "count" {
            return item.count
        } else if tableColumn?.identifier == "comment" {
            return item.comment
        } else {
            return "files error"
        }
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        switch tableView.selectedColumn {
        case 0:
            tableView.sortDescriptors.forEach {
                if $0.key == "name" {
                    $0.ascending ? fileList.sort(by: {$0.name < $1.name}) : fileList.sort(by: {$0.name > $1.name})
                }
            }
        case 1:
            tableView.sortDescriptors.forEach {
                if $0.key == "count" {
                    $0.ascending ? fileList.sort(by: {$0.count < $1.count}) : fileList.sort(by: {$0.count > $1.count})
                }
            }
        default:
            print("sortDescriptorsDidChange")
        }
        tableView.reloadData()
    }

    
}

