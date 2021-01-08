//
//  Note.swift
//  SwiftUIEditor
//
//  Created by admin on 11/09/2020.
//  Copyright © 2020 Signe. All rights reserved.
//

import SwiftUI

// Man skal kunne genkende noter på deres id
class Note: Identifiable
{
    // Automatisk unik genereret id med UUID
    // Er et swift objekt så derfor er der paranteser
    var id = UUID()
    var title: String
    //var text: String
    var image: Image?
    
    var imageName: String
    
    init(title: String, image: Image? = nil, imageName: String, id:UUID)
    {
        self.title = title
        self.image = image
        self.id = id
        self.imageName = imageName
    }
}
