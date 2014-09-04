//
//  DDEndCabCheck.m
//  CabCheck
//
//  Created by Rich DAlfonso on 9/1/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDEndCabCheck.h"
#import "MKMapViewZoomLevel.h"
#import "DDAppDelegate.h"

@interface DDEndCabCheck ()
{
    BOOL _bannerIsVisible;
}
@end

@implementation DDEndCabCheck
@synthesize mapView;
@synthesize deviceID;

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
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [_UIiAD setAlpha:0];
        [UIView commitAnimations];
        _bannerIsVisible = NO;
    }
    
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    NSLog(@"bannerview was selected");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
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
    [self.mapView setShowsUserLocation:YES];
    
    //Front-end control manipulation
    [self.navigationItem setHidesBackButton:YES];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    //Add Search icon
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
        target:self action:@selector(searchBtnUserClick:)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    //allow banner ads
    self.canDisplayBannerAds = YES;
    
    //Initialize CoreLocation
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.pausesLocationUpdatesAutomatically = YES;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    
    //Viewload methods
    [self setMapPoints];
    
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
                 
              }
         } ];
    }
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
    annotationPoint.title = @"Your dropoff location was:";
    annotationPoint.subtitle = self.userAddress;
    
    [mapView addAnnotation:annotationPoint];
    [self.mapView setCenterCoordinate:annotationCoord zoomLevel:12 animated:NO];
}


-(void)searchBtnUserClick:(id)sender
{
    [self performSegueWithIdentifier:@"seqPushToSearchController" sender:sender];
}


-(void) refreshUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"deviceID"] == nil) {
        self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        self.deviceID = [defaults stringForKey:@"deviceID"];
    }
    
    if([defaults objectForKey:@"userPickUpAddress"] != nil) {
        self.userAddress = [defaults stringForKey:@"userPickUpAddress"];
        
    }
    
    if([defaults objectForKey:@"userPickUpDate"] != nil) {
        self.userDate = [defaults stringForKey:@"userPickUpDate"];
    }
    
    if([defaults objectForKey:@"userPickUpAddress"] != nil) {
        self.userAddress = [defaults stringForKey:@"userPickUpAddress"];
    }
    
    if([defaults objectForKey:@"userLatPickUp"] != nil) {
        self.userLat = [defaults stringForKey:@"userLatPickUp"];
    }
    
    if([defaults objectForKey:@"userLongPickUp"] != nil) {
        self.userLong = [defaults stringForKey:@"userLongPickUp"];
    }
    //defaults = nil;
    
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
