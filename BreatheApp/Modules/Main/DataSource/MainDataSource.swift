//
//  MainDataSource.swift
//  BreatheApp
//
//  Created by Andrii Rogulin on 3/31/18.
//  Copyright © 2018 Andrii Rogulin. All rights reserved.
//

import Foundation
import SwiftyJSON

class MainDataSource: MainDataSourceInterface, LocalDataSource {
    
    
    weak var dataHandler: MainDataHandler?
    
    var fileName: String?
    
    required init(fileName: String?) {
        self.fileName = fileName
    }
    
    
    func loadData() {
        
        let unsuccessfulLoad: (()->()) = { [weak self] in
            let error = NSError(domain: "com.breathe", code: -1100, userInfo: [NSLocalizedDescriptionKey:"str_error_description".localized.capitalized])
            self?.dataHandler?.onDataLoadError(error: error)
        }
        
        guard let fileNameComponents = fileName?.components(separatedBy: ".") else {
            unsuccessfulLoad()
            return
        }
        guard fileNameComponents.count == 2 else {
            unsuccessfulLoad()
            return
        }
        guard let filePath = Bundle.main.path(forResource: fileNameComponents[0], ofType: fileNameComponents[1]) else {
            unsuccessfulLoad()
            return
        }
        guard let jsonData = NSData(contentsOfFile:filePath) else {
            unsuccessfulLoad()
            return
        }
        
        do {
            let jsonArray = try JSON(data: jsonData as Data).arrayValue
            var dictionaries = [[String: Any]]()
            
            for json in jsonArray {
                if let dictionary = json.dictionaryObject {
                    dictionaries.append(dictionary)
                }
            }
            dataHandler?.onLoadedData(dataObjects: dictionaries)
        } catch {
            unsuccessfulLoad()
        }
        
        
        
    }
    
    
}
