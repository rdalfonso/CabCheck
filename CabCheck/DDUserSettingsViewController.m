//
//  DDUserSettingsViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/28/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDUserSettingsViewController.h"
#import "DDViewController.h"
#import "DDAppDelegate.h"

@interface DDUserSettingsViewController ()
{
    BOOL _bannerIsVisible;
}
@end

@implementation DDUserSettingsViewController

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
   // NSLog(@"ads not loaded");
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_userCurrentCity setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_userPreferredTransportation setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int userCurrentCity =(int)[defaults integerForKey:@"userCurrentCity"];
    [_userCurrentCity setSelectedSegmentIndex:userCurrentCity];
    
    int userPreferredTransportation  = (int)[defaults integerForKey:@"userPreferredTransportation"];
    [_userPreferredTransportation setSelectedSegmentIndex:userPreferredTransportation];
    
    self.canDisplayBannerAds = YES;
}


- (IBAction)btnSaveUserSettings:(id)sender {
    
    int userCurrentCity = (int)_userCurrentCity.selectedSegmentIndex;
    int userPreferredTransportation = (int)_userPreferredTransportation.selectedSegmentIndex;
    
   // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:userCurrentCity forKey:@"userCurrentCity"];
    [defaults setInteger:userPreferredTransportation forKey:@"userPreferredTransportation"];
    [defaults synchronize];
}

-(IBAction) searchBtnUserClick
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
