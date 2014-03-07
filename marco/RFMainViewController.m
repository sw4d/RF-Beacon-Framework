//
//  RFMainViewController.m
//  marco
//
//  Created by Stephen Ford on 2/6/14.
//  Copyright (c) 2014 Stephen Ford. All rights reserved.
//

#import "RFMainViewController.h"

#import <FYX/FYX.h>
#import <Social/Social.h>



@interface RFMainViewController () {
    
}
 @property (nonatomic) FYXVisitManager *visitManager;



@end

@implementation RFMainViewController
@synthesize jsonArray;

int hours, minutes, seconds;
int secondsLeft;


    NSString *returner;

    NSString *victory;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDid fires");

    victory = @"";
   [FYX startService:self];

    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    [self.visitManager start];

    
  
    
//go by beacon, get time from server
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}

#pragma mark - Flipside View




#pragma - gimbal Refs
- (void)serviceStarted
{

}
- (void)didArrive:(FYXVisit *)visit;
{


    if ([visit.transmitter.name isEqualToString:@"swTag"]) {
        NSLog(@"found");

     
        
        
    [self getMoreInfo:visit.transmitter.identifier];
    }
    

}
- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
 
}
- (void)didDepart:(FYXVisit *)visit;
{

}


-(void)getMoreInfo: (NSString *)theGimbID {
   
    NSString *post = [NSString stringWithFormat:@"theCall=1&gimbalID=%@", theGimbID];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSURL *url = [NSURL URLWithString:@"http://beacon.usemeleaveme.com/run/RFFrame.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];


    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *theConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:theConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *theTask;
    theTask = [mySession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self bikeInfoResult:data];
     
        
    }];
    
    [theTask resume];

}

-(void)bikeInfoResult: (NSData *) theData {
    jsonArray = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:nil];
  

    NSString *aDate = [[jsonArray objectAtIndex:0] objectForKey:@"theDate"];
    NSString *aMessage = [[jsonArray objectAtIndex:0] objectForKey:@"theMessage"];

    NSString *theMessage = [NSString stringWithFormat:@"Date: %@, Message: %@", aDate, aMessage];
        
        NSString *thePrompt = [NSString stringWithFormat:@"Beacon Found!"];
        
        UIAlertView *theAlert = [[UIAlertView alloc]initWithTitle:theMessage message:thePrompt delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [theAlert show];



    
}
//
//-(void)bikeQuestCheck: (NSData *) theData {
//    jsonArray = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:nil];
//
//    NSString *activePrize = [[jsonArray objectAtIndex:0] objectForKey:@"isAccepted"];
//
//
//    startTimeDate = [NSDate dateWithTimeInterval:1200 sinceDate:[NSDate date]];
//    
//  
//
//    
//    if ([activePrize isEqualToString:@"1"]) {
//  
//
//        onQuest = @"questing";
//        
//     
//        
//    }
//    if ([activePrize isEqualToString:@"0"]) {
//       
//        [self dismissViewControllerAnimated:true completion:nil];
//        UIAlertView *theAlert = [[UIAlertView alloc]initWithTitle:@"Doh!" message:@"Someone else accepted the quest before you did" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [theAlert show];
//        
//        
//    }
//   
//    
//}
//
//
//- (void)alertView:(UIAlertView *)alertView
//clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//
//    if (buttonIndex == 1) {
//        
//        if ([tweetSetting isEqualToString:@""]) {
//            [self postUpSecond:theUUID bikeName:bName];
//        }
//        if ([tweetSetting isEqualToString:@"tweet"]) {
//            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//                SLComposeViewController *theTweet  = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//                [theTweet setInitialText:@"I just won big with #UseMeLeaveMe! You could be next: www.usemeleaveme.com/quest"];
//                [self presentViewController:theTweet animated:YES completion:nil];
//                
//
//            }
//        }
//        
//    }
//    if (buttonIndex == 0) {
//
//        if ([victory isEqualToString:@"hunt"]) {
//         [self dismissViewControllerAnimated:true completion:nil];
//            victory = @"";
//            
//        }
//
//    }
//
//}
//
//
//-(void)pushBikeName: (NSString *)theBike pushBikeMessage: (NSString *) theMessage {
//    
//    NSString *localString = theMessage;
//    
//    UILocalNotification *theNote = [[UILocalNotification alloc]init];
//   
//    theNote.alertBody = [NSString stringWithFormat:@"%@", localString];
//    
//    theNote.soundName =  UILocalNotificationDefaultSoundName;
//    theNote.timeZone = [NSTimeZone defaultTimeZone];
//    theNote.fireDate = [NSDate date];
//
//    [[UIApplication sharedApplication] scheduleLocalNotification:theNote];
//
//    
//}
//
//-(void)postUpSecond: (NSString *)theUUID1 bikeName: (NSString *) theBike{
//    //post data/session method
//
//    victory = @"";
//    //for testing:theCall=2&questID=4&uuid='someNumber'&bikeID=Ken
//    NSString *post = [NSString stringWithFormat:@"theCall=2&questID=%@&uuid=%@&bikeID=%@", qID, theUUID1, theBike];
//    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
//    
//    NSURL *url = [NSURL URLWithString:@"http://beacon.usemeleaveme.com/run/runUpdate2.php"];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//    [request setHTTPMethod:@"POST"];
//
//
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:postData];
//    
//    NSURLSessionConfiguration *theConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:theConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    
//    NSURLSessionDataTask *theTask;
//    theTask = [mySession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        [self bikeQuestCheck:data];
//        
//    }];
//        [theTask resume];
//    
//}
//
//
//
//
@end
