//
//  PhotoChooseController.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 14.03.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

import UIKit
import GPUImage

class ImageChooseController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var location = CGPoint(x: 0, y: 0)
    var Crop : UIImageView?
    var moveLeft = false
    var isSingleTap = true
    
    var realHeight = CGFloat?()
    var realWidth = CGFloat?()
    var rectWidth = CGFloat?()
    var touchX = CGFloat?()
    var touchY = CGFloat?()
    
    var recText:String?

    
    @IBOutlet weak var pickedImageView: UIImageView!
    var bookmarkImage: BookmarkRecognition!
    
    var lastRectCoordinates = CGRect?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()
        
        // Do any additional setup after loading the view.
    }
    
    func setupGestureRecognizer()
    {
        var panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPanOnRect:")
        self.view.addGestureRecognizer(panRecognizer)
        
        let dubTouch = UITapGestureRecognizer(target: self, action: Selector("doubleTap"))
        dubTouch.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(dubTouch)
        
        let singleTouch = UITapGestureRecognizer(target: self, action: "singleTapConfirm")
        singleTouch.requireGestureRecognizerToFail(dubTouch)
        self.view.addGestureRecognizer(singleTouch)
        
      // peredelat tachbegin end na   UIPanGestureRecognizer !!!!
        
    }
    
    func isCoordinatesValid(touchX:CGFloat,touchY:CGFloat) -> Bool{
        if lastRectCoordinates!.minX < touchX && touchX < lastRectCoordinates!.maxX &&
            lastRectCoordinates!.minY < touchY && touchY < lastRectCoordinates!.maxY{
                //println(lastRectCoordinates!.minX)
                return true
        } else {
            return false
        }
    }
    
    func singleTapConfirm(){
        println("Single Touch Detected")
    }
    
    func doubleTap() {
        // peredelat v self.isCoordinatesValid() { rectText = self.getRecognizedText();!!!!
        
        recText = bookmarkImage.detectFromRectangle(lastRectCoordinates!.minX/realWidth!,y: lastRectCoordinates!.minY/realHeight!,width: rectWidth!/realWidth!, height: 200/realHeight!)
        println(recText)
        performSegueWithIdentifier("TextSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        
        if let svc = destination as? SendViewController {
            svc.test = true
            svc.text = recText! // self.getRecognizedText UBRST IZ double Tap
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        if pickedImageView.image == nil {
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = false
            self.presentViewController(image, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        bookmarkImage = BookmarkRecognition(image: image)
        
        pickedImageView.image = bookmarkImage.image;
        
        realHeight = self.view.frame.maxY/pickedImageView.image!.size.height
        realWidth = self.view.frame.maxX/pickedImageView.image!.size.width
        rectWidth = (self.view.frame.maxX)
        
        let rectImageSize = CGSize(width: rectWidth!, height: 200)
        let rectView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: rectImageSize))
        lastRectCoordinates = rectView.frame;
        self.view.addSubview(rectView)
        let rectImage = UIImage(contentsOfFile: "/projects/vsel/iOS/Rectrec/Rectrec/thumb.png")
        rectView.image = rectImage
        Crop = rectView
    }
    
    func detectPanOnRect(recognizer:UIPanGestureRecognizer){
        var translation = recognizer.locationInView(self.view)
        if isCoordinatesValid(translation.x, touchY: translation.y) {
            //println("Touch Detected \(translation.x)")
            Crop!.center = CGPointMake(self.view.frame.midX, translation.y)
            lastRectCoordinates = Crop?.frame
        }
       
    }
    /*
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("TouchBegan")
        let theTouch = touches.first as? UITouch
        var endPoint = theTouch!.locationInView(self.view)
        touchX = endPoint.x
        touchY = endPoint.y
        
        if  (lastRectCoordinates!.minX < touchX && touchX < lastRectCoordinates!.maxX &&
            lastRectCoordinates!.minY < touchY && touchY < lastRectCoordinates!.maxY && isSingleTap){

            
            location = theTouch!.locationInView(self.view)
            
            //Crop!.center = location

            moveLeft = true
        }
        

    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        moveLeft = false
        isSingleTap = false
        lastRectCoordinates = Crop?.frame
        sleep(1)
        isSingleTap = true
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("TouchMB")
        if moveLeft {
            
            var touch : UITouch! =  touches.first as? UITouch
            
            location = touch.locationInView(self.view)
            
            Crop!.center = CGPointMake(self.view.frame.midX, location.y)
            
        }
    
    */
}
    /*
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject()! as UITouch
        var endPoint = touch.locationInView(self.view)
        let x = endPoint.x
        let y = endPoint.y
        let realHeight = self.view.frame.maxY/pickedImageView.image!.size.height
        let realWidth = self.view.frame.maxX/pickedImageView.image!.size.width
        let rectWidth = (self.view.frame.maxX - x)
        if x > lastRectCoordinates.minX && y>lastRectCoordinates.minY {
            //WORKING: DONT WORK IF IMAGE <600x300 because of * and / reverse!!!!!!
            var text = bookmarkImage.detectFromRectangle(x/realWidth,y: y/realHeight,width: rectWidth/realWidth, height: 200/realHeight)
            println(BasicNetworkJSONSender().send(text))
        }
        
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let theTouch = touches.anyObject() as UITouch
        var endPoint = theTouch.locationInView(self.view)
        let x = endPoint.x
        let y = endPoint.y
        let realHeight = self.view.frame.maxY/pickedImageView.image!.size.height
        let realWidth = self.view.frame.maxX/pickedImageView.image!.size.width
        let rectWidth = (self.view.frame.maxX - x)
        let rectImageSize = CGSize(width: rectWidth, height: 200)
        let rectView = UIImageView(frame: CGRect(origin: CGPoint(x: x, y: y), size: rectImageSize))
        println(rectView.frame.minX)
        lastRectCoordinates = rectView.frame;
        self.view.addSubview(rectView)
        let rectImage = UIImage(contentsOfFile: "/projects/vsel/iOS/Rectrec/Rectrec/crop.png")
        //let rectImage = drawCustomImage(rectImageSize)
        rectView.image = rectImage
    }

    //Help Functions Remove!!!!!!!!!!
    
    func drawCustomImage(size: CGSize) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zeroPoint, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        
        CGContextStrokeRect(context, bounds)
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
        CGContextStrokePath(context)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func drawRedRectangle(size: CGSize) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zeroPoint, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        
        CGContextStrokeRect(context, bounds)
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
        CGContextStrokePath(context)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return RBResizeImage(RBSquareImage(image), targetSize: size)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight - edge) / 2.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge)
        
        var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)!
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
*/
