//
//  IndicatorStack.swift
//  LiveLife
//
//  Created by Tran Gia Huy on 11/2/18.
//  Copyright © 2018 dtt. All rights reserved.
//

import UIKit

class IndicatorStack: UIView {
    
    @IBOutlet weak var indicatorStackView: UIStackView!
    @IBOutlet var contentView: UIView!
    
    private var progressColor: UIColor = .black
    private var taskColor: UIColor = .white
    private var animationDuration: TimeInterval = 1
    private var numberOfItems: Int = 0
    var items: [ProgressIndicator] = []
    private var currentItemIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IndicatorStack", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configure(progressColor: UIColor, taskColor: UIColor, animationDuration: TimeInterval, numberOfItems: Int) {
        self.progressColor = progressColor
        self.taskColor = taskColor
        self.animationDuration = animationDuration
        print("this is index number of items",numberOfItems)
        self.numberOfItems = numberOfItems
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension IndicatorStack {
    func setupLayout() {
        guard numberOfItems > 0 else {return}
        indicatorStackView.subviews.forEach { $0.removeFromSuperview()}
        items.removeAll()
        for _ in 0...(numberOfItems - 1) {
            // Create item
            let width: CGFloat = (indicatorStackView.frame.width / CGFloat(numberOfItems)) - 10
            let indicator = ProgressIndicator(frame: CGRect(x: 0, y: 0, width: width, height: indicatorStackView.frame.height))
            indicator.configure(with: progressColor, and: taskColor, forDuration: animationDuration)
            indicatorStackView.addArrangedSubview(indicator)
            items.append(indicator)
        }
    }
}

extension IndicatorStack {
    func changeCurrentItem(to index: Int) {
        guard index < items.count else {return}
        currentItemIndex = index
        items.enumerated().forEach {
            if $0.offset == index {
                $0.element.reset()
                $0.element.start()
            }else if $0.offset > index {
                $0.element.reset()
            }else if $0.offset < index {
                $0.element.done()
            }
        }
    }
}
