//
//  DDSearchResultDetailController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/24/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDSearchResultDetailController.h"
#import "DDCabReviews.h"
#import "DDBeginCabCheck.h"
#import "DDAppDelegate.h"
#define PERCENT_LEVEL 25.0

@interface DDSearchResultDetailController ()
{
    BOOL _bannerIsVisible;
}
@end

@implementation DDSearchResultDetailController

//Methods for iADs....

- (DDAppDelegate *) appdelegate {
    return (DDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) viewWillAppear:(BOOL)animated{
    _UIiAD = [[self appdelegate] UIiAD];
    _UIiAD.delegate = self;
    [_UIiAD setFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    [self.view addSubview:_UIiAD];
}


-(void) viewWillDisappear:(BOOL)animated{
    _UIiAD.delegate = nil;
    _UIiAD=nil;
    [_UIiAD removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_UIiAD.superview == nil)
        {
            [self.view addSubview:_UIiAD];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [_UIiAD setAlpha:1];
        [UIView commitAnimations];
        _bannerIsVisible = YES;
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
   // NSLog(@"ads not loaded");
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [_UIiAD setAlpha:0];
        [UIView commitAnimations];
        _bannerIsVisible = NO;
    }
    
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"bannerview was selected");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return willLeave;
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
    [self buildCabInfoSection];
    
    //Initialize CoreLocation
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //locationManager.distanceFilter=10.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    
     //Layout changes
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
        target:self action:@selector(searchBtnUserClick:)];
    self.navigationItem.rightBarButtonItem = searchItem;
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
    //allow banner ads
    self.canDisplayBannerAds = YES;
    
    [self buildReviewSection];
    
}

-(void) buildCabInfoSection
{
    NSDate *todayDate = [NSDate date];
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEE, MMM d, h:mm a"];
    self.userDate = [NSString stringWithFormat:@"%@", [theDateFormatter stringFromDate:todayDate]];
    
    CabObject *object = self.taxiObject;
    if(object != nil)
    {
        NSString *driverType = object.driverType;
        NSString *driverName = object.driverName;
        NSString *driverMedallion = object.driverMedallion;
        NSString *driverDMVLicense = object.driverDMVLicense;
        NSString *driverVIN = object.driverVIN;
        
        NSMutableString *driverCabType = [NSMutableString stringWithString:@""];
        NSString *driverCabMake = object.driverCabMake;
        NSString *driverCabModel = object.driverCabModel;
        NSString *driverCabYear = object.driverCabYear;
        
        if([driverDMVLicense length] <= 0){
            driverDMVLicense = @"N/A";
        }
        
        if([driverVIN length] <= 0){
            driverVIN = @"N/A";
        }
        
        if([driverCabMake length] > 0) {
            [driverCabType appendString:[driverCabMake capitalizedString]];
        }
        if([driverCabModel length] > 0) {
            [driverCabType appendString:@" "];
            [driverCabType appendString:[driverCabModel capitalizedString]];
        }
        if([driverCabYear length] > 0) {
            [driverCabType appendString:@" "];
            [driverCabType appendString:driverCabYear];
        }
        
        if([driverMedallion length] > 0) {
            _lblSearchResultDetailHeader.text = [NSString stringWithFormat:@"Driver Details - %@", driverMedallion];
        }
        
        _driverName.text = driverName;
        _driverMedallion.text = driverMedallion;
        _driverLicense.text = driverDMVLicense;
        _driverPickupTime.text = [NSString stringWithFormat:@"%@", [theDateFormatter stringFromDate:todayDate]];
        
        if ([driverType isEqualToString:@"Y"]) {
            _driverType.text = @"Yellow Medallion Taxi";
            _driverCabInfo.text = driverCabType;
        }
        else if ([driverType isEqualToString:@"L"]) {
            _driverType.text = @"TLC Street Hail Livery";
            _driverCabInfo.text = @"Livery Sedan";
            
        } else {
            _driverType.text = @"Medallion Taxi";
            _driverCabInfo.text = driverCabType;
        }
    }
}
-(void) refreshUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"deviceID"] == nil) {
        self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        self.deviceID = [defaults stringForKey:@"deviceID"];
    }
    
    if([defaults objectForKey:@"userCurrentCity"] != nil)
    {
        self.settingCity = [defaults integerForKey:@"userCurrentCity"];
    }
}

