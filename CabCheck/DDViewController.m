//
//  DDViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/18/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDViewController.h"
#import "DDSearchResultDetailController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "DDAppDelegate.h"

@implementation DDViewController
@synthesize autocompleteObjects;
@synthesize autocompleteTableView;
@synthesize cityObject;



- (DDAppDelegate *) appdelegate {
    return (DDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) viewWillAppear:(BOOL)animated{
    _UIiAD = [[self appdelegate] UIiAD];
    _UIiAD.delegate = self;
    [_UIiAD setFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    [self.view addSubview:_UIiAD];
}


-(void) viewWillDisappear:(BOOL)animated{
    _UIiAD.delegate = nil;
    _UIiAD=nil;
    [_UIiAD removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"ads loaded");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [_UIiAD setAlpha:1];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"ads not loaded");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [_UIiAD setAlpha:0];
    [UIView commitAnimations];
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"bannerview was selected");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return willLeave;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get/Set User settings used throughout app.
    [self refreshUserDefaults];
    
    //Initialize CoreLocation
    geocoder = [[CLGeocoder alloc] init];
    
    //Initialize Results
    self.autocompleteObjects = [[NSMutableArray alloc] init];
    
    //Initialize LocationManager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=100.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    //Layout and Navigation
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    
    //Add search icon to navigation
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699"
                                                                     style:UIBarButtonItemStylePlain target:self action:@selector(settingsBtnUserClick:)];
    self.navigationItem.rightBarButtonItem = settingsItem;
    
    //Change Placeholder text on search field to be darker.
    if ([self.txtSearch respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Taxi Medallion Number." attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    //Disable typing/search until supported city is found.
    self.txtSearch.userInteractionEnabled = NO;
    [self.txtSearch setBackgroundColor:[UIColor grayColor]];
    
    //Responders to Textfields
    self.txtSearch.delegate = self;
    
     //Initialize autocomplete table
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 85, 300, 200) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    self.autocompleteTableView.layer.borderWidth = 2;
    self.autocompleteTableView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view addSubview:autocompleteTableView];
    
    //allow banner ads
    self.canDisplayBannerAds = YES;
}


-(void) refreshUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Initialize the user deviceID and if geoloction city is supported.
    if([defaults objectForKey:@"deviceID"] == nil) {
        [defaults setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceID"];
    }
    
    if([defaults objectForKey:@"userCurrentCityLocationIsSupported"] == nil) {
        [defaults setInteger:1 forKey:@"userCurrentCityLocationIsSupported"];
    }
    [defaults synchronize];
    
    self.deviceID = [defaults stringForKey:@"deviceID"];
    
    if([defaults objectForKey:@"userCurrentCity"] == nil) {
        self.settingCity = -1;
    } else {
        self.settingCity = [defaults integerForKey:@"userCurrentCity"];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtSearch resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txtSearch resignFirstResponder];
    return NO;
}

