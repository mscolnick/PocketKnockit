//
//  HomeViewController.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/22/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import CoreMotion

let DATA_SIZE = 5
let SAMPLE_DELAY = 0.1
let KNOCK_DETECT_SENSITIVITY:Float = 0.65

class HomeViewController: UIViewController {
 
    @IBOutlet var defaultMessage: UITextField!
    var knockCounter = 0
    var varyingDelay = 1
    var readyToListen = true
    var avPlayer = AVAudioPlayer() //for audio stuff
    var zvals:NSMutableArray = NSMutableArray()
    var motionManager:CMMotionManager = CMMotionManager()
    var sleepPreventer:MMPDeepSleepPreventer = MMPDeepSleepPreventer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var userDefaults = NSUserDefaults()

        if(userDefaults.objectForKey("message") == nil){
            userDefaults.setObject(self.defaultMessage.text, forKey: "message")
        }
        
        self.defaultMessage.text = userDefaults.objectForKey("message") as String
        
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.01
        
        self.readyToListen = true
        self.knockCounter = 0
        self.varyingDelay = 1

        self.zvals = NSMutableArray(capacity: DATA_SIZE)
        
        self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: { (accelerometerData: CMAccelerometerData!, error: NSError!) -> Void in
           dispatch_async(dispatch_get_main_queue(), { () -> Void in

            self.outputAccerlationData(accelerometerData)

            
            if(UIApplication.sharedApplication().applicationState != UIApplicationState.Active){
                if((error) != nil){
                    println(error)
                }
            }
            
            })
        })

        // Set AVAudioSession
        var sessionError:NSErrorPointer = nil
//        AVAudioSession.sharedInstance().setActive(true, error: nil)
//        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: sessionError)
//        AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: sessionError)
//        self.playSound()
        sleepPreventer.startPreventSleep();
        println("Home Screen Loaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func playSound(){
        let player = AVAudioPlayer(contentsOfURL: NSBundle().URLForResource("blank", withExtension: "mp3"), error: nil)
        if(player != nil){
            player.numberOfLoops = -1;
            player.play()
        }else{
            println("Error: No Sound")
        }
    }

    
    func detectKnock(firstArg: NSNumber, secondArg: NSNumber, thirdArg: NSNumber) -> Bool{
        var slope:Float = KNOCK_DETECT_SENSITIVITY
        if(firstArg.floatValue - secondArg.floatValue > slope){
            if(thirdArg.floatValue - secondArg.floatValue > slope){
                println("Detected a Knock")
                return true;
            }
        }
        if(firstArg.floatValue - secondArg.floatValue < -1*slope){
            if(thirdArg.floatValue - secondArg.floatValue < -1*slope){
                println("Detected a Knock")
                return true;
            }
        }
        return false;
    }
    
    
    func outputAccerlationData(acclerometerData: CMAccelerometerData){

        var acceleration:CMAcceleration = acclerometerData.acceleration
        
        if(self.zvals.count >= DATA_SIZE){
            self.zvals.removeObjectAtIndex(DATA_SIZE-1)
        }
        self.zvals.insertObject(NSNumber(double: acceleration.z), atIndex: 0)
        
        if(self.zvals.count > 2){
            if(detectKnock(self.zvals.objectAtIndex(0) as NSNumber, secondArg: self.zvals.objectAtIndex(1) as NSNumber, thirdArg: self.zvals.objectAtIndex(2) as NSNumber)){
                if(self.readyToListen){
                    self.knockCounter++;
                    self.readyToListen = false;
                    //TODO: perform selector - need new alternative
                    /* OLD Code
                    [self performSelector:@selector(resetReadyToListen) withObject:nil afterDelay:SAMPLE_DELAY];
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reportNumKnocks) object: nil];
                    [self performSelector:@selector(reportNumKnocks) withObject:nil afterDelay: self.varyingDelay];
                    */
                }
            }
        }
    }
    
    
    func resetReadyToListen(){
        self.readyToListen = false;
    }
    
    func reportNumKnocks(){
        if(self.knockCounter > 1){
            println("Registered \(self.knockCounter) Knocks")
            var def:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var userIds:NSArray = (def.dictionaryRepresentation() as NSDictionary).allKeysForObject(NSNumber(integer: self.knockCounter))
            if(userIds.count > 0){
                if(def.boolForKey("vibrationSettings")){
                    for(var i = 0; i < self.knockCounter; i++){
                        
                        //TODO: perform selector - need new alternative
                        //[self performSelector:@selector(vibratePhone) withObject:nil afterDelay:i/1.75];
                        /* POSSIBLE ALTERNATIVE
                        var timer = NSTimer.scheduledTimerWithTimeInterval(i/1.75, target: self, selector:  Selector("vibratePhone"), userInfo: nil, repeats: false)
                        */
                    }
                }
                if(UIApplication.sharedApplication().applicationState == UIApplicationState.Active){
                    var alert = UIAlertController(title: "You sent a knock!", message: "You knocked \(self.knockCounter) time", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            for userId in userIds {
                self.sendNotificationToUserWithObjectId(userId as NSString)
            }
        }
        self.knockCounter = 0;
    }
    
    func sendNotificationToUserWithObjectId(objId: NSString){

        /*
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"owner" equalTo:objId];
        
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery];
        NSUserDefaults *NSUD = [NSUserDefaults standardUserDefaults];
        NSString *message = [NSString stringWithFormat:@"%@\n-%@", [NSUD objectForKey:@"message"], [PFUser currentUser][@"displayName"]];
        [push setMessage:message];
        [push sendPushInBackground];
        
        PFObject *recentKnock = [PFObject objectWithClassName:@"History"];
        recentKnock[@"senderId"] = [PFUser currentUser].objectId;
        recentKnock[@"recipientId"] = objId;
        recentKnock[@"message"] = message;
        
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"MMM d, K:mm a"];
        recentKnock[@"sentTime"] = [dateFormatter stringFromDate: currentTime];
        
        [recentKnock saveInBackground];
        */
        
        //REFACTORED FROM ABOVE - NOT TESTED
        
        var pushQuery: PFQuery = PFInstallation.query()
        pushQuery.whereKey("owner", equalTo: objId)
        
        var push: PFPush = PFPush()
        var NSUD:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var message:NSString = String(format:"%@-%@", NSUD.objectForKey("message") as NSString, PFUser.currentUser()["displayName"] as NSString)
        push.setMessage(message)
        push.sendPushInBackgroundWithBlock(nil)
        
        var recentKnock:PFObject = PFObject(className: "History")

        recentKnock["senderId"] = PFUser.currentUser().objectId
        recentKnock["recipientId"] = objId
        recentKnock["message"] = message
        
        var currentTime:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateFormat = "MMM d, K:mm a"
        recentKnock["sentTIme"] = dateFormatter.stringFromDate(currentTime)
        recentKnock.saveInBackgroundWithBlock(nil)
        
    }

    
    func vibratePhone(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    
    /**
    * Called when 'return' key pressed. return NO to ignore.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
    * Called when the user click on the view (outside the UITextField).
    */
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var def:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var message:NSString = self.defaultMessage.text
        def.setObject(message, forKey: "message")
        def.synchronize()
        self.view.endEditing(true)
    }
    
}