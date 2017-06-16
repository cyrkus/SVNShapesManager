//
//  SVNShapeLocation.swift
//  SVNShapesManager
//
//  Created by Aaron Dean Bikis on 4/5/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import Foundation

/**
 The intended to be suppported locations to place a shape within a container.
 Call *fetchRect* on an instance of SVNShapesManager to retrive a rect in a 9x9 grid of the SVNShapesManager.container using one of these types.
 - important: Not all of these types are currently supported.
 */
public enum SVNShapeLocation {
    case topLeft, topMid, topRight, midLeft, midMid, midRight, botLeft, botMid, botRight, fullRect
}


