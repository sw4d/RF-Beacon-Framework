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


@property (nonatomic, strong) NSString *myChecker;

@end

@implementation RFMainViewController
@synthesize jsonArray, myChecker;



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDid fires");
    myChecker =@"";

    
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

//Arrivals fire once when you first hit a gimbal. This method won't fire again until you leave the range of a beacon, get a 'didDepart' method to fire and re-enter the range.

}
- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    
    //Will fire constantly for every ping your device gets from the gimbals. We use 'myChecker' as a way to ensure that our operation only fires once.
    
    NSLog(@"theId %@, name %@",visit.transmitter.identifier, visit.transmitter.name);
    //will show in console the name and ID of the transitters being found by your device.
    
    if ([visit.transmitter.name isEqualToString:@"rfTag"]&&([myChecker isEqualToString:@""])) {
        [FYX stopService];
        //stopping service makes the following operation run more consistently. You can restart service once you're done with this operation.
        NSLog(@"found");
        //this NSLog shows that the specific Tag name you're looking for was found. in our case, we're looking for a beacon named 'rfTag'
        myChecker = @"checked";
        //assigning this myChecker a value garuntees we only run the next method once.
        
        
        
        [self getMoreInfo:visit.transmitter.identifier];
        //This method passes the identifier along so we can check it against our backend.
    }
}
- (void)didDepart:(FYXVisit *)visit;
{
    //fires once after a user leaves the range of a gimbal.

}


-(void)getMoreInfo: (NSString *)theGimbID {
   
    NSString *post = [NSString stringWithFormat:@"color=2345&xyz=%@", theGimbID];
    //set your post values/variables in 'post'
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSURL *url = [NSURL URLWithString:@"http://beacon.usemeleaveme.com/run/4thapprun.php"];
    //set your URL that will interpret your post data.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];


    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *theConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:theConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *theTask;
    theTask = [mySession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self bikeInfoResult:data];
        //In this blok we can use the data we get back from our php page. In our case, we're sending post data to our php page and return 1 row of JSON data.
        
    }];
    
    [theTask resume];
    //this fires your Session
}

-(void)bikeInfoResult: (NSData *) theData {
    
    jsonArray = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:nil];
    //takes your JSON, interprets it into an array.

    NSString *part1 = [[jsonArray objectAtIndex:0] objectForKey:@"color"];
    NSString *part2 = [[jsonArray objectAtIndex:0] objectForKey:@"xyz"];
    //grab array objects and pass them to local variables
    
    NSDate *curDate = [NSDate date];

    //move the values pulled from our php files into an alert.
    NSString *theMessage = [NSString stringWithFormat:@"Date: %@, Message: %@ %@",curDate, part1, part2];

        NSString *thePrompt = [NSString stringWithFormat:@"Beacon Found!"];
        
        UIAlertView *theAlert = [[UIAlertView alloc]initWithTitle:theMessage message:thePrompt delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [theAlert show];



    
}

- (IBAction)btnStart:(id)sender {
    
    //this method starts the FYX Gimbal service.
    NSLog(@"firing");
    [FYX startService:self];
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    //be sure you set your delegates in your .h file or this self.visitManager.delegate may send warnings.
    
    NSMutableDictionary *options = [NSMutableDictionary new];
    [options setObject:[NSNumber numberWithInt:-44] forKey:FYXVisitOptionArrivalRSSIKey];
    [options setObject:[NSNumber numberWithInt:-60] forKey:FYXVisitOptionDepartureRSSIKey];
    [self.visitManager start];
}

- (IBAction)btnStop:(id)sender {
    //Stops the service.
    [FYX stopService];
    myChecker = @"";
}
@end
