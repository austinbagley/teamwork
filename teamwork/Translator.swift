//
//  Translator.swift
//  teamwork
//
//  Created by Austin Bagley on 2/22/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import Foundation


class Translator {
    
    
    static func convertFromObject(object: NSObject) -> String {
        
      return ""
    }
    
    
    static func convertToObject<ObjectType: NSObject>(dict: NSDictionary, key: String) -> ObjectType {
        
        let object: ObjectType = ObjectType()
        
        if(object.respondsToSelector(NSSelectorFromString("id"))) {
            object.setValue(key, forKey: "id")
            print("set id to \(key)")
        }
        
        for (key, value) in dict {
            print("trying to set value of \(key) to \(value) of type \(value)")
         
            if(object.respondsToSelector(NSSelectorFromString(key as! String))) {
                object.setValue(value, forKey: key as! String)
                print("set \(key) to \(value)")
            }
        }
    
        return object
    }
    
}
