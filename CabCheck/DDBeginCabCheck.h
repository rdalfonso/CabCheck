//
//  DDBeginCabCheck.h
//  CabCheck
//
//  Created by Rich DAlfonso on 9/1/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
@interface DDBeginCabCheck : UIViewController<MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic, readwrite) NSString *userAddress;
@property (strong, nonatomic, readwrite) NSString *userDate;
@property (strong, nonatomic, readwrite) NSString *userLat;
@property (strong, nonatomic, readwrite) NSString *userLong;
@property (nonatomic, assign) NSString *settingCityString;
@property (nonatomic, strong) PFObject *taxiObject;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *btnReviewThisDriver;
@property (nonatomic, assign) NSString *deviceID;
@end
