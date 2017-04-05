//
//  SVNShapeMetaData.swift
//  SVNShapesManager
//
//  Created by Aaron Dean Bikis on 4/5/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import Foundation

public struct SVNShapeMetaData {
    var shapes: [CAShapeLayer]?
    var location: SVNShapeLocation
    var padding: CGPoint
    var size: CGSize
    var fill: CGColor
    var stroke: CGColor
    var strokeWidth: CGFloat
    
    init(meta: SVNShapeMetaData){
        self.shapes = meta.shapes
        self.location = meta.location
        self.padding = meta.padding
        self.size = meta.size
        self.fill = meta.fill
        self.stroke = meta.stroke
        self.strokeWidth = meta.strokeWidth
    }
    
    init(shapes: [CAShapeLayer]?, location: SVNShapeLocation, padding: CGPoint, size:CGSize, fill:CGColor, stroke:CGColor, strokeWidth: CGFloat){
        self.shapes = shapes
        self.location = location
        self.padding = padding
        self.size = size
        self.fill = fill
        self.stroke = stroke
        self.strokeWidth = strokeWidth
    }
    
    mutating func flushLayers(){
        self.shapes?.forEach({ $0.removeFromSuperlayer() })
    }
}
