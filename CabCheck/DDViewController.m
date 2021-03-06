//
//  DDViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/18/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDViewController.h"
#import "DDSearchResultDetailController.h"
#import "DDAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface DDViewController ()
{
    BOOL _bannerIsVisible;
}
@end

@implementation DDViewController
@synthesize autocompleteObjects;
@synthesize autocompleteTableView;
@synthesize cityObject;
@synthesize dbManager = _dbManager;

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
    
    if (self.txtSearch != nil) {
        self.txtSearch.text = nil;
    }
    
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_UIiAD.superview == nil)
        {
            [self.view addSubview:_UIiAD];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [_UIiAD setAlpha:1];
        [UIView commitAnimations];
        _bannerIsVisible = YES;
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //NSLog(@"ads not loaded");
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [_UIiAD setAlpha:0];
        [UIView commitAnimations];
        _bannerIsVisible = NO;
    }
    
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
    
    NSLog(@"viewDidLoad");
    
    //Get/Set User settings used throughout app.
    [self refreshUserDefaults];
    
    //Initialize CoreLocation
    geocoder = [[CLGeocoder alloc] init];
    
    //Initialize Results
    self.autocompleteObjects = [[NSMutableArray alloc] init];
    
    //Initialize LocationManager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //locationManager.distanceFilter=100.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    // Initialize the dbManager property.
    self.dbManager = [[CabObjectDataBase alloc] initWithDatabaseFilename:@"CabCheck.sqlite"];
    
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
    [defaults synchronize];
    
    self.deviceID = [defaults stringForKey:@"deviceID"];
    
    if([defaults objectForKey:@"userCurrentCity"] == nil) {
        self.settingCity = -1;
        _lblCurrentCity.text = @"New York";
        self.cityObject = @"CabObjectsNewYork";
    } else {
        
        self.settingCity = [defaults integerForKey:@"userCurrentCity"];
        
        if(self.settingCity == 0){
            _lblCurrentCity.text = @"New York";
            self.cityObject = @"CabObjectsNewYork";
        }
        else if(self.settingCity == 1){
            _lblCurrentCity.text = @"Chicago";
            self.cityObject = @"CabObjectsChicago";
        }
        else if(self.settingCity == 2){
            _lblCurrentCity.text = @"San Francisco";
            self.cityObject = @"CabObjectsSanFran";
        }
        else if(self.settingCity == 3){
            _lblCurrentCity.text = @"Las Vegas";
            self.cityObject = @"CabObjectsLasVegas";
        } else {
            _lblCurrentCity.text = @"New York";
            self.cityObject = @"CabObjectsNewYork";
        }
        
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtSearch resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txtSearch resignFirstResponder];
    return NO;
}



- (BOOL) IsUserCurrentCitySupported:(NSString*)currentCity
{
    bool blnSupportedCity;
    
    if ([currentCity isEqualToString:@"New York"]) {
        blnSupportedCity = true;
    } else if ([currentCity isEqualToString:@"Chicago"]) {
        blnSupportedCity = true;
    } else if ([_userCity isEqualToString:@"San Francisco"]) {
        blnSupportedCity = true;
    } else if ([_userCity isEqualToString:@"Las Vegas"]) {
        blnSupportedCity = true;
    }
    else
    {
        blnSupportedCity = false;
    }
    return blnSupportedCity;
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
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
                     if(self.settingCity == -1)
                     {
                         _lblCurrentCity.text = _userCity;
                         bool IsCurrentCitySupported = [self IsUserCurrentCitySupported:_userCity];
                         if(!IsCurrentCitySupported)
                         {
                             self.txtSearch.userInteractionEnabled = NO;
                             [self.txtSearch setBackgroundColor:[UIColor grayColor]];
                             
                             _lblCityWarning.text = [NSString stringWithFormat:@"Sorry, CabCheck only supports New York, Chicago, San Francisco, and Las Vegas. Hopefully we expand to %@ soon. ", _userCity];
                         }
                     }
                 }
                
             } else {
                 NSLog(@"ERROR LOCATION: %@", error.debugDescription);
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
    CabObject *taxiObject = [autocompleteObjects objectAtIndex:indexPath.row];
    NSString *driverMedallion = taxiObject.driverMedallion;
    cell.textLabel.text = driverMedallion;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"touch detection");
    if(autocompleteObjects.count > 0) {
        CabObject *taxiObject = [autocompleteObjects objectAtIndex:indexPath.row];
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
    if(self.dbManager != nil)
    {
        autocompleteObjects = [self.dbManager cabObjectInfos:substring withString:self.cityObject];
    }
    
    [autocompleteTableView reloadData];
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
