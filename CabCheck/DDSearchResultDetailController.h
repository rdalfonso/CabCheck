//
//  DDSearchResultDetailController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/24/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>

@interface DDSearchResultDetailController : UIViewController<MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (nonatomic, strong) NSString *taxiUniqueID;
@property (nonatomic, strong) PFObject *taxiObject;

@property (strong, nonatomic) IBOutlet UILabel *driverName;
@property (strong, nonatomic) IBOutlet UILabel *driverMedallion;
@property (strong, nonatomic) IBOutlet UILabel *driverLicense;
@property (strong, nonatomic) IBOutlet UILabel *driverCabMakeModel;
@property (strong, nonatomic) IBOutlet UILabel *driverVIN;
@property (strong, nonatomic) IBOutlet UILabel *driverSpeaksEnglish;
@property (strong, nonatomic) IBOutlet UIImageView *driverRatingImage;


@property (strong, nonatomic, readwrite) NSDate *userDate;
@property (strong, nonatomic, readwrite) NSString *userSMS1;
@property (strong, nonatomic, readwrite) NSString *userSMS2;
@property (strong, nonatomic, readwrite) NSString *userSMS3;

@property (strong, nonatomic, readwrite) NSString *userCity;
@property (strong, nonatomic, readwrite) NSString *userAddress;

@property (strong, nonatomic, readwrite) NSString *userLat;
@property (strong, nonatomic, readwrite) NSString *userLong;
@property (strong, nonatomic) IBOutlet UILabel *driverPickUp;
@property (strong, nonatomic) IBOutlet UILabel *driverPickupTime;

- (IBAction)btnSendData:(id)sender;

@end
