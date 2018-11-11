//
//  TCImageCropperViewController.swift
//  Jobbird
//
//  Created by Tiziano Coroneo on 30/05/2018.
//  Copyright © 2018 DTT Multimedia. All rights reserved.
//

import UIKit

let kResetAnimationDuration: TimeInterval = 0.4
let kLayoutImageScrollViewAnimationDuration: TimeInterval = 0.25

protocol TCImageCropViewControllerDelegate: class {
    func imageCropViewControllerDidCancelCrop(_ controller: TCImageCropViewController)

    func imageCropViewController(
        _ controller: TCImageCropViewController,
        didCropImage croppedImage: UIImage,
        usingCropRect cropRect: CGRect,
        rotationAngle: CGFloat)

    func imageCropViewController(
        _ controller: TCImageCropViewController,
        willCropImage originalImage: UIImage)
}

extension TCImageCropViewControllerDelegate {
    func imageCropViewController(
        _ controller: TCImageCropViewController,
        willCropImage originalImage: UIImage) {}
}

protocol TCImageCropViewControllerDataSource: class {
    func imageCropViewControllerCustomMaskRect(_ controller: TCImageCropViewController) -> CGRect
    func imageCropViewControllerCustomMaskPath(_ controller: TCImageCropViewController) -> UIBezierPath
    func imageCropViewControllerCustomMovementRect(_ controller: TCImageCropViewController) -> CGRect
}


class TCImageCropViewController: UIViewController {

    /**
     Types of supported crop modes.
     */
    enum CropMode {
        case circle
        case square
        case custom
    }

    weak var delegate: TCImageCropViewControllerDelegate?
    weak var dataSource: TCImageCropViewControllerDataSource?

    var originalImage: UIImage {
        didSet {
            if let view = viewIfLoaded,
                let _ = view.window {
                self.displayImage()
            }
        }
    }

    var maskLayerColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    var maskLayerLineWidth: CGFloat = 1
    var maskLayerStrokeColor: UIColor?

    private(set) var maskRect: CGRect = .zero
    private(set) var maskPath = UIBezierPath() {
        didSet {
            let clipPath = UIBezierPath(rect: self.rectForClipPath)
            clipPath.append(maskPath)
            clipPath.usesEvenOddFillRule = true

            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = CATransaction.animationDuration()
            animation.timingFunction = CATransaction.animationTimingFunction()
            self.maskLayer.add(animation, forKey: "path")

            self.maskLayer.path = clipPath.cgPath
        }
    }

    var cropMode: CropMode = .circle {
        didSet {
            if let _ = self.imageScrollView.zoomView {
                self.reset(false)
            }
        }
    }

    var avoidEmptySpaceAroundImage = false {
        didSet { self.imageScrollView.aspectFill = avoidEmptySpaceAroundImage }
    }

    var alwaysBounceVertical = false {
        didSet {
            self.imageScrollView.alwaysBounceVertical = alwaysBounceVertical
        }
    }

    var alwaysBounceHorizontal = false {
        didSet {
            self.imageScrollView.alwaysBounceHorizontal = alwaysBounceHorizontal
        }
    }

    var applyMaskToCroppedImage = false

    @IBOutlet var moveAndScaleLabel: UILabel! {
        didSet {
            moveAndScaleLabel.translatesAutoresizingMaskIntoConstraints = false
            moveAndScaleLabel.backgroundColor = .clear
            moveAndScaleLabel.text = NSLocalizedString("CROP PICTURE", comment: "")
            moveAndScaleLabel.font = UIFont.systemFont(ofSize: 15)
            moveAndScaleLabel.textColor = .white
            moveAndScaleLabel.isOpaque = false
        }
    }

    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.setTitle(NSLocalizedString("CANCEL", comment: ""),
                                  for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            cancelButton.addTarget(self, action: #selector(onCancelButtonTouch), for: .touchUpInside)
            cancelButton.isOpaque = false
        }
    }

