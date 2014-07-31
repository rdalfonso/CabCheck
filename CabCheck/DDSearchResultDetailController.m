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
@property NSString *deviceID;
@property NSString *lastCabReviewed;
@property NSDate *lastCabReviewDate;
@end

@implementation DDSearchResultDetailController
@synthesize taxiUniqueID;

-(void) refreshUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"deviceID"] == nil) {
        self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        self.deviceID = [defaults stringForKey:@"deviceID"];
    }
    
    if([defaults objectForKey:@"userlastCabReviewed"] != nil) {
       self.lastCabReviewed = [defaults stringForKey:@"userlastCabReviewed"];
    }
    
    if([defaults objectForKey:@"userLastCabReviewDate"] != nil) {
        self.lastCabReviewDate = [defaults objectForKey:@"userLastCabReviewDate"];
    }
}


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
    [self refreshUserDefaults];
    
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
    
    NSLog(@"lastCabReviewed: %@", self.lastCabReviewed);
    NSLog(@"taxiUniqueID: %@", self.taxiUniqueID);
    
    if( [self.lastCabReviewed isEqualToString:self.taxiUniqueID] )
    {
        NSLog(@"hiding");
        _btnReviewTaxi.hidden = true;
    }
    else
    {
         NSLog(@"showing");
        _btnReviewTaxi.hidden = false;
    }
}


