//
//  FirestorageHelper.swift
//  Leksikon
//
//  Created by Владислав Форафонтов on 02/03/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase

/** Общается с FirebaseStorage, получает файлы, загружает их в папку Documents/.. */
class FirestorageHelper {
    
    private static let storage = Storage.storage()
    private let storageRef = Storage.storage().reference()
    private var downloadTasks: [String : StorageDownloadTask] = [:]
    
    /** Загружает (заменяет) файл groups.txt из Firebase в папку Documents/Words */
    func downloadFile(_ path: String, completion: ((_ data: Data)->())? = nil) {
        
        guard !path.isEmpty else {return}
        
        let components = path.components(separatedBy: "/")
        
        var fileRef = storageRef
        for p in components {
            fileRef = fileRef.child(p)
        }
        
        downloadTasks[components.last!] = fileRef.getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
            
            if let data = data, let completion = completion {
                completion(data)
            } else {
                if let error = error {
                    print(error)
                }
            }
        })
        
    }
}
