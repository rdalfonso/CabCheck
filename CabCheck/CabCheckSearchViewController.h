//
//  CabCheckSearchViewController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/30/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CabCheckSearchViewController : UIViewController<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@property (strong, nonatomic, readwrite) NSString *userLat;
@property (strong, nonatomic, readwrite) NSString *userLong;
@property (strong, nonatomic, readwrite) NSString *userCity;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentCity;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
- (IBAction)btnSearch:(id)sender;

@end