-(void)searchBtnUserClick:(id)sender
{
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
                     NSString *driverType = [object objectForKey:@"driverType"];
                     NSString *driverName = [object objectForKey:@"driverName"];
                     NSString *driverMedallion = [object objectForKey:@"driverMedallion"];
                     NSString *driverDMVLicense = [object objectForKey:@"driverDMVLicense"];
                     if([driverDMVLicense length] <= 0){
                         driverDMVLicense = @"N/A";
                     }
                     NSString *driverVIN = [object objectForKey:@"driverVIN"];
                     NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
                     NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
                     NSString *driverCabYear =[object objectForKey:@"driverCabYear"];
                     
                     _lblSearchResultDetailHeader.text = [NSString stringWithFormat:@"Driver Details - %@", driverMedallion];
                     
                     if ([driverType isEqualToString:@"Y"])
                     {
                         _driverType.text = @"Yellow Medallion Taxi";
                         _driverVINLabel.text = @"VIN:";
                         _driverVIN.text = driverVIN;
                         _driverLicense.text = [NSString stringWithFormat:@"%@ %@ %@", driverCabMake, driverCabModel, driverCabYear];
                         
                     } else if ([driverType isEqualToString:@"L"])
                     {
                         _driverType.text = @"TLC Street Hail Livery";
                         _driverVINLabel.text = @"License:";
                         _driverVIN.text = driverDMVLicense;
                         _driverLicense.text = @"Livery Sedan";
                     }
                     
                     _driverName.text = driverName;
                     _driverMedallion.text = driverMedallion;
                     _driverPickUp.text = [address stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
                     _driverPickupTime.text = [NSString stringWithFormat:@"%@", [theDateFormatter stringFromDate:todayDate]];
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
                         }
                         
                         //Calculate scores
                         NSMutableString *reviewTags = [NSMutableString stringWithString:@""];
                         
                         float pcGood = [self getReviewPercent:TotalCount withInteger:GoodCount];
                         float pcOk = [self getReviewPercent:TotalCount withInteger:OkCount];
                         float pcBad = [self getReviewPercent:TotalCount withInteger:BadCount];
                         
                         if( (GoodCount + OkCount + BadCount) == 0){
                             NSLog(@"Green Light ");
                             _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                             _driverReviewTags.text = @"No Reviews Yet.";
                         }
                         else
                         {
                             
                             if( pcGood >= 50.0  )
                             {
                                  NSLog(@"Green Light ");
                                 _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                                 _driverReviewTags.text = @"Good Driver. Few Complaints.";
                             }
                             else
                             {
                                
                                 float pcRespect = [self getReviewPercent:TotalCount withInteger:RespectCount];
                                 float pcDriving = [self getReviewPercent:TotalCount withInteger:DrivingCount];
                                 float pcEnglish = [self getReviewPercent:TotalCount withInteger:EnglishCount];
                                 float pcHonest = [self getReviewPercent:TotalCount withInteger:HonestCount];
                                 float pcDirections = [self getReviewPercent:TotalCount withInteger:DirectionsCount];
                                 
                                 if(pcDirections >= PERCENT_LEVEL) {
                                     [reviewTags appendString:@"Bad Sense of Direction\n"];
                                 }
                                 
                                 if(pcDriving >= PERCENT_LEVEL) {
                                     [reviewTags appendString:@"Bad Driver. "];
                                 }
                                 
                                 if(pcRespect >= PERCENT_LEVEL) {
                                     [reviewTags appendString:@"Rude. "];
                                 }
                                 
                                 if(pcHonest >= PERCENT_LEVEL) {
                                     [reviewTags appendString:@"Dishonest Fare. "];
                                 }
                                 
                                 if(pcEnglish >= PERCENT_LEVEL) {
                                     [reviewTags appendString:@"Poor English. "];
                                 }
                             
                                 if( (pcOk > 30.0) || (pcGood ==  pcBad) ) {
                                      NSLog(@"Yellow Light ");
                                     _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                                     _driverReviewTags.text = reviewTags;
                                 }
                                 
                                 if( pcBad >= 50.0 ) {
                                     NSLog(@"Red Light ");
                                     _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                                     _driverReviewTags.text = reviewTags;
                                 }
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


-(BOOL) hasUserReviewedThisCab:(int)TotalCount withInteger:(int)categoryCount
{
    return FALSE;
}

-(float) getReviewPercent:(int)TotalCount withInteger:(int)categoryCount
{
 
    float precentage = 0.0;
    
    
    @try
    {
        if(categoryCount > 0 && TotalCount > 0)
        {
            precentage = (100 * categoryCount)/TotalCount;
        } else {
            precentage = 0;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        precentage = 0;
    }
    
    
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
    
    
    //Get Use Contacts
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userSMSNumbers = [NSMutableArray arrayWithArray:[defaults objectForKey:@"userSMSNumbers"]];
    NSArray *recipents = [userSMSNumbers copy];
    
    //Get Taxi Object information
    PFObject *object = self.taxiObject;
    
    NSString *driverType = [object objectForKey:@"driverType"];
    NSString *driverName = [object objectForKey:@"driverName"];
    NSString *driverCompany = [object objectForKey:@"driverCompany"];
    NSString *driverMedallion = [object objectForKey:@"driverMedallion"];
    NSString *driverDMVLicense = [object objectForKey:@"driverDMVLicense"];
    if([driverDMVLicense length] <= 0){
        driverDMVLicense = @"N/A";
    }
    NSString *driverVIN = [object objectForKey:@"driverVIN"];
    NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
    NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
    NSString *driverCabYear =[object objectForKey:@"driverCabYear"];
    
    NSMutableString *driverMake = [NSMutableString stringWithString:@""];

    
    if([driverCabMake length] > 0) {
        [driverMake appendString:driverCabMake];
        [driverMake appendString:@" "];
    }
    
    if([driverCabModel length] > 0) {
        [driverMake appendString:driverCabModel];
        [driverMake appendString:@" "];
    }
    
    if([driverCabYear length] > 0) {
        [driverMake appendString:driverCabYear];
    }
    
     NSMutableString *passengerSMS = [NSMutableString stringWithString:@""];
    [passengerSMS appendString:@"CabCheck App Message:\n"];
    [passengerSMS appendString:@"I just got into a "];
    
    if ([driverType isEqualToString:@"Y"])
    {
        [passengerSMS appendString:@"Yellow Medallion Taxi\n"];
    }
    else
    {
        [passengerSMS appendString:@"TLC Street Hail Livery Taxi\n"];
    }
    [passengerSMS appendString:[NSString stringWithFormat:@"near %@ on %@.\n", self.userAddress, self.userDate]];
    if([driverMake length] > 0) {
        [passengerSMS appendString:[NSString stringWithFormat:@"Taxi Model: %@.\n", driverMake]];
    } else {
        [passengerSMS appendString:[NSString stringWithFormat:@"Taxi Company: %@.\n", driverCompany]];
    }
    [passengerSMS appendString:[NSString stringWithFormat:@"Driver: %@.\n", driverName]];
    [passengerSMS appendString:[NSString stringWithFormat:@"Medallion Number: %@.\n", driverMedallion]];
    if ([driverVIN length] > 0)
    {
        [passengerSMS appendString:[NSString stringWithFormat:@"VIN: %@.\n", driverVIN]];
    }
    else if ([driverType isEqualToString:@"L"])
    {
        [passengerSMS appendString:[NSString stringWithFormat:@"License Plate: %@.\n", driverDMVLicense]];
    }
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:passengerSMS];
    
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
