//
//  DDCabRideReview.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/26/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DDCabRideReview : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *reviewOverall;
@property (strong, nonatomic) IBOutlet UISegmentedControl *reviewCarService;
@property (strong, nonatomic) IBOutlet UISegmentedControl *reviewDriveSafe;
@property (strong, nonatomic) IBOutlet UISegmentedControl *reviewFollowDirections;
@property (strong, nonatomic) IBOutlet UISegmentedControl *reviewKnowCity;
@property (strong, nonatomic) IBOutlet UISegmentedControl *reviewHonestFare;
@property (strong, nonatomic) IBOutlet UISegmentedControl *reviewCourteous;

@property (strong, nonatomic) IBOutlet UITextField *reviewComments;

@property (nonatomic, strong) PFObject *taxiObject;
@property (nonatomic, strong) PFObject *reviewObject;

@property (strong, nonatomic) IBOutlet UIButton *btnSaveReview;
@property (strong, nonatomic) IBOutlet UILabel *lblReviewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblReviewDate;

- (IBAction)btnSaveReview:(id)sender;

@end
