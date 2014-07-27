//
//  DDVCabRideReview.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/26/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDVCabRideReview.h"
#import <Parse/Parse.h>

@interface DDVCabRideReview ()
@property NSString *deviceID;
@end

@implementation DDVCabRideReview

int reviewOverall;
int reviewCarService;
int reviewDriveSafe;
int reviewFollowDirections;
int reviewKnowCity;
int reviewCourteous;
int reviewHonestFare;
NSString *reviewComments;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) refreshUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"deviceID"] == nil) {
        self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        self.deviceID = [defaults stringForKey:@"deviceID"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.reviewComments becomeFirstResponder];
    [self.reviewComments resignFirstResponder];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.reviewComments resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.reviewComments resignFirstResponder];
    return NO;
}

- (IBAction)btnSaveReview:(id)sender {
    
    reviewOverall = (int)_reviewOverall.selectedSegmentIndex;
    reviewCarService = (int)_reviewCarService.selectedSegmentIndex;
    reviewDriveSafe = (int)_reviewDriveSafe.selectedSegmentIndex;
    reviewFollowDirections = (int)_reviewFollowDirections.selectedSegmentIndex;
    reviewKnowCity = (int)_reviewKnowCity.selectedSegmentIndex;
    reviewHonestFare = (int)_reviewHonestFare.selectedSegmentIndex;
    reviewCourteous = (int)_reviewActCouteous.selectedSegmentIndex;
    reviewComments = _reviewComments.text;
    
    PFObject *reviewCab = [PFObject objectWithClassName:@"DriverReviewObject"];
    reviewCab[@"deviceID"] =        self.deviceID;
    reviewCab[@"reviewOverall"] =           _reviewOverall;
    reviewCab[@"reviewCarService"] =        _reviewCarService;
    reviewCab[@"reviewDriveSafe"] =         _reviewDriveSafe;
    reviewCab[@"reviewFollowDirections"] =   _reviewFollowDirections;
    reviewCab[@"reviewKnowCity"] =          _reviewKnowCity;
    reviewCab[@"reviewHonestFare"] =        _reviewHonestFare;
    reviewCab[@"reviewActCourteous"] =       0;
    reviewCab[@"reviewComments"] =       _reviewComments;
    
    [reviewCab saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSString *rvObjectId = [reviewCab objectId];
            NSLog(@" Saved bcObjectId %@", rvObjectId);
        } else {
            NSLog(@"%@", error);
        }
    }];
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
