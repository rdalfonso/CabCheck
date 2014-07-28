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
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    NSDate *todayDate = [NSDate date];
    __block int GoodCount = 0;
    __block int OkCount = 0;
    __block int BadCount = 0;
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    
    NSString *weekDay =  [theDateFormatter stringFromDate:[NSDate date]];
    
    self.userDate = todayDate;
    self.userWeekDay = weekDay;
    
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
                 
                 self.userAddress =address;
                 
                 PFObject *object = self.taxiObject;
                 _driverPickUp.text = address;
                 _driverPickupTime.text = [NSString stringWithFormat:@"%@, %@", weekDay, todayDate] ;
                 _driverName.text = [object objectForKey:@"driverName"];
                 _driverMedallion.text = [object objectForKey:@"driverMedallion"];
                 
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
                 
                 
                 PFQuery *driverRatings = [PFQuery queryWithClassName:@"DriverReviewObject"];
                 [driverRatings whereKey:@"taxiUniqueID" equalTo:taxiUniqueID];
                 [driverRatings findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                     if (!error)
                     {
                         long qCount = (unsigned long)results.count;
                         
                         for (PFObject *object in results)
                         {
                             NSInteger reviewOverall = [[object objectForKey:@"reviewOverall"] integerValue];
                             
                             if(reviewOverall == 0){
                                 GoodCount++;
                             }
                             
                             if(reviewOverall == 1){
                                 OkCount++;
                             }
                             
                             if(reviewOverall == 2){
                                 BadCount++;
                             }
                         }
                         NSLog(@"qCount %ld", qCount);
                         NSLog(@"GoodCount %d", GoodCount);
                         NSLog(@"OkCount %d", OkCount);
                         NSLog(@"BadCount %d", BadCount);
                         
                         if(GoodCount > BadCount ) {
                             NSLog(@"Green Light ");
                             _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                         }
                         else if(GoodCount < BadCount) {
                             NSLog(@"Red Light ");
                             _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                         }
                         else if( (GoodCount == BadCount) || (OkCount > GoodCount) ) {
                             NSLog(@"Yellow Light ");
                             _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
                         } else {
                             NSLog(@"Default Light ");
                             _driverRatingImage.image = [UIImage imageNamed: @"traffic-light-bb.jpg"];
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
    if ([segue.identifier isEqualToString:@"pushSeqDetailsToReview"]) {
        DDVCabRideReview *destViewController = segue.destinationViewController;
        
        if([self.taxiUniqueID length] > 0) {
            destViewController.taxiUniqueID = self.taxiUniqueID;
        }
    }
    if ([segue.identifier isEqualToString:@"pushSeqReadAllReviews"]) {
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
    
    NSArray *recipents = @[@"2019686897"];
    PFObject *object = self.taxiObject;
    
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
    
    NSString *message = [NSString stringWithFormat:@"CabCheck App Message:\n I just got into a %@ taxi near %@ on %@, %@.\n Taxi:%@\nDriver: %@\nMedallion Number: %@\nVIN: %@.", @"Uber", self.userAddress, self.userWeekDay, self.userDate, driverMake, driverName, driverMedallion, driverVin];
    
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