    @IBOutlet var chooseButton: UIButton! {
        didSet {
            chooseButton.translatesAutoresizingMaskIntoConstraints = false
            chooseButton.setTitle(NSLocalizedString("DONE", comment: ""),
                                  for: .normal)
            chooseButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            chooseButton.addTarget(self, action: #selector(onChooseButtonTouch), for: .touchUpInside)
            chooseButton.isOpaque = false
        }
    }

    var rotationEnabled: Bool = false {
        didSet {
            self.rotationGestureRecognizer.isEnabled = rotationEnabled
        }
    }

    var isPortraitInterfaceOrientation: Bool {
        return self.view.bounds.height > self.view.bounds.width
    }

    var portraitCircleMaskRectInnerEdgeInset: CGFloat = 15
    var portraitSquareMaskRectInnerEdgeInset: CGFloat = 20
    var portraitMoveAndScaleLabelTopAndCropViewTopVerticalSpace: CGFloat = 64
    var portraitCropViewBottomAndCancelButtonBottomVerticalSpace: CGFloat = 20
    var portraitCropViewBottomAndChooseButtonBottomVerticalSpace: CGFloat = 20
    var portraitCancelButtonLeadingAndCropViewLeadingHorizontalSpace: CGFloat = 13
    var portraitCropViewTrailingAndChooseButtonTrailingHorizontalSpace: CGFloat = 13

    var landscapeCircleMaskRectInnerEdgeInset: CGFloat = 45
    var landscapeSquareMaskRectInnerEdgeInset: CGFloat = 45
    var landscapeMoveAndScaleLabelTopAndCropViewTopVerticalSpace: CGFloat = 12
    var landscapeCropViewBottomAndCancelButtonBottomVerticalSpace: CGFloat = 12
    var landscapeCropViewBottomAndChooseButtonBottomVerticalSpace: CGFloat = 12
    var landscapeCancelButtonLeadingAndCropViewLeadingHorizontalSpace: CGFloat = 13
    var landscapeCropViewTrailingAndChooseButtonTrailingHorizontalSpace: CGFloat = 13

    var originalNavigationControllerNavigationBarHidden: Bool = false
    var originalNavigationControllerNavigationBarShadowImage: UIImage?
    var originalNavigationControllerViewBackgroundColor: UIColor?
    var originalStatusBarHidden: Bool = false

    lazy var imageScrollView: TCImageScrollView = {
        let scrollView = TCImageScrollView()
        scrollView.clipsToBounds = false
        scrollView.aspectFill = self.avoidEmptySpaceAroundImage
        scrollView.alwaysBounceHorizontal = self.alwaysBounceHorizontal
        scrollView.alwaysBounceVertical = self.alwaysBounceVertical
        return scrollView
    }()

    lazy var overlayView: TCTouchView = {
        let view = TCTouchView()
        view.receiver = self.imageScrollView
        view.layer.addSublayer(self.maskLayer)
        return view
    }()

    lazy var maskLayer: CAShapeLayer = {
        let mask = CAShapeLayer()
        mask.fillRule = kCAFillRuleEvenOdd
        mask.fillColor = self.maskLayerColor.cgColor
        mask.lineWidth = self.maskLayerLineWidth
        mask.strokeColor = self.maskLayerStrokeColor?.cgColor
        return mask
    }()

    lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))

        gesture.numberOfTapsRequired = 2
        gesture.delaysTouchesEnded = false
        gesture.delegate = self

        return gesture
    }()

    lazy var rotationGestureRecognizer: UIRotationGestureRecognizer = {
        let gesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))

        gesture.delaysTouchesEnded = false
        gesture.delegate = self
        gesture.isEnabled = self.rotationEnabled

        return gesture
    }()

    private var cropRect: CGRect {
        var cropRect = CGRect.zero

        let zoomScale = 1.0/self.imageScrollView.zoomScale

        cropRect.origin.x = floor(self.imageScrollView.contentOffset.x * zoomScale)
        cropRect.origin.y = floor(self.imageScrollView.contentOffset.y * zoomScale)
        cropRect.size.width = self.imageScrollView.bounds.width * zoomScale
        cropRect.size.height = self.imageScrollView.bounds.height * zoomScale

        let width = cropRect.width
        let height = cropRect.height
        let ceilWidth = ceil(width)
        let ceilHeight = ceil(height)

        if abs(ceilWidth - width) < CGFloat.leastNormalMagnitude
            || abs(ceilHeight - height) < CGFloat.leastNormalMagnitude {
            cropRect.size.width = ceilWidth
            cropRect.size.height = ceilHeight
        } else {
            cropRect.size.width = width
            cropRect.size.height = height
        }

        return cropRect
    }

    private var rectForClipPath: CGRect {
        if self.maskLayerStrokeColor == nil {
            return self.overlayView.frame
        } else {
            let maskLayerLineHalfWidth = self.maskLayerLineWidth / 2
            return self.overlayView.frame.insetBy(
                dx: -maskLayerLineHalfWidth,
                dy: -maskLayerLineHalfWidth)
        }
    }

    private var rectForMaskPath: CGRect {
        if self.maskLayerStrokeColor == nil {
            return self.maskRect
        } else {
            let maskLayerLineHalfWidth = self.maskLayerLineWidth / 2
            return self.maskRect.insetBy(
                dx: -maskLayerLineHalfWidth,
                dy: -maskLayerLineHalfWidth)
        }
    }

    private var rotationAngle: CGFloat {
        get {
            let transform = self.imageScrollView.transform
            return atan2(transform.b, transform.a)
        } set {
            let rotation = newValue - self.rotationAngle
            self.imageScrollView.transform = imageScrollView
                .transform.rotated(by: rotation)
        }
    }

    private var zoomScale: CGFloat {
        get { return self.imageScrollView.zoomScale }
        set { self.imageScrollView.zoomScale = newValue }
    }

    @IBOutlet var cancelButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var chooseButtonTrailingConstraint: NSLayoutConstraint!

    // MARK: Lifecycle

    /**
     Designated initializer. Initializes and returns a newly allocated view controller object with the specified image.

     @param originalImage The image for cropping.
     */
    init(withImage originalImage: UIImage) {
        self.originalImage = originalImage
        super.init(nibName: nil, bundle: nil)
    }

    /**
     Initializes and returns a newly allocated view controller object with the specified image and the specified crop mode.

     @param originalImage The image for cropping.
     @param cropMode The mode for cropping.
     */
    convenience init(withImage originalImage: UIImage, cropMode: CropMode) {
        self.init(withImage: originalImage)
        self.cropMode = cropMode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)

        if #available(iOS 11.0, *) {
            self.imageScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.view.backgroundColor = .black
        self.view.clipsToBounds = true

        self.view.addSubview(self.imageScrollView)
        self.view.addSubview(self.overlayView)
        self.view.addSubview(self.moveAndScaleLabel)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.chooseButton)

        self.view.addGestureRecognizer(self.doubleTapGestureRecognizer)
        self.view.addGestureRecognizer(self.rotationGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !self.responds(to: #selector(getter: prefersStatusBarHidden)) {
            let shouldHide = UIApplication.shared.isStatusBarHidden
            self.originalStatusBarHidden = shouldHide
            UIApplication.shared.isStatusBarHidden = true
        }

        self.originalNavigationControllerNavigationBarHidden = self.navigationController?.isNavigationBarHidden ?? false

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        self.originalNavigationControllerNavigationBarShadowImage = self.navigationController?.navigationBar.shadowImage
        self.navigationController?.navigationBar.shadowImage = nil
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.originalNavigationControllerViewBackgroundColor = self.navigationController?.view.backgroundColor
        self.navigationController?.view.backgroundColor = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if !self.responds(to: #selector(getter: prefersStatusBarHidden)) {
            UIApplication.shared.isStatusBarHidden = self.originalStatusBarHidden
        }

        self.navigationController?.setNavigationBarHidden(
            self.originalNavigationControllerNavigationBarHidden,
            animated: animated)
        self.navigationController?.navigationBar.shadowImage = self.originalNavigationControllerNavigationBarShadowImage
        self.navigationController?.view.backgroundColor = self.originalNavigationControllerViewBackgroundColor
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        updateMaskRect()
        layoutImageScrollView()
        layoutOverlayView()
        updateMaskPath()

        self.view.setNeedsUpdateConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.imageScrollView.zoomView == nil {
            self.displayImage()
        }
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        if self.isPortraitInterfaceOrientation {
            self.chooseButtonTrailingConstraint.constant = self.portraitCropViewTrailingAndChooseButtonTrailingHorizontalSpace
        } else {
            self.cancelButtonLeadingConstraint.constant = self.landscapeCancelButtonLeadingAndCropViewLeadingHorizontalSpace
           
            self.chooseButtonTrailingConstraint.constant = self.landscapeCropViewTrailingAndChooseButtonTrailingHorizontalSpace
        }
    }

    @objc func handleDoubleTap() {
        self.reset(true)
    }

    @objc func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        self.rotationAngle = self.rotationAngle + gestureRecognizer.rotation
        gestureRecognizer.rotation = 0

        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: kLayoutImageScrollViewAnimationDuration) {
                self.layoutImageScrollView()
            }
        }
    }

    @objc func onCancelButtonTouch() {
        cancelCrop()
    }

    @objc func onChooseButtonTouch() {
        cropImage()
    }

    private func layoutImageScrollView() {
        var frame = CGRect.zero

        switch self.cropMode {
        case .square:
            if self.rotationAngle == 0 {
                frame = self.maskRect
            } else {
                // Step 1: Rotate the left edge of the initial rect of the image scroll view clockwise around the center by `rotationAngle`.
                let initialRect = self.maskRect
                let rotationAngle = self.rotationAngle

                let leftTopPoint = initialRect.origin
                let leftBottomPoint = CGPoint(
                    x: initialRect.origin.x,
                    y: initialRect.origin.y + initialRect.size.height)

                let leftLineSegment = TCLineSegment(
                    start: leftTopPoint,
                    end: leftBottomPoint)

                let pivot = initialRect.centerPoint

                var alpha = abs(rotationAngle)

                let rotatedLeftLineSegment = leftLineSegment
                    .rotateAround(pivot: pivot, angle: alpha)

                // Step 2: Find the points of intersection of the rotated edge with the initial rect.
                let points = intersectionPoints(
                    ofLineSegment: rotatedLeftLineSegment,
                    withRect: initialRect)

                // Step 3: If the number of intersection points more than one
                // then the bounds of the rotated image scroll view does not completely fill the mask area.
                // Therefore, we need to update the frame of the image scroll view.
                // Otherwise, we can use the initial rect.
                if points.count > 1 {
                    // We have a right triangle.

                    // Step 4: Calculate the altitude of the right triangle.
                    if alpha > CGFloat.pi/2, alpha < CGFloat.pi {
                        alpha = alpha - CGFloat.pi/2
                    } else if alpha > CGFloat.pi * 3/2, alpha < CGFloat.pi * 2 {
                        alpha = alpha - CGFloat.pi * 3/2
                    }

                    let sinAlpha = sin(alpha)
                    let cosAlpha = cos(alpha)

                    let hypotenuse = points[0].distance(from: points[1])

                    let altitude = hypotenuse * sinAlpha * cosAlpha

                    // Step 5: Calculate the target width.
                    let initialWidth = initialRect.width
                    let targetWidth = initialWidth + altitude * 2

                    // Step 6: Calculate the target frame.
                    let scale = targetWidth / initialWidth
                    let center = initialRect.centerPoint
                    frame = initialRect.scale(around: center, sx: scale, sy: scale)

                    // Step 7: Avoid floats.
                    frame.origin.x = floor(frame.minX)
                    frame.origin.y = floor(frame.minY)
                    frame = frame.integral
                } else {
                    // Step 4: Use the initial rect.
                    frame = initialRect
                }
            }
        case .circle:
            frame = self.maskRect

        case .custom:
            frame = self.dataSource?
                .imageCropViewControllerCustomMovementRect(self) ?? self.maskRect
        }

        let transform = self.imageScrollView.transform
        self.imageScrollView.transform = CGAffineTransform.identity
        self.imageScrollView.frame = frame
        self.imageScrollView.transform = transform
    }

    private func layoutOverlayView() {
        let frame = CGRect.init(
            x: 0,
            y: 0,
            width: self.view.bounds.width * 2,
            height: self.view.bounds.height * 2)
        self.overlayView.frame = frame
    }


    private func updateMaskRect() {
        let viewWidth = self.view.bounds.width
        let viewHeight = self.view.bounds.height

        switch self.cropMode {
        case .circle:

            let diameter: CGFloat

            if isPortraitInterfaceOrientation {
                diameter = min(viewWidth, viewHeight) - self.portraitCircleMaskRectInnerEdgeInset * 2
            } else {
                diameter = min(viewWidth, viewHeight) - self.landscapeCircleMaskRectInnerEdgeInset * 2
            }

            let maskSize = CGSize(width: diameter, height: diameter)

            self.maskRect = CGRect.init(
                x: (viewWidth - maskSize.width)/2,
                y: (viewHeight - maskSize.height)/2,
                width: maskSize.width,
                height: maskSize.height)

        case .square:

            let lenght: CGFloat

            if isPortraitInterfaceOrientation {
                lenght = min(viewWidth, viewHeight) - self.portraitSquareMaskRectInnerEdgeInset * 2
            } else {
                lenght = min(viewWidth, viewHeight) - self.landscapeSquareMaskRectInnerEdgeInset * 2
            }

            let maskSize = CGSize(width: lenght, height: lenght)

            self.maskRect = CGRect(
                x: (viewWidth - maskSize.width)/2,
                y: (viewHeight - maskSize.height)/2,
                width: maskSize.width,
                height: maskSize.height)

        case .custom:
            self.maskRect = self.dataSource?
                .imageCropViewControllerCustomMaskRect(self) ?? .zero
        }
    }

    private func updateMaskPath() {
        switch self.cropMode {
        case .circle:
            self.maskPath = UIBezierPath(ovalIn: self.rectForMaskPath)
        case .square:
            self.maskPath = UIBezierPath.init(rect: self.rectForMaskPath)
        case .custom:
            self.maskPath = self.dataSource?
                .imageCropViewControllerCustomMaskPath(self)
                ?? UIBezierPath.init(rect: self.rectForMaskPath)
        }
    }

    private func displayImage() {
        self.imageScrollView.displayImage(originalImage)
        self.reset(false)
    }

    private func croppedImage(
        _ image: UIImage,
        cropRect: CGRect,
        scale imageScale: CGFloat,
        orientation: UIImageOrientation) -> UIImage {

        if image.images == nil {
            guard let croppedCGImage = image.cgImage?.cropping(to: cropRect)
                else { return image }

            return UIImage(
                cgImage: croppedCGImage,
                scale: imageScale,
                orientation: orientation)
        } else {
            guard let animatedImages = image.images else { return image }
            let croppedAnimatedImages = animatedImages.map {
                return self.croppedImage(
                    $0,
                    cropRect: cropRect,
                    scale: imageScale,
                    orientation: orientation)
            }

            return UIImage.animatedImage(
                with: croppedAnimatedImages,
                duration: image.duration) ?? image
        }
    }

    func croppedImage(
        _ image: UIImage,
        cropMode: CropMode,
        cropRect: CGRect,
        rotationAngle: CGFloat,
        zoomScale: CGFloat,
        maskPath: UIBezierPath,
        applyMaskToCroppedImage: Bool) -> UIImage {

        // Step 1: check and correct the crop rect.
        var cropRect = cropRect
        let imageSize = image.size

        let x = cropRect.minX
        let y = cropRect.minY
        let width = cropRect.width
        let height = cropRect.height

        var imageOrientation = image.imageOrientation

        if imageOrientation == .right || imageOrientation == .rightMirrored {
            cropRect.origin.x = y
            cropRect.origin.y = floor(imageSize.width - cropRect.width - x)
            cropRect.size.width = height
            cropRect.size.height = width
        } else if imageOrientation == .left || imageOrientation == .leftMirrored {
            cropRect.origin.x = floor(imageSize.height - cropRect.height - y)
            cropRect.origin.y = x
            cropRect.size.width = height
            cropRect.size.height = width
        } else if imageOrientation == .down || imageOrientation == .downMirrored {
            cropRect.origin.x = floor(imageSize.width - cropRect.width - x)
            cropRect.origin.y = floor(imageSize.height - cropRect.height - y)
        }

        let imageScale = image.scale
        cropRect = cropRect.applying(CGAffineTransform(
            scaleX: imageScale,
            y: imageScale))

        // Step 2: create an image using the data contained within the specified rect.
        var croppedImage = self.croppedImage(
            image,
            cropRect: cropRect,
            scale: imageScale,
            orientation: imageOrientation)

        // Step 3: fix orientation of the cropped image.
        croppedImage = croppedImage.fixOrientation()
        imageOrientation = croppedImage.imageOrientation

        // Step 4: If current mode is `RSKImageCropModeSquare` and the image is not rotated
        // or mask should not be applied to the image after cropping and the image is not rotated,
        // we can return the cropped image immediately.
        // Otherwise, we must further process the image.
        if cropMode == .square || !applyMaskToCroppedImage,
            rotationAngle == 0 {
            // Step 5: return the cropped image immediately.
            return croppedImage
        } else {
            // Step 5: create a new context.
            let contextSize = cropRect.size
            UIGraphicsBeginImageContextWithOptions(contextSize, false, imageScale)

            // Step 6: apply the mask if needed.
            if applyMaskToCroppedImage {
                // 6a: scale the mask to the size of the crop rect.
                let maskPathCopy = maskPath.copy() as! UIBezierPath
                let scale: CGFloat = 1.0 / zoomScale

                maskPathCopy.apply(CGAffineTransform(
                    scaleX: scale,
                    y: scale))

                // 6b: move the mask to the top-left.
                let translation = CGPoint.init(
                    x: -maskPathCopy.bounds.minX,
                    y: -maskPathCopy.bounds.minY)

                maskPathCopy.apply(CGAffineTransform(
                    translationX: translation.x,
                    y: translation.y))

                // 6c: apply the mask.
                maskPathCopy.addClip()
            }

            // Step 7: rotate the cropped image if needed.
            if rotationAngle != 0 {
                croppedImage = croppedImage.rotate(by: rotationAngle)
            }

            // Step 8: draw the cropped image.
            let point = CGPoint(
                x: floor(contextSize.width - croppedImage.size.width)/2,
                y: floor(contextSize.height - croppedImage.size.height)/2)
            croppedImage.draw(at: point)

            // Step 9: get the cropped image affter processing from the context.
            croppedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image

            // Step 10: remove the context.
            UIGraphicsEndImageContext()

            guard let cgImage = croppedImage.cgImage else { return image }

            croppedImage = UIImage(
                cgImage: cgImage,
                scale: imageScale,
                orientation: imageOrientation)

            // Step 11: return the cropped image after processing.
            return croppedImage
        }

    }

    private func cropImage() {

        self.delegate?.imageCropViewController(
            self,
            willCropImage: self.originalImage)

        let zoomScale = imageScrollView.zoomScale

        DispatchQueue.global().async {
            [originalImage, cropMode, cropRect, rotationAngle, maskPath, applyMaskToCroppedImage] in

            let croppedImage = self.croppedImage(
                originalImage,
                cropMode: cropMode,
                cropRect: cropRect,
                rotationAngle: rotationAngle,
                zoomScale: zoomScale,
                maskPath: maskPath,
                applyMaskToCroppedImage: applyMaskToCroppedImage)

            DispatchQueue.main.async {
                self.delegate?.imageCropViewController(
                    self,
                    didCropImage: croppedImage,
                    usingCropRect: cropRect,
                    rotationAngle: rotationAngle)
            }
        }

    }

    private func cancelCrop() {
        self.delegate?.imageCropViewControllerDidCancelCrop(self)
    }

    private func reset(_ animated: Bool) {
        if animated {
            UIView.beginAnimations("tc_reset", context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(kResetAnimationDuration)
            UIView.setAnimationBeginsFromCurrentState(true)
        }

        self.resetRotation()
        self.resetFrame()
        self.resetZoomScale()
        self.resetContentOffset()

        if animated {
            UIView.commitAnimations()
        }
    }

    private func resetRotation() {
        self.rotationAngle = 0
    }

    private func resetFrame() {
        self.layoutImageScrollView()
    }

    private func resetZoomScale() {
        let zoomScale: CGFloat

        if !isPortraitInterfaceOrientation {
            zoomScale = self.view.bounds.height / self.originalImage.size.height
        } else {
            zoomScale = self.view.bounds.width / self.originalImage.size.width
        }

        self.imageScrollView.zoomScale = zoomScale
    }

    private func resetContentOffset() {
        let boundsSize = self.imageScrollView.bounds.size;
        guard let frameToCenter = self.imageScrollView.zoomView?.frame else { return }

        var contentOffset = CGPoint.zero

        if frameToCenter.width > boundsSize.width {
            contentOffset.x = (frameToCenter.width - boundsSize.width)/2
        }

        if frameToCenter.height > boundsSize.height {
            contentOffset.y = (frameToCenter.height - boundsSize.height)/2
        }

        self.imageScrollView.contentOffset = contentOffset
    }

    func intersectionPoints(
        ofLineSegment lineSegment: TCLineSegment,
        withRect rect: CGRect) -> [CGPoint] {

        let top = TCLineSegment(
            start: CGPoint(x: rect.minX, y: rect.minY),
            end: CGPoint(x: rect.maxX, y: rect.minY))

        let right = TCLineSegment(
            start: CGPoint(x: rect.maxX, y: rect.minY),
            end: CGPoint(x: rect.maxX, y: rect.maxY))

        let bottom = TCLineSegment(
            start: CGPoint(x: rect.minX, y: rect.maxY),
            end: CGPoint(x: rect.maxX, y: rect.maxY))

        let left = TCLineSegment(
            start: CGPoint(x: rect.minX, y: rect.minY),
            end: CGPoint(x: rect.minX, y: rect.maxY))

        let p0 = top.intersect(other: lineSegment)
        let p1 = right.intersect(other: lineSegment)
        let p2 = bottom.intersect(other: lineSegment)
        let p3 = left.intersect(other: lineSegment)

        return [p0, p1, p2, p3].compactMap { $0 }
    }

}