- (NSString*) IsUserCurrentCitySupported:(NSString*)currentCity
{
    NSString *returnCity;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([currentCity isEqualToString:@"New York"]) {
        [defaults setInteger:1 forKey:@"userCurrentCityLocationIsSupported"];
        returnCity = currentCity;
    } else if ([currentCity isEqualToString:@"Chicago"]) {
        [defaults setInteger:1 forKey:@"userCurrentCityLocationIsSupported"];
        returnCity = currentCity;
    } else if ([_userCity isEqualToString:@"San Francisco"]) {
        [defaults setInteger:1 forKey:@"userCurrentCityLocationIsSupported"];
        returnCity = currentCity;
    } else if ([_userCity isEqualToString:@"Las Vegas"]) {
        [defaults setInteger:1 forKey:@"userCurrentCityLocationIsSupported"];
        returnCity = currentCity;
    }
    else
    {
        [defaults setInteger:0 forKey:@"userCurrentCityLocationIsSupported"];
        
        if(self.settingCity == 0){
            returnCity = @"New York";
        }
        else if(self.settingCity == 1){
            returnCity = @"Chicago";
        }
        else if(self.settingCity == 2){
            returnCity = @"San Francisco";
        }
        else if(self.settingCity == 3){
            returnCity = @"Las Vegas";
        } else {
            returnCity = currentCity;
        }
    }
    [defaults synchronize];
    
    return returnCity;
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        _userLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        _userLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error == nil && [placemarks count] > 0)
             {
                 placemark = [placemarks lastObject];
                 _userCity = placemark.locality;

                 if([_userCity length] > 0)
                 {
                     self.txtSearch.userInteractionEnabled = YES;
                     [self.txtSearch setBackgroundColor:[UIColor whiteColor]];
                     
                     //Determine on load if geolocated city is a supported city for later use.
                     NSString *returnCity = [self IsUserCurrentCitySupported:_userCity];
                     _lblCurrentCity.text = returnCity;
                     
                     if ([returnCity isEqualToString:@"New York"]) {
                         cityObject = @"DriverObjectNewYork";
                     } else if ([returnCity isEqualToString:@"Chicago"]) {
                         cityObject = @"DriverObjectChicago";
                     } else if ([returnCity isEqualToString:@"San Francisco"]) {
                         cityObject = @"DriverObjectSanFran";
                     } else if ([returnCity isEqualToString:@"Las Vegas"]) {
                         cityObject = @"DriverObjectLasVegas";
                     } else
                     {
                         //Disable typing/earch until supported city is found.
                         self.txtSearch.userInteractionEnabled = NO;
                         [self.txtSearch setBackgroundColor:[UIColor grayColor]];
                         
                         _lblCityWarning.text = [NSString stringWithFormat:@"Sorry, CabCheck only supports New York, Chicago, San Francisco, and Las Vegas. Hopefully we expand to %@ soon. ", _userCity];
                         
                         cityObject = @"DriverObjectNewYork";
                     }
                     
                 }
                
             } else {
                 NSLog(@"ERROR: %@", error.debugDescription);
             }
         } ];

    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger newTextLength = [textField.text length] - range.length + [string length];
    if (newTextLength > 8) {
        return NO;
    }
    
    if( [substring length] >= 2 && [substring length] < 8) {
        [self searchAutocompleteEntriesWithSubstring:substring];
    }
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    if(autocompleteObjects.count <= 0)
    {
        return 1;
    }
    return autocompleteObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    
    
    if(autocompleteObjects.count <= 0)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        cell.textLabel.text = @"No Results Found";
        return cell;
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    PFObject *taxiObject = [autocompleteObjects objectAtIndex:indexPath.row];
    NSString *driverMedallion = [taxiObject objectForKey:@"driverMedallion"];
    cell.textLabel.text = driverMedallion;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(autocompleteObjects.count > 0) {
        PFObject *taxiObject = [autocompleteObjects objectAtIndex:indexPath.row];
        self.taxiObject = taxiObject;
        [self goPressed];
    }
}


- (IBAction)goPressed {
    
    [self.txtSearch resignFirstResponder];
    autocompleteTableView.hidden = YES;
    
    
    [self performSegueWithIdentifier:@"pushAutoCompleteToResult" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushAutoCompleteToResult"]) {
        DDSearchResultDetailController *destViewController = segue.destinationViewController;
        
        if([self.txtSearch.text length] > 0) {
            destViewController.taxiObject = self.taxiObject;
        }
    }
}



- (IBAction)btnChangeCity:(id)sender
{
    [self performSegueWithIdentifier:@"pushSeqToSettings" sender:sender];
}

-(void)settingsBtnUserClick:(id)sender
{
    [self performSegueWithIdentifier:@"pushSeqToSettings" sender:sender];
}


- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    [autocompleteObjects removeAllObjects];
    
    PFQuery *searchByMedallion = [PFQuery queryWithClassName:cityObject];
    [searchByMedallion whereKey:@"driverMedallion" containsString:substring];
    searchByMedallion.limit=20;
    [searchByMedallion orderByAscending:@"driverMedallion"];
    searchByMedallion.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [searchByMedallion findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
     {
         if (!error)
         {
             for (PFObject *object in results)
             {
                 if (object != nil) {
                     [autocompleteObjects addObject:object];
                 }
             }
             [autocompleteTableView reloadData];
         }
     }];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"kCLAuthorizationStatusDenied");
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        NSLog(@"kCLAuthorizationStatusAuthorized");
    }
    
    if([CLLocationManager locationServicesEnabled]){
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                    message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if([CLLocationManager locationServicesEnabled]){
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                    message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
