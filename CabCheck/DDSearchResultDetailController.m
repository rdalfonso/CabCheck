//
//  DDSearchResultDetailController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/24/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDSearchResultDetailController.h"
#import "DDVCabRideReview.h"
#import "DDCabReviews.h"

#define PERCENT_LEVEL 25.0

@interface DDSearchResultDetailController ()

@end

@implementation DDSearchResultDetailController
@synthesize taxiUniqueID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.taxiUniqueID = self.taxiObject.objectId;
    
    //Initialize CoreLocation
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=10.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    
     //Layout changes
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
        target:self action:@selector(searchBtnUserClick:)];
    
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [self.navigationItem setHidesBackButton:NO animated:YES];
}


-(void)searchBtnUserClick:(id)sender
{
    NSLog(@"\n Search pressed");
    
    [self performSegueWithIdentifier:@"seqPushToSearchController" sender:sender];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    
    __block int GoodCount = 0;
    __block int OkCount = 0;
    __block int BadCount = 0;
    
    __block int DrivingCount = 0;
    __block int HonestCount = 0;
    __block int EnglishCount = 0;
    __block int RespectCount = 0;
    __block int DirectionsCount = 0;
    __block long TotalCount = 0;
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEE, MMM d, h:mm a"];
    self.userDate = todayDate;
    
    if (currentLocation != nil) {
        
        _userLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        _userLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error == nil && [placemarks count] > 0)
             {
                 placemark = [placemarks lastObject];
                 _userCity = placemark.locality;
                 
                 NSString *address = [NSString stringWithFormat:@"%@ %@,%@ %@", [placemark subThoroughfare],[placemark thoroughfare],[placemark locality], [placemark administrativeArea]];
                 self.userAddress = address;
                 
                 PFObject *object = self.taxiObject;
                 if(object != nil)
                 {
                     NSString *driverMedallion = [object objectForKey:@"driverMedallion"];
                     
                     NSMutableString *detailHeader = [NSMutableString stringWithString:@""];
                     [detailHeader appendString:@"Driver Details - "];
                     [detailHeader appendString:driverMedallion];
                     _lblSearchResultDetailHeader.text = detailHeader;
                     
                     NSString *driverType =[object objectForKey:@"driverType"];
                     if ([driverType isEqualToString:@"Y"]) {
                         _driverType.text = @"Yellow Medallion";
                     } else if ([driverType isEqualToString:@"L"]) {
                         _driverType.text = @"TLC Street Hail Livery";
                     } else {
                         _driverType.text = @"Yellow Medallion";
                     }
                     
                     _driverPickUp.text = [address stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
                     _driverPickupTime.text = [NSString stringWithFormat:@"%@", [theDateFormatter stringFromDate:todayDate]];
                     _driverName.text = [object objectForKey:@"driverName"];
                     _driverMedallion.text = driverMedallion;
                     
                     NSMutableString *make = [NSMutableString stringWithString:@""];
                     NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
                     if([driverCabMake length] > 0) {
                         [make appendString:driverCabMake];
                     }
                     [make appendString: @" "];
                     NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
                     if([driverCabModel length] > 0) {
                         [make appendString:driverCabModel];
                     }
                     _driverLicense.text = make;
                     _driverCabMakeModel.text = [object objectForKey:@"driverCabYear"];
                     _driverVIN.text = [object objectForKey:@"driverVin"];
                 }
                 
                 PFQuery *driverRatings = [PFQuery queryWithClassName:@"DriverReviewObject"];
                 [driverRatings whereKey:@"taxiUniqueID" equalTo:taxiUniqueID];
                 [driverRatings findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                     if (!error)
                     {
                         TotalCount = (unsigned long)results.count;
                        
                         if(TotalCount > 0) {
                             NSString *btnMessage = [NSString stringWithFormat:@"Read %ld reviews of this taxi >", TotalCount];
                             _btnReviewLink.titleLabel.text = btnMessage;
                             _btnReviewLink.hidden = false;
                         } else {
                             _btnReviewLink.hidden = false;
                         }
                         
                         for (PFObject *object in results)
                         {
                             NSInteger reviewOverall = [[object objectForKey:@"reviewOverall"] integerValue];
                             NSInteger reviewActCourteous = [[object objectForKey:@"reviewActCourteous"] integerValue];
                             NSInteger reviewDriveSafe = [[object objectForKey:@"reviewDriveSafe"] integerValue];
                             NSInteger reviewFollowDirections = [[object objectForKey:@"reviewFollowDirections"] integerValue];
                             NSInteger reviewHonestFare = [[object objectForKey:@"reviewHonestFare"] integerValue];
                             NSInteger reviewKnowCity = [[object objectForKey:@"reviewKnowCity"] integerValue];
                             
                             if(reviewOverall == 0){
                                 GoodCount++;
                             }
                             
                             if(reviewOverall == 1){
                                 OkCount++;
                             }
                             
                             if(reviewOverall == 2){
                                 BadCount++;
                             }
                             
                             if(reviewActCourteous == 1){
                                 RespectCount++;
                             }
                             if(reviewDriveSafe == 1){
                                 DrivingCount++;
                             }
                             if(reviewFollowDirections == 1){
                                 EnglishCount++;
                             }
                             if(reviewHonestFare == 1){
                                 HonestCount++;
                             }
                             if(reviewKnowCity == 1){
                                 DirectionsCount++;
                             }
                             
                             NSLog(@"RespectCount %d", RespectCount);
                             NSLog(@"DrivingCount %d", DrivingCount);
                             NSLog(@"EnglishCount %d", EnglishCount);
                             NSLog(@"HonestCount %d", HonestCount);
                             NSLog(@"DirectionsCount %d", DirectionsCount);
                         }
                         
                         //Calculate scores
                         int OverallScore = 0;
                         NSMutableString *reviewTags = [NSMutableString stringWithString:@""];
                         
                         float pcRespect = [self getReviewPercent:TotalCount withInteger:RespectCount];
                         float pcDriving = [self getReviewPercent:TotalCount withInteger:DrivingCount];
                         float pcEnglish = [self getReviewPercent:TotalCount withInteger:EnglishCount];
                         float pcHonest = [self getReviewPercent:TotalCount withInteger:HonestCount];
                         float pcDirections = [self getReviewPercent:TotalCount withInteger:DirectionsCount];
                         
                         if( (GoodCount + OkCount + BadCount) == 0){
                             NSLog(@"Green Light ");
                             _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                             _driverReviewTags.text = @"No Reviews Yet.";
                         }
                         else
                         {
                             if(pcDirections >= PERCENT_LEVEL) {
                                 OverallScore++;
                                 [reviewTags appendString:@"Bad Sense of Direction\n"];
                             }
                             
                             if(pcRespect >= PERCENT_LEVEL) {
                                 OverallScore++;
                                 [reviewTags appendString:@"Rude. "];
                             }
                             
                             if(pcDriving >= PERCENT_LEVEL) {
                                 OverallScore++;
                                 [reviewTags appendString:@"Terrible Driver. "];
                             }
                             
                             if(pcHonest >= PERCENT_LEVEL) {
                                 OverallScore++;
                                 [reviewTags appendString:@"Dishonest Fare "];
                             }
                             
                             if(pcEnglish >= PERCENT_LEVEL) {
                                 OverallScore++;
                                 [reviewTags appendString:@"Poor English. "];
                             }
                             
                             NSString *reviewTagsNew = [reviewTags stringByReplacingOccurrencesOfString: @"," withString:@"\n"];
                             
                             if( (GoodCount > OkCount) && (OkCount > BadCount) )
                             {
                                 NSLog(@"Green Light ");
                                 _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                                 _driverReviewTags.text = @"Good Driver. Few Complaints.";
                             }
                             if( (GoodCount < OkCount) && (GoodCount > BadCount) ) {
                                 NSLog(@"Yellow Light ");
                                 _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                                 _driverReviewTags.text = reviewTagsNew;
                             }
                             
                             if( (GoodCount < BadCount) || (OverallScore >= 2)) {
                                 NSLog(@"Red Light ");
                                 _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                                 _driverReviewTags.text = reviewTagsNew;
                             }
                         }
                         
                     }
                     else {
                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                     }
                 }];
                 
             } else {
                 NSLog(@"ERROR: %@", error.debugDescription);
             }
         } ];
    }
}

