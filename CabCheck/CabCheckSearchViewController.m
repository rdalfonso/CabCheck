//
//  CabCheckSearchViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/30/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "CabCheckSearchViewController.h"
#import "DDCabSearchResultsViewController.h"
#import <Parse/Parse.h>

@interface CabCheckSearchViewController ()

@end

@implementation CabCheckSearchViewController

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
    
    //Initialize CoreLocation
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=100.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699"
         style:UIBarButtonItemStylePlain target:self action:@selector(settingsBtnUserClick:)];
    
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    NSArray *actionButtonItems = @[settingsItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    if ([self.txtSearch respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Medallion, License, or Driver Name." attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [self.txtSearch becomeFirstResponder];
    [self.txtSearch resignFirstResponder];
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
            destViewController.globalSearchTerm = _txtSearch.text;
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
                 
                 _lblCurrentCity.text =_userCity;
                 
                 NSLog(@"_userCity: %@", _userCity);
                 
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

- (IBAction)btnSearch:(id)sender {
}
@end
