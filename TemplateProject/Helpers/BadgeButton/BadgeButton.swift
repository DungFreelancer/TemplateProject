//
//  BadgeButton.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/23/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class BadgeButton: UIButton {
    
    var badgeLabel = UILabel()
    
    var badge: Int? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    
    public var badgeBackgroundColor: UIColor = .blue {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBadgeToButon(badge: nil)
    }
    
    func addBadgeToButon(badge: Int?) {
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size
        
        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)
        
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != nil ? false : true
        guard let badge = badge else { return }
        switch badge {
        case 0:
            badgeLabel.isHidden = true
        case 1...9:
            badgeLabel.font = UIFont.systemFont(ofSize: 12)
            badgeLabel.text = String(badge)
        case 10...99:
            badgeLabel.font = UIFont.systemFont(ofSize: 12)
            badgeLabel.text = String(badge)
        default:
            badgeLabel.font = UIFont.systemFont(ofSize: 12)
            badgeLabel.text = "99+"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addBadgeToButon(badge: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBadgeToButon(badge: badge)
    }
}
