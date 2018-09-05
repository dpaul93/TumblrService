//
//  GenericMapper.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol GenericMapper: class {
    associatedtype Object: Any
    
    func mapFromJSON(_ json: JSON) -> Object?
}

protocol GenericArrayMapper: GenericMapper {
    func mapArrayFromJSON(_ json: JSON) -> [Object]
}

class AnyGenericMapper<Obj: Any>: GenericMapper {
    typealias Object = Obj
    
    private let _mapFromJSON: ((JSON) -> Obj?)
    
    required init<GM: GenericMapper>(_ mapper: GM) where GM.Object == Obj {
        _mapFromJSON = mapper.mapFromJSON
    }
    
    func mapFromJSON(_ json: JSON) -> Obj? {
        return _mapFromJSON(json)
    }
}

class AnyGenericArrayMapper<Obj: Any>: GenericArrayMapper {
    typealias Object = Obj
    
    private let _mapFromJSON: ((JSON) -> Obj?)
    private let _mapArrayFromJSON: ((JSON) -> [Obj])
    
    required init<GM: GenericArrayMapper>(_ mapper: GM) where GM.Object == Obj {
        _mapFromJSON = mapper.mapFromJSON
        _mapArrayFromJSON = mapper.mapArrayFromJSON
    }
    
    func mapFromJSON(_ json: JSON) -> Obj? {
        return _mapFromJSON(json)
    }
    
    func mapArrayFromJSON(_ json: JSON) -> [Obj] {
        return _mapArrayFromJSON(json)
    }
}