extension TCImageCropViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class TCImageScrollView: UIScrollView {

    var zoomView: UIImageView?
    var aspectFill: Bool = false {
        didSet {
            guard let _ = zoomView else { return }

            self.setMaxMinZoomScalesForCurrentBounds()

            if self.zoomScale < self.minimumZoomScale {
                self.zoomScale = self.minimumZoomScale
            }
        }
    }

    private var imageSize: CGSize = .zero
    private var pointToCenterAfterResize = CGPoint.zero
    private var scaleToRestoreAfterResize: CGFloat = 0

    override var frame: CGRect {
        get { return super.frame }
        set {
            let sizeChanging = newValue.size != self.frame.size

            if sizeChanging { self.prepareToResize() }
            super.frame = newValue
            if sizeChanging { self.recoverFromResizing() }

            self.centerZoomView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bouncesZoom = true
        self.scrollsToTop = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        self.centerZoomView()
    }

    private func centerZoomView() {
        // center zoomView as it becomes smaller than the size of the screen
        // we need to use contentInset instead of contentOffset for better positioning when zoomView fills the screen

        if aspectFill {
            var top: CGFloat = 0
            var left: CGFloat = 0

            if self.contentSize.height < self.bounds.height {
                top = (self.bounds.height - self.contentSize.height)/2
            }

            if self.contentSize.width < self.bounds.width {
                left = (self.bounds.width - self.contentSize.width)/2
            }

            self.contentInset = UIEdgeInsets.init(
                top: top, left: left, bottom: top, right: left)
        } else {
            guard var frameToCenter = self.zoomView?.frame else { return }

            if frameToCenter.width < self.bounds.width {
                frameToCenter.origin.x = (self.bounds.width - frameToCenter.width)/2
            } else { frameToCenter.origin.x = 0 }

            if frameToCenter.height < self.bounds.height {
                frameToCenter.origin.y = (self.bounds.height - frameToCenter.height)/2
            } else { frameToCenter.origin.y = 0 }

            self.zoomView?.frame = frameToCenter
        }
    }

    func displayImage(_ image: UIImage) {
        zoomView?.removeFromSuperview()
        zoomView = nil

        self.zoomScale = 1

        zoomView = UIImageView(image: image)
        self.addSubview(zoomView!)

        self.configure(withImageSize: image.size)
    }

    private func configure(withImageSize imageSize: CGSize) {
        self.imageSize = imageSize
        self.contentSize = imageSize
        self.setMaxMinZoomScalesForCurrentBounds()
        self.setInitialZoomScale()
        self.setInitialContentOffset()
        self.contentInset = .zero
    }

    private func setMaxMinZoomScalesForCurrentBounds() {
        guard imageSize.width != 0,
            imageSize.height != 0
            else {
                self.maximumZoomScale = 1
                self.minimumZoomScale = 1
                return
        }

        let boundsSize = self.bounds.size

        let xScale = boundsSize.width / imageSize.width // the scale needed to perfectly fit the image width-wise
        let yScale = boundsSize.height / imageSize.height // the scale needed to perfectly fit the image height-wise

        var minScale: CGFloat

        if !aspectFill {
            minScale = min(xScale, yScale) // use minimum of these to allow the image to become fully visible
        } else {
            minScale = max(xScale, yScale) // use maximum of these to allow the image to fill the screen
        }

        var maxScale = max(xScale, yScale)

        // Image must fit/fill the screen, even if its size is smaller.
        let xImageScale = maxScale * imageSize.width / boundsSize.width
        let yImageScale = maxScale * imageSize.height / boundsSize.height

        var maxImageScale = max(xImageScale, yImageScale)

        maxImageScale = max(minScale, maxImageScale)
        maxScale = max(maxScale, maxImageScale)

        // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
        if minScale > maxScale {
            minScale = maxScale
        }

        self.maximumZoomScale = maxScale
        self.minimumZoomScale = minScale

    }

    private func setInitialZoomScale() {
        guard imageSize.width != 0,
            imageSize.height != 0
            else {
                self.zoomScale = 1
                return
        }

        let boundsSize = self.bounds.size

        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height

        self.zoomScale = max(xScale, yScale)
    }

    private func setInitialContentOffset() {

        let boundsSize = self.bounds.size
        guard let frameToCenter = self.zoomView?.frame else { return }

        var contentOffset: CGPoint = CGPoint.zero

        if frameToCenter.width > boundsSize.width {
            contentOffset.x = (frameToCenter.width - boundsSize.width)/2
        }

        if frameToCenter.height > boundsSize.height {
            contentOffset.y = (frameToCenter.height - boundsSize.height)/2
        }

        self.setContentOffset(contentOffset, animated: false)
    }

    private func prepareToResize() {
        guard let zoomView = self.zoomView else { return }

        let boundsCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

        self.pointToCenterAfterResize = self.convert(boundsCenter, to: zoomView)
        self.scaleToRestoreAfterResize = self.zoomScale

        if scaleToRestoreAfterResize <= self.minimumZoomScale + .leastNonzeroMagnitude {
            scaleToRestoreAfterResize = 0
        }
    }

    private func recoverFromResizing() {
        guard let zoomView = self.zoomView else { return }

        self.setMaxMinZoomScalesForCurrentBounds()

        // Step 1: restore zoom scale, first making sure it is within the allowable range.
        let maxZoomScale = max(self.minimumZoomScale, scaleToRestoreAfterResize)
        self.zoomScale = min(self.maximumZoomScale, maxZoomScale)

        // Step 2: restore center point, first making sure it is within the allowable range.
        // 2a: convert our desired center point back to our own coordinate space

        let boundsCenter = self.convert(pointToCenterAfterResize, from: zoomView)

        var offset = CGPoint(
            x: boundsCenter.x - self.bounds.size.width/2,
            y: boundsCenter.y - self.bounds.size.height/2)

        let maxOffset = self.maximumContentOffset
        let minOffset = self.minimumContentOffset

        let realMaxXOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxXOffset)

        let realMaxYOffset = min(maxOffset.y, offset.y)
        offset.y = max(minOffset.y, realMaxYOffset)

        self.contentOffset = offset
    }

