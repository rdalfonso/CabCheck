//
//  DDBeginCabCheck.m
//  CabCheck
//
//  Created by Rich DAlfonso on 9/1/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDBeginCabCheck.h"
#import "DDCabRideReview.h"
#import "MKMapViewZoomLevel.h"

@interface DDBeginCabCheck ()

@end

@implementation DDBeginCabCheck
@synthesize mapView;
@synthesize deviceID;

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
    
    [self.mapView setShowsUserLocation:YES];
    //Front-end control manipulation
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
   
    [self refreshUserDefaults];
    [self showTaxiInformationSMS:self.taxiObject];
    [self setMapPoints];
}



-(void) setMapPoints
{
    //add pins to mapView
    CLLocationCoordinate2D annotationCoord;
    double latdouble = [self.userLat doubleValue];
    double londouble = [self.userLong doubleValue];
    annotationCoord.latitude = latdouble;
    annotationCoord.longitude = londouble;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"Your pickup location was:";
    annotationPoint.subtitle = self.userAddress;
    
    [mapView addAnnotation:annotationPoint];
    
    CLLocationCoordinate2D centerCoord = { [self.userLat doubleValue], [self.userLong doubleValue] };
    [self.mapView setCenterCoordinate:centerCoord zoomLevel:12 animated:NO];
}

-(void) refreshUserDefaults
{
    NSLog(@"refreshUserDefaults");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"deviceID"] == nil) {
        self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        self.deviceID = [defaults stringForKey:@"deviceID"];
    }
    
    if([defaults objectForKey:@"userPickUpAddress"] != nil) {
        self.userAddress = [defaults stringForKey:@"userPickUpAddress"];
        NSLog(@"userAddress %@", self.userAddress );
        
    }
    
    if([defaults objectForKey:@"userPickUpDate"] != nil) {
        self.userDate = [defaults stringForKey:@"userPickUpDate"];
        NSLog(@"userDate %@", self.userDate );
    }
    
    if([defaults objectForKey:@"userPickUpAddress"] != nil) {
        self.userAddress = [defaults stringForKey:@"userPickUpAddress"];
        NSLog(@"userAddress %@", self.userAddress );
    }
    
    if([defaults objectForKey:@"userLatPickUp"] != nil) {
        self.userLat = [defaults stringForKey:@"userLatPickUp"];
        NSLog(@"userLatPickUp %@", self.userLat );
    }
    
    if([defaults objectForKey:@"userLongPickUp"] != nil) {
        self.userLong = [defaults stringForKey:@"userLongPickUp"];
        NSLog(@"userLatPickUp %@", self.userLong );
    }
    
    if([defaults objectForKey:@"userCurrentCity"] != nil)
    {
        NSInteger settingCity = [defaults integerForKey:@"userCurrentCity"];
        if(settingCity == 0) {
            self.settingCityString = @"New York City";
        }
        else if(settingCity == 1) {
            self.settingCityString = @"Chicago";
        }
        else if(settingCity == 2) {
            self.settingCityString = @"San Francisco";
        }
        else if(settingCity == 3) {
            self.settingCityString = @"Las Vegas";
        }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushSeqReviewThisDriver"]) {
        DDCabRideReview *destViewController = segue.destinationViewController;
        
        if(self.taxiObject != nil) {
            destViewController.taxiObject = self.taxiObject;
        }
    }
    
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
    [passengerSMS appendString:self.settingCityString];
    
    if ([driverType isEqualToString:@"Y"]) {
        [passengerSMS appendString:@" Yellow Medallion Taxi\n"];
    }
    else if ([driverType isEqualToString:@"L"]) {
        [passengerSMS appendString:@" TLC Street Hail Livery Taxi\n"];
    } else {
        [passengerSMS appendString:@" Medallion Taxi\n"];
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
    if ([driverDMVLicense length] > 0)
    {
        [passengerSMS appendString:[NSString stringWithFormat:@"License Plate: %@.\n", driverDMVLicense]];
    }
    
    [passengerSMS appendString:[NSString stringWithFormat:@"\n Download this app at http://www.duomodigital.com/cabcheck.html"]];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:passengerSMS];
    
    
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
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
