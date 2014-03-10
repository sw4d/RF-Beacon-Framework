//
//  RFMainViewController.h
//  marco
//
//  Created by Stephen Ford on 2/6/14.
//  Copyright (c) 2014 Stephen Ford. All rights reserved.
//


#import <FYX/FYX.h>
#import <FYX/FYXVisitManager.h>


@interface RFMainViewController : UIViewController <FYXServiceDelegate, FYXVisitDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate, UIAlertViewDelegate>
//setting your delegates for your class very important. https://gimbal.com/doc/ios_quickstart.html

@property (nonatomic, strong) NSMutableArray *jsonArray;
//declare array to use for incoming json file from php page.

- (IBAction)btnStart:(id)sender;
- (IBAction)btnStop:(id)sender;


@end
