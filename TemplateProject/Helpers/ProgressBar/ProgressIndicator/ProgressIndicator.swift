//
//  ProgressIndicator.swift
//  LiveLife
//
//  Created by Tran Gia Huy on 11/2/18.
//  Copyright © 2018 DTT. All rights reserved.
//

import UIKit

class ProgressIndicator: UIView {
	
	
	// MARK : - IBOutlets
	
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var progressView: UIProgressView! {
		didSet {
			progressView.setProgress(0, animated: true)
		}
	}
	@IBOutlet weak var backgroundView: UIView!
	// MARK : - Properties
	
	private var animationDuration: TimeInterval = 0
	
	// MARK : - Life cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		Bundle.main.loadNibNamed("ProgressIndicator", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func configure(with progressColor: UIColor, and taskColor: UIColor, forDuration duration: TimeInterval) {
		animationDuration = duration
		progressView.progressTintColor = progressColor
		progressView.trackTintColor = taskColor
		progressView.transform = CGAffineTransform(scaleX: 1, y: 1)
		backgroundView.backgroundColor = progressColor
	}
	
}


// MARK : - Behviour
extension ProgressIndicator {
	
	/// Start the timer/ animation of the progress indicator
	func start() {
		UIView.animate(withDuration: animationDuration) { [progressView] in
			progressView?.setProgress(1, animated: true)
		}
	}
	
	func done() {
		progressView.isHidden = true
	}
	
	func reset() {
		progressView.isHidden = false
		progressView.setProgress(0, animated: false)
		progressView.layoutIfNeeded()
	}
}
