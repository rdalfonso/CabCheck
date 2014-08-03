//
//  DDViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/18/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDViewController.h"
#import "DDCabSearchResultsViewController.h"
#import <Parse/Parse.h>

@interface DDViewController ()
@property NSString *deviceID;
@end

@implementation DDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshUserDefaults];
    
    //Initialize CoreLocation
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=100.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    //Layout and Navigation
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699"
                                                                     style:UIBarButtonItemStylePlain target:self action:@selector(settingsBtnUserClick:)];
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    NSArray *actionButtonItems = @[settingsItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    //Change Placeholder
    if ([self.txtSearch respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Taxi Medallion Number." attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    //Responders to Textfields
    [self.txtSearch becomeFirstResponder];
    [self.txtSearch resignFirstResponder];
    
    self.txtSearch.delegate = self;
    

}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *ACCEPTABLE_CHARACTERS = @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    NSString *filtered = [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL allGoodChars = [textField.text isEqualToString:filtered];
    NSLog(allGoodChars ? @"yes" : @"no");
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 60 || returnKey;
}


-(void) refreshUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"deviceID"] == nil) {
        NSLog(@"New DeviceID");
        [defaults setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceID"];
        [defaults synchronize];
    }
    self.deviceID = [defaults stringForKey:@"deviceID"];
    NSLog(@"deviceID: %@", self.deviceID);
    
    
}

-(void)settingsBtnUserClick:(id)sender
{
    [self performSegueWithIdentifier:@"pushSeqToSettings" sender:sender];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtSearch resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txtSearch resignFirstResponder];
    
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"pushSeqSearchResults"]) {
        DDCabSearchResultsViewController *destViewController = segue.destinationViewController;
        
        if([_txtSearch.text length] > 0) {
            destViewController.globalSearchTerm = [_txtSearch.text uppercaseString];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        _userLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        _userLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error == nil && [placemarks count] > 0)
             {
                 placemark = [placemarks lastObject];
                 _userCity = placemark.locality;
                 
                 _lblCurrentCity.text = _userCity;
                
             } else {
                 NSLog(@"ERROR: %@", error.debugDescription);
             }
         } ];

    }
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
                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if([CLLocationManager locationServicesEnabled]){
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                    message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSearch:(id)sender {
}
@end
