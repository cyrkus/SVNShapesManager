//
//  SVNStandardShapesManager.swift
//  tester
//
//  Created by Aaron Dean Bikis on 4/4/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import UIKit

public enum SVNStandardShape {
    case circle, exit, checkMark, plus, oval
}

public enum ShapeLocation {
    case topLeft, topMid, topRight, midLeft, midMid, midRight, botLeft, botMid, botRight
}




final class SVNShapesManager : NSObject {
    
    private  enum LayerType {
        case circle, oval, firstLine, secondLine, checkMark
    }
    
    private enum ErrorType {
        case nonInstanciatedLayer
        case notSupportedAnimation
        case unSupportedLayer
        case unsupportedLocation
        
        var description: String {
            switch self {
            case .nonInstanciatedLayer:
                return "a layer was not instaciated prior to trying to animate it"
            case .notSupportedAnimation:
                return "This animation is not yet supported"
            case .unSupportedLayer:
                return "This layer is currently unspported"
            case .unsupportedLocation:
                return "This location is currently unsupported"
                
            }
        }
    }
    
    var container: CGRect
    
    init(container: CGRect){
        self.container = container
    }
    
    //MARK: Constructors
    public func fetchRect(for location: ShapeLocation, with padding: CGPoint, and size: CGSize) -> CGRect{
        switch location {
        case .topLeft:
            return CGRect(x: padding.x, y: padding.y, width: size.width, height: size.height)
        case .botMid:
            return CGRect(x: (self.container.width - size.width) / 2, y: self.container.height - (size.height + padding.y), width: size.width, height: size.height)
        case .botRight:
            return CGRect(x: (self.container.width - size.width) - padding.x, y: self.container.height - (size.height + padding.y), width: size.width, height: size.height)
        case .botLeft:
            return CGRect(x: padding.x, y: self.container.height - (size.height + padding.y), width: size.width, height: size.height)
        default:
            fatalError(ErrorType.unsupportedLocation.description)
        }
    }
    
    public func fetchRect(with meta: SVNShapeMetaData) -> CGRect {
        return fetchRect(for: meta.location, with: meta.padding, and: meta.size)
    }
    
