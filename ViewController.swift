//
//  ViewController.swift
//  Snap Search
//  Created by Taiwo Adelabu on 7/27/16.
//  Copyright ©2016 Taiwo Adelabu, K.Swain & D.Nwankwo. All rights reserved.

import UIKit
import Alamofire
import CloudSight
import LLSimpleCamera
import SafariServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CloudSightImageRequestDelegate, CloudSightQueryDelegate {
    @IBOutlet weak var imageSaved: UIImageView!
    @IBOutlet weak var restartLabel: UIButton!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var myImage: UIImage?
    var switchButton = UIButton();
    var flashButton = UIButton()
    // camera
    var camera : LLSimpleCamera!
    var snapButton = UIButton()
    
    var isSafari = false
    
    @IBOutlet weak var scrollContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let screenRect = UIScreen.mainScreen().bounds
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetPhoto, position: LLCameraPositionRear, videoEnabled: false)
        self.scrollContainerView.addSubview(self.camera.view)
        self.camera.view.frame = screenRect
        self.addChildViewController(self.camera)
        self.camera.didMoveToParentViewController(self)
        self.scrollableHeightConstraint.constant = screenRect.height
        self.activityIndicator.hidden = true
        self.titleLabel.hidden = true
        self.restartLabel.hidden = true
        self.saveButton.hidden = true
        
        self.switchButton = UIButton(type: .System)
        self.switchButton.frame = CGRectMake(self.view.frame.width - 60, 20, 29.0 + 20.0, 22.0 + 20.0)
        self.switchButton.tintColor = UIColor.whiteColor()
        self.switchButton.setImage(UIImage(named: "camera-switch.png"), forState: .Normal)
        self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10.0, 10.0, 10)
        self.switchButton.addTarget(self, action: #selector(ViewController.switchButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.camera.view.addSubview(self.switchButton)
        
        self.flashButton = UIButton(type: .System)
        self.flashButton.frame = CGRectMake(self.view.frame.width - 120, 20, 29.0 + 20.0, 22.0 + 20.0)
        self.flashButton.tintColor = UIColor.whiteColor()
        self.flashButton.setImage(UIImage(named: "camera-flash.png"), forState: .Normal)
        self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        self.flashButton.addTarget(self, action: "flashButtonPressed:", forControlEvents: .TouchUpInside)
        //self.flashButton.hidden = true;
        self.view!.addSubview(self.flashButton)
    
         self.camera.onDeviceChange = {(camera, device) -> Void in
         if camera.isFlashAvailable() {
         self.flashButton.hidden = false
         if camera.flash == LLCameraFlashOff {
         self.flashButton.selected = false
         }
         else {
         self.flashButton.selected = true
         }
         }
         else {
         self.flashButton.hidden = true
         }
         }
        
        // title label
        
        self.titleLabel.userInteractionEnabled = true
        
        let labelGesture = UITapGestureRecognizer(target: self, action: Selector("showSearch"))
        titleLabel.addGestureRecognizer(labelGesture)
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !isSafari {
            self.camera.start()
        }
    }
    
    @IBOutlet weak var scrollableHeightConstraint: NSLayoutConstraint!
    @IBAction func snapPressed(sender: AnyObject) {
        
        self.camera.capture { (camera, image, metadata, error) in
            self.myImage = image
            self.AlamoFireRequest()
        }
        let btn = sender as? UIButton
        snapButton = btn!
        snapButton.hidden = true
    }
    
    func switchButtonPressed(button: UIButton) {
        if(camera.position == LLCameraPositionRear){
            self.flashButton.hidden = false;
        }
        else{
            self.flashButton.hidden = true;
        }
        
        self.camera.togglePosition()
    
    }
    
    func flashButtonPressed(button: UIButton) {
        if self.camera.flash == LLCameraFlashOff {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOn)
            if done {
                self.flashButton.selected = true
                self.flashButton.tintColor = UIColor.yellowColor();
            }
        }
        else {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOff)
            if done {
                self.flashButton.selected = false
                self.flashButton.tintColor = UIColor.whiteColor();
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var imagePicker: UIImagePickerController!
    @IBOutlet var imageView: UIImageView!
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.cameraDevice = .Front
        
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.myImage = imageView.image
        self.AlamoFireRequest()
        
    }
    
    // With Alamofire
    //    func fetchAllRooms() {
    //
    //        Alamofire.upload(
    //            .POST,
    //            "https://api.cloudsightapi.com//image_requests",
    //            headers: ["Authorization" : "CloudSight [n2o53offxe1q5WJC4Dzm0Q]"],
    //            multipartFormData: { multipartFormData in
    //                multipartFormData.appendBodyPart(data: self.myImage!, name: "imagefile",
    //                    fileName: "image.jpg", mimeType: "image/jpeg")
    //            },
    //            encodingCompletion: { encodingResult in
    //
    //            }
    //    }
    
    
    func AlamoFireRequest () {
        
        
        CloudSightConnection.sharedInstance().consumerKey = "n2o53offxe1q5WJC4Dzm0Q"
        CloudSightConnection.sharedInstance().consumerSecret = "g_eBushHVJmxtuKPBPSCaw"
        
        self.searchWithImage(self.myImage!)
        
        //            Alamofire.request(.POST, "http://cloudsightapi.com/image_requests/", headers: ["Authorization":"CloudSight n2o53offxe1q5WJC4Dzm0Q",] ,parameters: ["image_request[image]": self.myImage!, "image_request[locale]":"en-US", "Secret":"g_eBushHVJmxtuKPBPSCaw", "API Key":"n2o53offxe1q5WJC4Dzm0Q"])
        //                .responseJSON { response in
        //                    print(response.request)  // original URL request
        //                    print(response.response) // URL response
        //                    print(response.data)     // server data
        //                    print(response.result)   // result of response serialization
        //
        //                    if let JSON = response.result.value {
        //                        print("JSON: \(JSON)")
        //                    }
        //            }
    }
    
    var cloudQuery : CloudSightQuery?
    func searchWithImage(image: UIImage) {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        let deviceIdentifier: String = "923d2c2263sacaid7"
        // This can be any unique identifier per device, and is optional - we like to use UUIDs
        let location: CLLocation = CLLocation(latitude: 51, longitude: 14)
        // you can use the CLLocationManager to determine the user's location
        // We recommend sending a JPG image no larger than 1024x1024 and with a 0.7-0.8 compression quality,
        // you can reduce this on a Cellular network to 800x800 at quality = 0.4
        let imageData: NSData = UIImageJPEGRepresentation(image, 0.4)!
        // Create the actual query object
        let query: CloudSightQuery = CloudSightQuery(image: imageData, atLocation: CGPointZero, withDelegate: self, atPlacemark: location, withDeviceId: deviceIdentifier)
        // Start the query process
        query.start()
        self.cloudQuery = query

    }
    
    // MARK: - CloudSightImageRequestDelegate
    
    func cloudSightRequest(sender: CloudSightImageRequest!, didFailWithError error: NSError!) {
        
    }
    
    func cloudSightRequest(sender: CloudSightImageRequest!, didReceiveToken token: String!, withRemoteURL url: String!)
    {
        
    }
    @IBAction func changeCamera(sender: AnyObject) {
        camera.togglePosition()
    }
    
    // MARK: - CloudSightQueryDelegate
    
    @IBOutlet weak var titleLabel: UILabel!
    func cloudSightQueryDidFinishIdentifying(query: CloudSightQuery!) {
        dispatch_async(dispatch_get_main_queue()) {
            if query.title != nil {
                print(query.title)
        
                var str: String = query.title
                
                
                str.replaceRange(str.startIndex...str.startIndex, with: String(str[str.startIndex]).capitalizedString)
                self.titleLabel.text = str
            }
            self.activityIndicator.hidden = true
            self.titleLabel.hidden = false
            self.camera.stop()
            self.activityIndicator.stopAnimating()
            self.restartLabel.hidden = false
            self.saveButton.hidden = false
            self.switchButton.hidden = true
            self.flashButton.hidden = true
            self.titleLabel.hidden = false

        }
    }
    
    func cloudSightQueryDidFail(query: CloudSightQuery!, withError error: NSError!) {
        dispatch_async(dispatch_get_main_queue()) {
            print(error)
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func restartCamera(sender: AnyObject) {
        switchButton.hidden = false
        snapButton.hidden = false
        self.camera.start()
        self.restartLabel.hidden = true
        self.saveButton.hidden = true
        self.titleLabel.hidden = true
        self.flashButton.hidden = false
        isSafari = false
    }
    
    
    @IBAction func save(sender: AnyObject) {
        
        
       if let myImage = myImage {
            UIImageWriteToSavedPhotosAlbum(myImage, self, nil, nil)
            self.imageSaved.alpha = 1.0
        UIView.animateWithDuration(4.0, delay: 0.1, options: .CurveEaseOut, animations: {
            self.imageSaved.alpha = 0.0

            }, completion: nil)


       }
    }
    
    //
    //        Alamofire.request(
    //            .GET,
    //            "http://localhost:5984/rooms/_all_docs",
    //            parameters: ["include_docs": "true"],
    //            encoding: .URL)
    //            .validate()
    //            .responseJSON { (response) -> Void in
    //                guard response.result.isSuccess else {
    //                    print("Error while fetching remote rooms: \(response.result.error)")
    //                    completion(nil)
    //                    return
    //                }
    //
    //                guard let value = response.result.value as? [String: AnyObject],
    //                    rows = value["rows"] as? [[String: AnyObject]] else {
    //                        print("Malformed data received from fetchAllRooms service")
    //                        completion(nil)
    //                        return
    //                }
    //
    //                var rooms = [RemoteRoom]()
    //                for roomDict in rows {
    //                    rooms.append(RemoteRoom(jsonData: roomDict))
    //                }
    //
    //                completion(rooms)
    //        }
    //    }
    
    func showSearch() {
        print("Label Touched")
        let searchText = titleLabel.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlString = "https://google.com" + "/search?q=" + searchText
        let svc = SFSafariViewController(URL: NSURL(string: urlString)!)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
    }
}

extension ViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        print("Finished")
        isSafari = true
        
    }
}


