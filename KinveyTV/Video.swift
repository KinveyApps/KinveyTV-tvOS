//
//  Video.swift
//  KinveyTV
//
//  Created by Victor Hugo on 2017-07-12.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey

class Video: Entity {
    
    dynamic var title: String?
    dynamic var thumbnailFileId: String?
    dynamic var videoFileId: String?
    
    override class func collectionName() -> String {
        return "Video"
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        title <- ("title", map["title"])
        thumbnailFileId <- ("thumbnailFileId", map["thumbnail_file_id"])
        videoFileId <- ("videoFileId", map["video_file_id"])
    }
    
}