    private var maximumContentOffset: CGPoint {
        return CGPoint(
            x: self.contentSize.width - self.bounds.size.width,
            y: self.contentSize.height - self.bounds.size.height)
    }

    private var minimumContentOffset: CGPoint {
        return .zero
    }
}

extension TCImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerZoomView()
    }
}

class TCTouchView: UIView {
    weak var receiver: UIView?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard self.point(inside: point, with: event)
            else { return nil }

        return self.receiver
    }
}

extension CGRect {
    var centerPoint: CGPoint {
        return CGPoint(
            x: self.minX + self.width/2,
            y: self.minY + self.height/2)
    }

    func scale(around point: CGPoint, sx: CGFloat, sy: CGFloat) -> CGRect {

        var rect = self

        let translate = CGAffineTransform(
            translationX: -point.x,
            y: -point.y)

        rect = rect.applying(translate)

        let scale = CGAffineTransform(
            scaleX: sx, y: sy)

        rect = rect.applying(scale)

        return rect.applying(translate.inverted())
    }
}

extension CGPoint {

    func rotate(around pivot: CGPoint, angle: CGFloat) -> CGPoint {

        var point = self

        let translate = CGAffineTransform(
            translationX: -pivot.x,
            y: -pivot.y)

        point = point.applying(translate)

        let rotate = CGAffineTransform(rotationAngle: angle)

        point = point.applying(rotate)

        return point.applying(translate.inverted())
    }

