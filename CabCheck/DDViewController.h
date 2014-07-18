//
//  DDViewController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/18/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DDViewController : UIViewController<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentCity;
@property (strong, nonatomic) IBOutlet UITextField *lblSearchBox;
@property (strong, nonatomic) IBOutlet UITextField *txtSearchTaxi;

@property (strong, nonatomic, readwrite) NSString *userLat;
@property (strong, nonatomic, readwrite) NSString *userLong;
@property (strong, nonatomic, readwrite) NSString *userCity;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;

@end
