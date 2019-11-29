//
//  FileManager.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 19/02/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit

/** Класс-помощник для работы с файлами */
class FileHelper {
    
    private init() {
        do {
            try fileManager.createDirectory(atPath: objectsPath, withIntermediateDirectories: false, attributes: nil)
            
            try fileManager.createDirectory(atPath: previewsPath, withIntermediateDirectories: false, attributes: nil)

        } catch { }
    }
    
    static var shared = FileHelper()
    
    let fileManager = FileManager.default
    
    /** Путь к папке Documents */
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    /** Название папки с файлами для повторения */
    var objectsPath: String {
        return documentDirectory + "/Objects"
    }
    
    /** Название папки с файлами, отвечающими за слова (которые с firebase) */
    var previewsPath: String {
        return documentDirectory + "/Previews"
    }
    
    /** Сохраняет data в to */
    func save(_ data: Data, to: String) {
        fileManager.createFile(atPath: to, contents: data, attributes: nil)
    }
}
