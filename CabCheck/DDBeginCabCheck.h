//
//  DDBeginCabCheck.h
//  CabCheck
//
//  Created by Rich DAlfonso on 9/1/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CabObject.h"
@interface DDBeginCabCheck : UIViewController<CLLocationManagerDelegate,ADBannerViewDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}


@property (nonatomic, strong) CabObject *taxiObject;
@property (strong, nonatomic) ADBannerView *UIiAD;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic, readwrite) NSMutableArray *userCabPoints;
@property (strong, nonatomic) IBOutlet UIButton *btnReviewThisDriver;

@property (strong, nonatomic, readwrite) NSString *userAddress;
@property (strong, nonatomic, readwrite) NSString *userDate;
@property (strong, nonatomic, readwrite) NSString *userLat;
@property (strong, nonatomic, readwrite) NSString *userLong;
@property (strong, nonatomic, readwrite) NSString *userCity;

@end
