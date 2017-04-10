//
//  SVNLargeButton.swift
//  SVNLargeButton
//
//  Created by Aaron Dean Bikis on 4/7/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import UIKit

public class SVNLargeButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = false
        self.layer.borderWidth = 1.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 12.0, height: 12.0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class is not set up to be instaciated with coder use init(frame) instead")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentEdgeInsets = UIEdgeInsetsMake(1.0, 1.0, -1.0, -1.0)
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 0.8
        super.touchesBegan(touches, with: event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            self.layer.shadowOpacity = 0.5
            super.touchesBegan(touches, with: event)
    }
}
