//
//  DDVCabRideReview.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/26/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDVCabRideReview.h"
#import "DDSearchResultDetailController.h"
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

-(IBAction) searchBtnUserClick
{}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshUserDefaults];
    
     //Front-end control manipulation
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtnUserClick:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    if ([self.reviewComments respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.reviewComments.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Give feedback on this cab ride." attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    
    [self.reviewComments becomeFirstResponder];
    [self.reviewComments resignFirstResponder];
}

-(void)searchBtnUserClick:(id)sender
{
    NSLog(@"\n Search pressed");
    
    [self performSegueWithIdentifier:@"seqPushToSearchController" sender:sender];
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
    reviewCab[@"taxiUniqueID"] =       self.taxiObject.objectId;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue.identifier: %@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"pushSeqPostReviewToDetail"]) {
        DDSearchResultDetailController *destViewController = segue.destinationViewController;
        
        if([self.taxiObject.objectId length] > 0) {
            NSLog(@"self.taxiObject: %@", self.taxiObject);
            destViewController.taxiObject = self.taxiObject;
        }
    }
    
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
