//
//  SVNStandardShapesManager.swift
//  tester
//
//  Created by Aaron Dean Bikis on 4/4/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import UIKit
/**
 A CALayer layout, animating, mutating and updating manager.
    To use this manager pass the CGRect of the the container that you want to add shapes to.
    You can then use on of the various *create* methods to instanciate and add paths to a CALayer instance.
    Once created you can use one of the various *animate* methods to animate and mutate a SVNShapeMetaData instance and shapes therein.
 */
public final class SVNShapesManager : NSObject {
    
    private  enum LayerType {
        case circle, oval, firstLine, secondLine, checkMark
    }
    
    private enum ErrorType {
        case nonInstanciatedLayer
        case notSupportedAnimation
        case unSupportedLayer
        case unsupportedLocation
        case notTwoShapes
        
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
            case .notTwoShapes:
                return "The SVNShape passed is not a two line shape."
                
            }
        }
    }
    
    public var container: CGRect
    
    public init(container: CGRect){
        self.container = container
    }
    
    //MARK: Constructors
    /**
     Using the *container: CGRect* passed to the SVNShapesManager on init this method will return a square of the 9x9 grid.
     - returns :
        CGRect
     -important: not all locations are currently supported
    */
    public func fetchRect(for location: SVNShapeLocation, with padding: CGPoint, and size: CGSize) -> CGRect{
        switch location {
        case .topLeft:
            return CGRect(x: padding.x, y: padding.y, width: size.width, height: size.height)
            
        case .topMid:
            return CGRect(x: ((self.container.size.width - size.width) / 2) + padding.x, y: padding.y, width: size.width, height: size.height)
            
        case .botMid:
            return CGRect(x: (self.container.width - size.width) / 2, y: self.container.height - (size.height + padding.y), width: size.width, height: size.height)
            
        case .botRight:
            return CGRect(x: (self.container.width - size.width) - padding.x, y: self.container.height - (size.height + padding.y), width: size.width, height: size.height)
            
        case .botLeft:
            return CGRect(x: padding.x, y: self.container.height - (size.height + padding.y), width: size.width, height: size.height)
            
        case .midRight:
            return CGRect(x: padding.x, y: (self.container.height / 2) - padding.y, width: size.width, height: size.height)
            
        default:
            fatalError(ErrorType.unsupportedLocation.description)
        }
    }
    /**
     A helper function for
     - *fetchRect(SVNShapeLocation, CGPoint, CGSize) -> CGRect*
     */
    public func fetchRect(with meta: SVNShapeMetaData) -> CGRect {
        return fetchRect(for: meta.location, with: meta.padding, and: meta.size)
    }
    
    
    //MARK: Shape Factory
    /**
     Creates a Circle Layer
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
     Creates a checkmark Layer
    */
    public func createCheckMark(with meta: SVNShapeMetaData) -> CAShapeLayer {
        let checkMarkLayer = CAShapeLayer()
        let checkMarkPath = UIBezierPath()
        
        checkMarkLayer.strokeColor = meta.stroke
        checkMarkLayer.fillColor = meta.fill
        checkMarkLayer.lineWidth = meta.strokeWidth
        let rect = fetchRect(with: meta)
        
        let middle = max(rect.size.width, rect.size.height) * 0.5
        
        checkMarkPath.move(to: CGPoint(x: middle / 2, y: middle))
        
        checkMarkPath.addLine(to: CGPoint(x: middle, y: rect.size.height - middle/2))
        
        checkMarkPath.addLine(to: CGPoint(x: rect.size.width - middle/2, y: middle / 2))
        checkMarkLayer.path = checkMarkPath.cgPath
        
        return checkMarkLayer
    }
    
    
    /**
     Creates a two line shape
     - important: Currently only supports types .exit and .plus
     - parameters:
     - meta: SVNShapeMetaData
     - shape: SVNShape
     */
    public func createTwoLines(with meta: SVNShapeMetaData, shapeToCreate shape: SVNShape) -> [CAShapeLayer] {
        let rect = self.fetchRect(with: meta)
        
        let mid = min(rect.size.width, rect.size.height) * 0.5
        
        let plus = [CGPoint(x: rect.origin.x + mid / 2, y: rect.origin.y + mid),
                    CGPoint(x: rect.origin.x + rect.size.width - mid / 2, y: rect.origin.y + mid),
                    CGPoint(x: rect.origin.x + mid, y: rect.origin.y + mid / 2),
                    CGPoint(x: rect.origin.x + mid, y: rect.origin.y + rect.size.height - mid / 2)]
        
        let exit = [CGPoint(x: rect.origin.x + mid / 2, y: rect.origin.y + mid / 2),
                    CGPoint(x: rect.origin.x + rect.size.width - mid / 2, y: rect.origin.y + rect.size.height - mid / 2),
                    CGPoint(x: rect.origin.x + mid / 2, y: rect.origin.y + rect.size.height - mid / 2),
                    CGPoint(x: rect.origin.x + rect.size.width - mid / 2, y: rect.origin.y + mid / 2)]
        
        var points :[CGPoint]!
        
        switch shape {
        case .exit:
            points = exit
        case .plus:
            points = plus
        default:
            break
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
    
    
 
    //MARK: Animations
    /**
     Animates a circle shape to have the path of a horizontal oval
     */
    public func animateToOval(with meta: SVNShapeMetaData, in duration: Double, withNewLocation location: SVNShapeLocation?, withBlock block: (() -> Void)?) {
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
    
    public func animate(to location: SVNShapeLocation, meta: SVNShapeMetaData, withBlock block: (() -> Void)?) {
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
     
     public func animate(to shape: SVNShape, startDuration: Double = 0.5, endDuration: Double = 0.5){
     switch (self.currentShape, shape) {
     //Animate to exit
     case (SVNShape.circle, SVNShape.exit):
     self.animateCircleFill(withColor: .white, duration: startDuration, withBlock: {
     self.createTwoLines(with: shape, strokeColor: .white, fillColor: .clear)
     self.animateCircleFill(withColor: .red, duration: endDuration, withBlock: nil)
     })
     //Animate to circle
     case (SVNShape.exit, SVNShape.circle):
     self.animateExit(withColor: .white, duration: startDuration, withBlock: {
     guard let firstLineLayer = self.customLayers?[LayerType.firstLine],
     let secondLineLayer = self.customLayers?[LayerType.secondLine] else { fatalError(ErrorType.nonInstanciatedLayer.description) }
     firstLineLayer.removeFromSuperlayer()
     secondLineLayer.removeFromSuperlayer()
     self.animateCircleFill(withColor: .clear, duration: endDuration, withBlock: nil)
     })
     case (SVNShape.circle, SVNShape.oval):
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