-(float) getReviewPercent:(int)TotalCount withInteger:(int)categoryCount
{
    float precentage = (100 * categoryCount)/TotalCount;
    NSLog(@"%i of %i reviews were negative. That are %.1f percent!",categoryCount,TotalCount,precentage);
    
    return precentage;
}


- (IBAction)btnSendData:(id)sender {
    
    [self showTaxiInformationSMS:self.taxiObject];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue.identifier: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"pushSeqDetailToReviewTaxi"]) {
        DDVCabRideReview *destViewController = segue.destinationViewController;
        
        if([self.taxiObject.objectId length] > 0) {
            destViewController.taxiObject = self.taxiObject;
        }
    }
    if ([segue.identifier isEqualToString:@"pushSeqDetailToAllReviews"]) {
        DDCabReviews *destViewController = segue.destinationViewController;
        
        NSLog(@"self.taxiUniqueID: %@",self.taxiUniqueID);
        if([self.taxiUniqueID length] > 0) {
            destViewController.taxiUniqueID = self.taxiUniqueID;
        }
    }
    
}

- (void)showTaxiInformationSMS:(PFObject*)taxiObject {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userSMSNumbers = [NSMutableArray arrayWithArray:[defaults objectForKey:@"userSMSNumbers"]];
    NSArray *recipents = [userSMSNumbers copy];
    PFObject *object = self.taxiObject;
    
    NSString *driverType = [object objectForKey:@"driverType"];
    NSString *driverName = [object objectForKey:@"driverName"];
    NSString *driverMedallion = [object objectForKey:@"driverMedallion"];
    
    NSMutableString *driverMake = [NSMutableString stringWithString:@""];
    
    NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
    if([driverCabMake length] > 0) {
        [driverMake appendString:driverCabMake];
        [driverMake appendString:@" "];
    }
    
    NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
    if([driverCabModel length] > 0) {
        [driverMake appendString:driverCabModel];
        [driverMake appendString:@" "];
    }
    
    NSString *driverCabYear =[object objectForKey:@"driverCabYear"];
    if([driverCabYear length] > 0) {
        [driverMake appendString:driverCabYear];
    }
    NSString *driverVin = [object objectForKey:@"driverVin"];
    
    NSString *message = [NSString stringWithFormat:@"CabCheck App Message:\n I just got into a %@ Taxi near %@ on %@.\n Taxi:%@\nDriver: %@\nMedallion Number: %@\nVIN: %@.", driverType, self.userAddress, self.userDate, driverMake, driverName, driverMedallion, driverVin];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"kCLAuthorizationStatusDenied");
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        NSLog(@"kCLAuthorizationStatusAuthorized");
    }
    
    if([CLLocationManager locationServicesEnabled]){
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if([CLLocationManager locationServicesEnabled]){
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
