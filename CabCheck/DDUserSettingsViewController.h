//
//  DDUserSettingsViewController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/28/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDUserSettingsViewController : UIViewController<UITextFieldDelegate>
{}
@property (strong, nonatomic) IBOutlet UITextField *userHomeCity;
@property (strong, nonatomic) IBOutlet UISegmentedControl *userTaxiPrefer;
@property (strong, nonatomic) IBOutlet UITextField *userSMSContact1;
@property (strong, nonatomic) IBOutlet UITextField *userSMSContact2;
@property (strong, nonatomic) IBOutlet UITextField *userSMSContact3;
- (IBAction)btnSaveUserSettings:(id)sender;

@end
