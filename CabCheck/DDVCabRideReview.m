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

int reviewOverallValue;
int reviewCarServiceValue;
int reviewDriveSafeValue;
int reviewFollowDirectionsValue;
int reviewKnowCityValue;
int reviewCourteousValue;
int reviewHonestFareValue;
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
    
    [self refreshUserDefaults];
    
    // Do any additional setup after loading the view.
    [self.reviewComments becomeFirstResponder];
    [self.reviewComments resignFirstResponder];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
}


- (IBAction)btnSaveReview:(id)sender {
    
    
    NSLog(@"btnSaveReview");
    
    reviewOverallValue = (int)_reviewOverall.selectedSegmentIndex;
    NSLog(@"reviewOverall %d", reviewOverallValue);
    
    reviewCarServiceValue = (int)_reviewCarService.selectedSegmentIndex;
    NSLog(@"reviewCarService %d", reviewCarServiceValue);
    
    reviewDriveSafeValue = (int)_reviewDriveSafe.selectedSegmentIndex;
    NSLog(@"reviewDriveSafe %d", reviewDriveSafeValue);
    
    reviewFollowDirectionsValue = (int)_reviewFollowDirections.selectedSegmentIndex;
    NSLog(@"reviewFollowDirections %d", reviewFollowDirectionsValue);
    
    reviewKnowCityValue = (int)_reviewKnowCity.selectedSegmentIndex;
    NSLog(@"reviewKnowCity %d", reviewKnowCityValue);
    
    reviewHonestFareValue = (int)_reviewHonestFare.selectedSegmentIndex;
    NSLog(@"reviewHonestFare %d", reviewHonestFareValue);
    
    reviewCourteousValue = (int)_reviewCourteous.selectedSegmentIndex;
    NSLog(@"reviewCourteous %d", reviewCourteousValue);
    
    reviewComments = _reviewComments.text;
    NSLog(@"reviewComments %@", reviewComments);
    
    NSLog(@"self.deviceID %@", self.deviceID);
    
    PFObject *reviewCab = [PFObject objectWithClassName:@"DriverReviewObject"];
    reviewCab[@"deviceID"] =        self.deviceID;
    reviewCab[@"reviewOverall"] =           [NSString stringWithFormat:@"%d",reviewOverallValue];
    reviewCab[@"reviewCarService"] =        [NSString stringWithFormat:@"%d",reviewCarServiceValue];
    reviewCab[@"reviewDriveSafe"] =         [NSString stringWithFormat:@"%d",reviewDriveSafeValue];
    reviewCab[@"reviewFollowDirections"] =  [NSString stringWithFormat:@"%d",reviewFollowDirectionsValue];
    reviewCab[@"reviewKnowCity"] =          [NSString stringWithFormat:@"%d",reviewKnowCityValue];
    reviewCab[@"reviewHonestFare"] =        [NSString stringWithFormat:@"%d",reviewHonestFareValue];
    reviewCab[@"reviewActCourteous"] =       [NSString stringWithFormat:@"%d",reviewCourteousValue];
    reviewCab[@"reviewComments"] =       reviewComments;
    
    [reviewCab saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSString *rvObjectId = [reviewCab objectId];
            NSLog(@" Saved bcObjectId %@", rvObjectId);
        } else {
            NSLog(@"%@", error);
        }
    }];
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
