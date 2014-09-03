//
//  DDViewController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/18/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>
#import "CabObject.h"
#import "CabObjectDataBase.h"

@interface DDViewController : UIViewController<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,ADBannerViewDelegate> {
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    NSMutableArray *autocompleteObjects;
    UITableView *autocompleteTableView;
    NSString *cityObject;
    CabObjectDataBase *_dbManager;
}

@property (strong, nonatomic) ADBannerView *UIiAD;
@property (strong, nonatomic, readwrite) NSString *userLat;
@property (strong, nonatomic, readwrite) NSString *userLong;
@property (strong, nonatomic, readwrite) NSString *userCity;
@property (nonatomic, strong) NSString *cityObject;
@property (nonatomic, assign) NSString *deviceID;
@property (nonatomic, assign) NSInteger settingCity;
@property (strong, nonatomic) IBOutlet UILabel *lblCityWarning;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentCity;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (nonatomic, retain) NSMutableArray *autocompleteObjects;
@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (nonatomic, strong) CabObject *taxiObject;
@property (nonatomic, strong) CabObjectDataBase *dbManager;

- (IBAction)btnChangeCity:(id)sender;
- (IBAction)goPressed;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;

@end
