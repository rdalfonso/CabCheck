//
//  DDViewController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/18/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>

@interface DDViewController : UIViewController<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,ADBannerViewDelegate> {
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    NSMutableArray *autocompleteObjects;
    UITableView *autocompleteTableView;
    NSString *cityObject;
}
@property (strong, nonatomic, readwrite) NSString *userLat;
@property (strong, nonatomic, readwrite) NSString *userLong;
@property (strong, nonatomic, readwrite) NSString *userCity;
@property (strong, nonatomic) IBOutlet UILabel *lblCityWarning;

@property (strong, nonatomic) IBOutlet UILabel *lblCurrentCity;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
- (IBAction)btnChangeCity:(id)sender;

@property (nonatomic, strong) PFObject *taxiObject;
@property (nonatomic, retain) NSMutableArray *autocompleteObjects;
@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (nonatomic, strong) NSString *cityObject;

@property (nonatomic, assign) NSString *deviceID;
@property (nonatomic, assign) NSInteger settingCity;

- (IBAction)goPressed;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;

@end
