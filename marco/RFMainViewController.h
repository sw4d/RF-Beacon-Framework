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

@property (nonatomic, strong) NSMutableArray *jsonArray;

@property (nonatomic, strong) NSString *bName;
@property (nonatomic, strong) NSString *bMessage;
@property (nonatomic, strong) NSString *eName;
@property (nonatomic, strong) NSString *eLat;
@property (nonatomic, strong) NSString *eLong;
@property (nonatomic, strong) NSString *qID;
@property (nonatomic, strong) NSString *onQuest;;

@property (strong, nonatomic) IBOutlet UIImageView *theImage;



@end