    func distance(from point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y

        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
}

struct TCLineSegment {
    let start: CGPoint
    let end: CGPoint

    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }

    func rotateAround(pivot: CGPoint, angle: CGFloat) -> TCLineSegment {
        return TCLineSegment(
            start: self.start.rotate(around: pivot, angle: angle),
            end: self.end.rotate(around: pivot, angle: angle))
    }


    /*
     Equations of line segments:

     pA = ls1.start + uA * (ls1.end - ls1.start)
     pB = ls2.start + uB * (ls2.end - ls2.start)

     In the case when `pA` is equal `pB` we have:

     x1 + uA * (x2 - x1) = x3 + uB * (x4 - x3)
     y1 + uA * (y2 - y1) = y3 + uB * (y4 - y3)

     uA = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3) / (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)
     uB = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3) / (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)

     numeratorA = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)
     denominatorA = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)

     numeratorA = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)
     denominatorB = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)

     [1] Denominators are equal.
     [2] If numerators and denominator are zero, then the line segments are coincident. The point of intersection is the midpoint of the line segment.

     x = (x1 + x2) * 0.5
     y = (y1 + y2) * 0.5

     or

     x = (x3 + x4) * 0.5
     y = (y3 + y4) * 0.5

     [3] If denominator is zero, then the line segments are parallel. There is no point of intersection.
     [4] If `uA` and `uB` is included into the interval [0, 1], then the line segments intersects in the point (x, y).

     x = x1 + uA * (x2 - x1)
     y = y1 + uA * (y2 - y1)

     or

     x = x3 + uB * (x4 - x3)
     y = y3 + uB * (y4 - y3)
     */
    func intersect(other line: TCLineSegment) -> CGPoint? {

        let ls1 = self
        let ls2 = line

        let x1 = ls1.start.x
        let y1 = ls1.start.y
        let x2 = ls1.end.x
        let y2 = ls1.end.y
        let x3 = ls2.start.x
        let y3 = ls2.start.y
        let x4 = ls2.end.x
        let y4 = ls2.end.y

        let numeratorA = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)
        let numeratorB = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)
        let denominator = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)

        // Check the coincidence.
        if fabs(numeratorA) < CGFloat.leastNonzeroMagnitude,
            fabs(numeratorB) < CGFloat.leastNonzeroMagnitude,
            fabs(denominator) < CGFloat.leastNonzeroMagnitude {
            return CGPoint(x: (x1 + x2) * 0.5, y: (y1 + y2) * 0.5)
        }

        // Check the parallelism.
        if fabs(denominator) < CGFloat.leastNonzeroMagnitude {
            return nil;
        }

        // Check the intersection.
        let uA = numeratorA / denominator;
        let uB = numeratorB / denominator;
        if (uA < 0 || uA > 1 || uB < 0 || uB > 1) {
            return nil;
        }

        return CGPoint(x: x1 + uA * (x2 - x1), y: y1 + uA * (y2 - y1));
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        guard self.imageOrientation != .up else { return self }

        var transform = CGAffineTransform.identity

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        switch (self.imageOrientation) {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break

        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break

        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case .up, .upMirrored:
            break
        }

        switch (self.imageOrientation) {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break

        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break

        default: break
        }

        guard let cgImage = self.cgImage else { return self }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: cgImage.colorSpace ?? (CGColorSpace(name: CGColorSpace.sRGB)!),
            bitmapInfo: cgImage.bitmapInfo.rawValue)

        context?.concatenate(transform)

        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(cgImage, in: CGRect(
                x: 0,
                y: 0,
                width: self.size.height,
                height: self.size.width))

        default:
            context?.draw(cgImage, in: CGRect(
                x: 0,
                y: 0,
                width: self.size.width,
                height: self.size.height))

            break
        }

        // And now we just create a new UIImage from the drawing context.
        guard let newImage = context?.makeImage() else { return self }

        return UIImage(cgImage: newImage)
    }

    func rotate(by angle: CGFloat) -> UIImage {
        let rotatedFrame = CGRect(
            x: 0,
            y: 0,
            width: self.size.width,
            height: self.size.height)

        let rotatedSize = rotatedFrame.applying(CGAffineTransform(rotationAngle: angle)).size

        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        guard
            let context = UIGraphicsGetCurrentContext(),
            let cgImage = self.cgImage
            else { return self }

        context.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2)

        context.rotate(by: angle)

        context.scaleBy(x: 1, y: -1)

        context.draw(cgImage, in: CGRect(
            x: -self.size.width/2,
            y: -self.size.height/2,
            width: self.size.width,
            height: self.size.height))

        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }

}