    //MARK: Shape Factory
    /**
     Creates a Circle Layer and adds it to the button's sublayer
     - parameters :
     - fillColor: UIColor
     - strokeColor: UIColor
     */
    public func createCircleLayer(with meta: SVNShapeMetaData) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        let rect = fetchRect(with: meta)
        let circlePath = UIBezierPath(roundedRect: rect, cornerRadius: rect.width / 2.0)
        // Setup the CAShapeLayer
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = meta.fill
        circleLayer.strokeColor = meta.stroke
        circleLayer.lineWidth = meta.strokeWidth
        return circleLayer
    }
    
    /**
     Instaciates a two line shape
     - important: Currently only supports types .exit and .plus
     - parameters:
     - type: SVNStandardButtonType
     - strokeColor: UIColor
     - fillColor: UIColor
     */
    public func createTwoLines(with meta: SVNShapeMetaData, shapeToCreate shape: SVNStandardShape) -> [CAShapeLayer] {
        let middle = min(meta.size.width, meta.size.height) * 0.5
        let plus = [CGPoint(x: middle, y: middle/2),
                    CGPoint(x:middle, y: meta.size.height - middle/2),
                    CGPoint(x: middle/2, y: middle),
                    CGPoint(x: meta.size.width - middle/2, y: middle)]
        
        let exit = [CGPoint(x: middle - middle/2, y: middle - middle/2),
                    CGPoint(x: middle + middle/2, y: meta.size.height - (middle  - middle/2)),
                    CGPoint(x: middle + middle/2, y: middle - middle/2),
                    CGPoint(x: middle - middle/2, y: meta.size.height - (middle - middle/2))]
        var points :[CGPoint]!
        
        switch shape {
        case .exit:
            points = exit
        case .plus:
            points = plus
        default:
            fatalError(ErrorType.unSupportedLayer.description)
        }
        
        let firstLineLayer = CAShapeLayer()
        firstLineLayer.strokeColor = meta.stroke
        firstLineLayer.fillColor = meta.fill
        firstLineLayer.lineWidth = meta.strokeWidth
        
        let secondLineLayer = CAShapeLayer()
        secondLineLayer.strokeColor = firstLineLayer.strokeColor
        secondLineLayer.fillColor = firstLineLayer.fillColor
        secondLineLayer.lineWidth = firstLineLayer.lineWidth
        
        let firstLine = UIBezierPath()
        
        firstLine.lineWidth = meta.strokeWidth
        firstLine.move(to: points[0])
        firstLine.addLine(to: points[1])
        
        let secondLine = UIBezierPath()
        
        secondLine.lineWidth = meta.strokeWidth
        secondLine.move(to: points[2])
        secondLine.addLine(to: points[3])
        
        firstLineLayer.path = firstLine.cgPath
        secondLineLayer.path = secondLine.cgPath
        
        return [firstLineLayer, secondLineLayer]
    }
    
    
    public func createCheckMark(with meta: SVNShapeMetaData) -> [CAShapeLayer] {
        let checkMarkLayer = CAShapeLayer()
        let checkMarkPath = UIBezierPath()
        
        checkMarkLayer.strokeColor = meta.stroke
        checkMarkLayer.fillColor = meta.fill
        checkMarkLayer.lineWidth = meta.strokeWidth
        
        let middle = max(meta.size.width, meta.size.height) * 0.5
        
        checkMarkPath.move(to: CGPoint(x: middle / 2, y: middle))
        
        checkMarkPath.addLine(to: CGPoint(x: middle, y: meta.size.height - middle/2))
        
        checkMarkPath.addLine(to: CGPoint(x: meta.size.width - middle/2, y: middle / 2))
        checkMarkLayer.path = checkMarkPath.cgPath
        
        return [checkMarkLayer]
    }
    
    //MARK: Animations
    /**
     Animates a circle shape to have the path of a horizontal oval
     */
    public func animateToOval(with meta: SVNShapeMetaData, in duration: Double, withNewLocation location: ShapeLocation?, withBlock block: (() -> Void)?) {
        guard let circle = meta.shapes?.first else { fatalError(ErrorType.nonInstanciatedLayer.description) }
        CATransaction.begin()
        CATransaction.setCompletionBlock(block)
        var rect: CGRect!
        if location == nil {
            rect = self.fetchRect(with: meta)
        } else {
            rect = self.fetchRect(for: location!, with: meta.padding, and: meta.size)
        }
        let widthChange = rect.width / 2
        let heightChange = rect.height / 4
        let newRect = CGRect(x: rect.origin.x - (widthChange / 2),
                             y: rect.origin.y + (heightChange / 2),
                             width: rect.width + widthChange,
                             height: rect.height - heightChange)
        
        let ovalPath = UIBezierPath(roundedRect: newRect, cornerRadius: newRect.width / 4)
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = ovalPath.cgPath
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.isRemovedOnCompletion = false // don't remove after finishing
        circle.add(animation, forKey: animation.keyPath!)
        CATransaction.commit()
    }
    
    public func animate(to location: ShapeLocation, meta: SVNShapeMetaData, withBlock block: (() -> Void)?) {
        guard let shape = meta.shapes?.first else { fatalError(ErrorType.nonInstanciatedLayer.description) }
        CATransaction.begin()
        CATransaction.setCompletionBlock(block)
        let rect = self.fetchRect(for: location, with: meta.padding, and: meta.size)
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = rect.origin
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        shape.add(animation, forKey: animation.keyPath!)
        CATransaction.commit()
    }
    
    /**
     Animates the opacity of all shapes in the metaData
     */
    public func animateOpacity(of layers: [CAShapeLayer], to opacity: Double, in duration: Double, withBlock block: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(block)
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.toValue = opacity
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        layers.forEach({$0.add(animation, forKey: animation.keyPath!)})
        CATransaction.commit()
    }
    
    
    
    /**
     Creates and add a layer or layers of the type to the button's subview
     - parameters:
     - state: SVNStandardButtonType the button type to create
     - fillColor: UIColor the color to fill the layers
     - strokeColor: UIColor the color to stroke the layers with
     - important: will remove all previously added SVNStandardButtonType layers
     
     public func createLayer(for shape: SVNStandardShape, fillColor: UIColor, strokeColor: UIColor) {
     if customLayers != nil {
     customLayers?.forEach({ $0.value.removeFromSuperlayer() })
     customLayers = nil
     }
     self.currentShape = shape
     switch shape {
     case .checkMark:
     self.createCheckMark(withFillColor: fillColor, strokeColor: strokeColor)
     case .circle:
     self.createCircleLayer(with: fillColor, strokeColor: strokeColor)
     case .exit:
     self.createTwoLines(with: shape, strokeColor: strokeColor, fillColor: fillColor)
     case .plus:
     self.createTwoLines(with: shape, strokeColor: strokeColor, fillColor: fillColor)
     case .oval:
     break
     }
     }
     */
    
    /**
     Will animate using defaults
     - parameters:
     - startState: *SVNStandardButtonType* the state that the current layer is in
     - endState: *SVNStandardButtonType* the state the the layer will animate to
     - startDuration: Double the duration for the first half of the animation. default is 0.5
     - endDuration: Double the duration for the second half of the animation. default is 0.5
     currently supported Animations :
     1.(requires a previously created circle layer)
     start .circle
     end: .exit
     2.(requires a circle layer and a twoLine shape)
     start: .exit || .plus
     end: .circle
     
     public func animate(to shape: SVNStandardShape, startDuration: Double = 0.5, endDuration: Double = 0.5){
     switch (self.currentShape, shape) {
     //Animate to exit
     case (SVNStandardShape.circle, SVNStandardShape.exit):
     self.animateCircleFill(withColor: .white, duration: startDuration, withBlock: {
     self.createTwoLines(with: shape, strokeColor: .white, fillColor: .clear)
     self.animateCircleFill(withColor: .red, duration: endDuration, withBlock: nil)
     })
     //Animate to circle
     case (SVNStandardShape.exit, SVNStandardShape.circle):
     self.animateExit(withColor: .white, duration: startDuration, withBlock: {
     guard let firstLineLayer = self.customLayers?[LayerType.firstLine],
     let secondLineLayer = self.customLayers?[LayerType.secondLine] else { fatalError(ErrorType.nonInstanciatedLayer.description) }
     firstLineLayer.removeFromSuperlayer()
     secondLineLayer.removeFromSuperlayer()
     self.animateCircleFill(withColor: .clear, duration: endDuration, withBlock: nil)
     })
     case (SVNStandardShape.circle, SVNStandardShape.oval):
     self.animateCircleToOval(withBlock: {
     print("finished")
     })
     
     default:
     fatalError(ErrorType.notSupportedAnimation.description)
     }
     }
     */
    
    
    /*
     public func animateCircleFill(withColor color: UIColor, duration: Double, withBlock block: (() -> Void)?) {
     guard let circleLayer = customLayers?[LayerType.circle] else { fatalError(ErrorType.nonInstanciatedLayer.description) }
     CATransaction.begin()
     let fillAnimation = CABasicAnimation(keyPath: "fillColor")
     fillAnimation.duration = duration
     fillAnimation.toValue = color.cgColor
     fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
     fillAnimation.fillMode = kCAFillModeBoth
     fillAnimation.isRemovedOnCompletion = false
     circleLayer.add(fillAnimation, forKey: fillAnimation.keyPath!)
     CATransaction.setCompletionBlock(block)
     CATransaction.commit()
     }
     
     
     public func animateExit(withColor color: UIColor, duration: Double, withBlock block: (() -> Void)?) {
     guard let firstLineLayer = self.customLayers?[LayerType.firstLine],
     let secondLineLayer = self.customLayers?[LayerType.secondLine] else { fatalError(ErrorType.nonInstanciatedLayer.description) }
     CATransaction.begin()
     let strokeAnimation = CABasicAnimation(keyPath: "strokeColor")
     strokeAnimation.toValue = color.cgColor
     strokeAnimation.duration = duration
     strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
     strokeAnimation.fillMode = kCAFillModeBoth
     strokeAnimation.isRemovedOnCompletion = false
     firstLineLayer.add(strokeAnimation, forKey: strokeAnimation.keyPath!)
     secondLineLayer.add(strokeAnimation, forKey: strokeAnimation.keyPath!)
     CATransaction.setCompletionBlock(block)
     CATransaction.commit()
     }
     */
    
}
