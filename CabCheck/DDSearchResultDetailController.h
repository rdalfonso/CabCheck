//
//  DDSearchResultDetailController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/24/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>

@interface DDSearchResultDetailController : UIViewController<CLLocationManagerDelegate,ADBannerViewDelegate,MFMessageComposeViewControllerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (strong, nonatomic) ADBannerView *UIiAD;
@property (nonatomic, assign) NSString *deviceID;
@property (nonatomic, assign) NSString *settingCityString;

@property (strong, nonatomic, readwrite) NSString *userSMS1;
@property (strong, nonatomic, readwrite) NSString *userSMS2;
@property (strong, nonatomic, readwrite) NSString *userSMS3;
@property (strong, nonatomic, readwrite) NSString *userCity;
@property (strong, nonatomic, readwrite) NSString *userAddress;
@property (strong, nonatomic, readwrite) NSString *userDate;
@property (strong, nonatomic, readwrite) NSString *userLat;
@property (strong, nonatomic, readwrite) NSString *userLong;

@property (nonatomic, strong) PFObject *taxiObject;
@property (strong, nonatomic) IBOutlet UILabel *lblSearchResultDetailHeader;
@property (strong, nonatomic) IBOutlet UILabel *driverReviewTags;
@property (strong, nonatomic) IBOutlet UILabel *driverLicense;
@property (strong, nonatomic) IBOutlet UILabel *driverLicenseLabel;
@property (strong, nonatomic) IBOutlet UILabel *driverType;
@property (strong, nonatomic) IBOutlet UILabel *driverName;
@property (strong, nonatomic) IBOutlet UILabel *driverMedallion;
@property (strong, nonatomic) IBOutlet UILabel *driverCabInfo;
@property (strong, nonatomic) IBOutlet UILabel *driverPickUp;
@property (strong, nonatomic) IBOutlet UILabel *driverPickupTime;

@property (strong, nonatomic) IBOutlet UIButton *btnReadRevews;
@property (strong, nonatomic) IBOutlet UIImageView *driverRatingImage;


- (IBAction)btnSendData:(id)sender;

@end
