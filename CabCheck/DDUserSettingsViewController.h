//
//  DDUserSettingsViewController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/28/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface DDUserSettingsViewController : UIViewController<ADBannerViewDelegate>
{}
@property (strong, nonatomic) ADBannerView *UIiAD;
- (IBAction)btnSaveUserSettings:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *userCurrentCity;
@property (strong, nonatomic) IBOutlet UISegmentedControl *userPreferredTransportation;


@end