- (void)buildReviewSection
{
    __block int GoodCount = 0;
    __block int OkCount = 0;
    __block int BadCount = 0;
    
    __block int DrivingCount = 0;
    __block int HonestCount = 0;
    __block int EnglishCount = 0;
    __block int RespectCount = 0;
    __block int DirectionsCount = 0;
    __block long TotalCount = 0;
    
    PFQuery *driverRatings = [PFQuery queryWithClassName:@"DriverReviewObject"];
    [driverRatings whereKey:@"taxiUniqueID" equalTo:[NSString stringWithFormat:@"%d",self.taxiObject.uniqueCabId]];
     driverRatings.cachePolicy = kPFCachePolicyNetworkOnly;
    driverRatings.limit = 20;
    [driverRatings findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error)
        {
            TotalCount = (unsigned long)results.count;
            
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
                if(reviewActCourteous == 1) {
                    RespectCount++;
                }
                if(reviewDriveSafe == 1) {
                    DrivingCount++;
                }
                if(reviewFollowDirections == 1) {
                    EnglishCount++;
                }
                if(reviewHonestFare == 1) {
                    HonestCount++;
                }
                if(reviewKnowCity == 1) {
                    DirectionsCount++;
                }
            }
            
            if( TotalCount == 0){
                _driverRatingImage.image = [UIImage imageNamed: @"review-green-large.jpg"];
                _driverReviewTags.text = @"No Reviews Yet.";
                _btnReadRevews = NO;
                _btnReadRevews.titleLabel.textColor = [UIColor grayColor];
            }
            else
            {
                
                _btnReadRevews.enabled = YES;
                _btnReadRevews.titleLabel.textColor = [UIColor colorWithRed:30.0f/255.0f green:144.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
                [_btnReadRevews setTitle:[NSString stringWithFormat:@"%ld user reviews.", TotalCount] forState:UIControlStateNormal];
                
                //Calculate scores
                float pcGood =  [self getReviewPercent:TotalCount withInteger:GoodCount];
                float pcOk = [self getReviewPercent:TotalCount withInteger:OkCount];
                float pcBad = [self getReviewPercent:TotalCount withInteger:BadCount];
                
                if( pcGood >= 50.0  )
                {
                    _driverRatingImage.image = [UIImage imageNamed: @"review-green-large.jpg"];
                    _driverReviewTags.text = @"Good Driver. Few Complaints.";
                }
                else
                {
                    NSString *reviewTags = [self getReviewTags:TotalCount withInteger:RespectCount withInteger:DrivingCount withInteger:EnglishCount withInteger:HonestCount withInteger:DirectionsCount];
                    
                    
                    if( (pcOk > 30.0) || (pcGood ==  pcBad) ) {
                        _driverRatingImage.image = [UIImage imageNamed: @"review-yellow-large.jpg"];
                        _driverReviewTags.text = reviewTags;
                    }
                    
                    if( pcBad >= 50.0 ) {
                        _driverRatingImage.image = [UIImage imageNamed: @"review-red-large.jpg"];
                        _driverReviewTags.text = reviewTags;
                    }
                }
            }
            
        }
        
    }];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
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
                 
                 // Store the pickup address and date
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:self.userAddress forKey:@"userPickUpAddress"];
                 [defaults setObject:self.userDate forKey:@"userPickUpDate"];
                 [defaults setObject:_userLat forKey:@"userLatPickUp"];
                 [defaults setObject:_userLong forKey:@"userLongPickUp"];
                 [defaults synchronize];
                 
                 _driverPickUp.text = [self.userAddress stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
             }
         } ];
    }
}



-(void)searchBtnUserClick:(id)sender
{
    [self performSegueWithIdentifier:@"seqPushToSearchController" sender:sender];
}


- (IBAction)btnSendData:(id)sender {
    NSLog(@"trying SMS");
    [self showTaxiInformationSMS:self.taxiObject];
}

