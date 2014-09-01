//
//  DDEndCabCheck.m
//  CabCheck
//
//  Created by Rich DAlfonso on 9/1/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDEndCabCheck.h"
#import "MKMapViewZoomLevel.h"
#import "MKMapViewZoomLevel.h"

@interface DDEndCabCheck ()

@end

@implementation DDEndCabCheck
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
    
    //Initialize CoreLocation
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=10.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
    
    [self setMapPoints];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        _userLatEnd = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        _userLongEnd = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
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
    annotationPoint.title = @"Your pickup location was:";
    annotationPoint.subtitle = self.userAddress;
    
    [mapView addAnnotation:annotationPoint];
    
    CLLocationCoordinate2D centerCoord = { [self.userLat doubleValue], [self.userLong doubleValue] };
    [self.mapView setCenterCoordinate:centerCoord zoomLevel:12 animated:NO];
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
