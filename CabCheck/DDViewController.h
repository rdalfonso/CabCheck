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

@interface DDViewController : UIViewController<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
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

@property (strong, nonatomic) IBOutlet UILabel *lblCurrentCity;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property (nonatomic, strong) PFObject *taxiObject;
@property (nonatomic, retain) NSMutableArray *autocompleteObjects;
@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (nonatomic, strong) NSString *cityObject;

- (IBAction)goPressed;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;

@end