-(NSString *) getReviewTags:(long)TotalCount withInteger:(int)RespectCount withInteger:(int)DrivingCount withInteger:(int)EnglishCount withInteger:(int)HonestCount withInteger:(int)DirectionsCount
{
    NSMutableString *reviewTags = [NSMutableString stringWithString:@""];
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
    
    return reviewTags;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushSeqDetailToAllReviews"]) {
        DDCabReviews *destViewController = segue.destinationViewController;
        
        if(self.taxiObject != nil) {
            destViewController.taxiObject = self.taxiObject;
        }
    }
    
    if ([segue.identifier isEqualToString:@"seqPushSMSConfirm"]) {
        DDBeginCabCheck *destViewController = segue.destinationViewController;
        
        if(self.taxiObject != nil) {
            destViewController.taxiObject = self.taxiObject;
        }
    }
    
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        case MessageComposeResultSent:
            NSLog(@"loaded or pressed");
            [self dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"seqPushSMSConfirm" sender:nil];
            break;
            
        default:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
    
}


- (void)showTaxiInformationSMS:(CabObject*)taxiObject {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    
    //Get Taxi Object information
    CabObject *object = self.taxiObject;
    
    NSString *driverType = object.driverType;
    NSString *driverName = object.driverName;
    NSString *driverMedallion = object.driverMedallion;
    NSString *driverDMVLicense = object.driverDMVLicense;
    NSString *driverVIN = object.driverVIN;
    NSString *driverCompany = object.driverCompany;
    NSString *driverCompanyPhone = object.driverCompanyPhone;
    
    NSString *driverCabMake = object.driverCabMake;
    NSString *driverCabModel = object.driverCabModel;
    NSString *driverCabYear = object.driverCabYear;
    
    if([driverDMVLicense length] <= 0){
        driverDMVLicense = @"N/A";
    }
    
    NSMutableString *passengerSMS = [NSMutableString stringWithString:@""];
    [passengerSMS appendString:@"CabCheck App Message:\n"];
    [passengerSMS appendString:@"I just got into a "];
    [passengerSMS appendString:self.settingCityString];
    
    if(self.settingCity == 0) {
        [passengerSMS appendString:@"New York City"];
    }
    else if(self.settingCity == 1) {
        [passengerSMS appendString:@"Chicago"];
    }
    else if(self.settingCity == 2) {
        [passengerSMS appendString:@"San Francisco"];
    }
    else if(self.settingCity == 3) {
        [passengerSMS appendString:@"Las Vegas"];
    }
    
    if ([driverType isEqualToString:@"Y"]) {
        [passengerSMS appendString:@" Yellow Medallion Taxi\n"];
    }
    else if ([driverType isEqualToString:@"L"]) {
        [passengerSMS appendString:@" TLC Street Hail Livery Taxi\n"];
    }
    
    [passengerSMS appendString:[NSString stringWithFormat:@"near %@ on %@.\n\n", self.userAddress, self.userDate]];
    
    [passengerSMS appendString:[NSString stringWithFormat:@"Driver: %@.\n", driverName]];
    [passengerSMS appendString:[NSString stringWithFormat:@"Medallion Number: %@.\n", driverMedallion]];
    if([driverCabMake length] > 0) {
        [passengerSMS appendString:[NSString stringWithFormat:@"Vehicle: %@.\n", driverCabMake]];
    }
    if([driverCabModel length] > 0) {
        [passengerSMS appendString:[NSString stringWithFormat:@"Model: %@ %@.\n", driverCabModel, driverCabYear]];
    }
    
    if ([driverVIN length] > 0){
        [passengerSMS appendString:[NSString stringWithFormat:@"VIN: %@.\n", driverVIN]];
    }
    if ([driverDMVLicense length] > 0)
    {
        [passengerSMS appendString:[NSString stringWithFormat:@"License Plate: %@.\n", driverDMVLicense]];
    }
    if([driverCompany length] > 0) {
        [passengerSMS appendString:[NSString stringWithFormat:@"Taxi Company: %@.\n", driverCompany]];
    }
        
    if([driverCompanyPhone length] > 0) {
        [passengerSMS appendString:[NSString stringWithFormat:@"Taxi Company Number: %@.\n", driverCompanyPhone]];
    }
        
    [passengerSMS appendString:[NSString stringWithFormat:@"\n Download this app at http://www.duomodigital.com/cabcheck.html"]];
    
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:nil];
    [messageController setBody:passengerSMS];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
}


-(float) getReviewPercent:(long)TotalCount withInteger:(int)categoryCount
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
        precentage = 0;
    }
    
    return precentage;
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
