//
//  SVNShapeMetaData.swift
//  SVNShapesManager
//
//  Created by Aaron Dean Bikis on 4/5/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import Foundation
/**
 SVNShapeMetaData is used by SVNShapesManager to layout, create, animate and mutate CALayers.
 All values are mutable
 - variables:
    - shapes: [CAShapeLayer]? A place to store created shapes from SVNShapesManager
    - location: SVNShapeLocation designate a location in a 9x9 graph in the containing view for which to layout a shape
    - padding: CGPoint This point will be used by SVNShapesManager to pad against the containing view
    - size: CGSize The size that the shape will be 
    - fill: CGColor The fillColor of the shape
    - stroke: CGColor The strokeColor of the shape
    - strokeWidth: The lineWidth of the shape
*/
public struct SVNShapeMetaData {
    public var shapes: [CAShapeLayer]?
    public var location: SVNShapeLocation
    public var padding: CGPoint
    public var size: CGSize
    public var fill: CGColor
    public var stroke: CGColor
    public var strokeWidth: CGFloat
    
    public init(meta: SVNShapeMetaData){
        self.shapes = meta.shapes
        self.location = meta.location
        self.padding = meta.padding
        self.size = meta.size
        self.fill = meta.fill
        self.stroke = meta.stroke
        self.strokeWidth = meta.strokeWidth
    }
    /**
     Creates a SVNShapeMetaData type
    */
    public init(shapes: [CAShapeLayer]?, location: SVNShapeLocation, padding: CGPoint, size:CGSize, fill:CGColor, stroke:CGColor, strokeWidth: CGFloat){
        self.shapes = shapes
        self.location = location
        self.padding = padding
        self.size = size
        self.fill = fill
        self.stroke = stroke
        self.strokeWidth = strokeWidth
    }
    
    /**
     A helper function that removes shapes from their superLayers
    */
    public mutating func flushLayers(){
        self.shapes?.forEach({ $0.removeFromSuperlayer() })
    }
}
