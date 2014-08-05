//
//  DDCabRideReview.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/26/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabRideReview.h"
#import "DDSearchResultDetailController.h"
#import <Parse/Parse.h>

@interface DDCabRideReview ()
    @property NSString *deviceID;
    @property NSString *lastCabReviewed;
    @property NSDate *lastCabReviewDate;
@end

@implementation DDCabRideReview

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshUserDefaults];
    [self getCurrentReview];
    
     //Front-end control manipulation
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    if ([self.reviewComments respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.reviewComments.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Give feedback on this cab ride." attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    [self.reviewComments becomeFirstResponder];
    [self.reviewComments resignFirstResponder];
    self.reviewComments.delegate = self;
    
    //Set Title
    if(self.taxiObject != nil)
    {
        NSString *driverMedallion = [self.taxiObject objectForKey:@"driverMedallion"];
        if([driverMedallion length] > 0) {
            _lblReviewHeader.text = [NSString stringWithFormat:@"Driver Review: %@",driverMedallion];
        } else {
            _lblReviewHeader.text = @"Driver Review";
        }
    }
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self action:@selector(searchBtnUserClick:)];
    
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    [self.navigationItem setHidesBackButton:NO animated:YES];
}

-(void)searchBtnUserClick:(id)sender
{
    [self performSegueWithIdentifier:@"seqPushToSearchController" sender:sender];
}


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 60 || returnKey;
}

-(void) refreshUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"deviceID"] == nil) {
        self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        self.deviceID = [defaults stringForKey:@"deviceID"];
    }
    
    if([defaults objectForKey:@"userlastCabReviewed"] != nil) {
        self.lastCabReviewed = [defaults stringForKey:@"userlastCabReviewed"];
    }
    
    if([defaults objectForKey:@"userLastCabReviewDate"] != nil) {
        self.lastCabReviewDate = [defaults objectForKey:@"userLastCabReviewDate"];
    }
    
    //NSLog(@"deviceID: %@", self.deviceID);
}

-(void) getCurrentReview
{

    PFQuery *broadCast = [PFQuery queryWithClassName:@"DriverReviewObject"];
    [broadCast whereKey:@"deviceID" equalTo:self.deviceID];
    [broadCast whereKey:@"taxiUniqueID" equalTo:self.taxiObject.objectId];
    [broadCast getFirstObjectInBackgroundWithBlock:^(PFObject *reviewObject, NSError *error) {
        if (!error)
        {
            self.reviewObject = reviewObject;
            NSString *reviewOverallValue =              [reviewObject objectForKey:@"reviewOverall"];
            NSString *reviewDriveSafeValue =            [reviewObject objectForKey:@"reviewDriveSafe"];
            NSString *reviewFollowDirectionsValue =     [reviewObject objectForKey:@"reviewFollowDirections"];
            NSString *reviewKnowCityValue =             [reviewObject objectForKey:@"reviewKnowCity"];
            NSString *reviewHonestFareValue =           [reviewObject objectForKey:@"reviewHonestFare"];
            NSString *reviewCourteousValue =            [reviewObject objectForKey:@"reviewActCourteous"];
            NSString *reviewCommentsValue =             [reviewObject objectForKey:@"reviewComments"];
            
            [_reviewOverall setSelectedSegmentIndex:[reviewOverallValue intValue]];
            [_reviewDriveSafe setSelectedSegmentIndex:[reviewDriveSafeValue intValue]];
            [_reviewFollowDirections setSelectedSegmentIndex:[reviewFollowDirectionsValue intValue]];
            [_reviewKnowCity setSelectedSegmentIndex:[reviewKnowCityValue intValue]];
            [_reviewHonestFare setSelectedSegmentIndex:[reviewHonestFareValue intValue]];
            [_reviewCourteous setSelectedSegmentIndex:[reviewCourteousValue intValue]];
            _reviewComments.text = reviewCommentsValue;
            
            NSDate *reviewDate = reviewObject.updatedAt;
            NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
            [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [theDateFormatter setDateFormat:@"EEE, MMM d, h:mm a"];
            _lblReviewDate.text = [NSString stringWithFormat:@"You reviewed this cab on %@", [theDateFormatter stringFromDate:reviewDate]];
            
            [_btnSaveReview setTitle:@"Edit Your Review" forState:UIControlStateNormal];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (IBAction)btnSaveReview:(id)sender {
    
    reviewOverallValue = (int)_reviewOverall.selectedSegmentIndex;
    reviewCarServiceValue = 0;
    reviewDriveSafeValue = (int)_reviewDriveSafe.selectedSegmentIndex;
    reviewFollowDirectionsValue = (int)_reviewFollowDirections.selectedSegmentIndex;
    reviewKnowCityValue = (int)_reviewKnowCity.selectedSegmentIndex;
    reviewHonestFareValue = (int)_reviewHonestFare.selectedSegmentIndex;
    reviewCourteousValue = (int)_reviewCourteous.selectedSegmentIndex;
    reviewComments = _reviewComments.text;
    
    if(self.reviewObject == nil){
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
    } else
    {
        self.reviewObject[@"reviewOverall"] =           [NSString stringWithFormat:@"%d",reviewOverallValue];
        self.reviewObject[@"reviewCarService"] =        [NSString stringWithFormat:@"%d",reviewCarServiceValue];
        self.reviewObject[@"reviewDriveSafe"] =         [NSString stringWithFormat:@"%d",reviewDriveSafeValue];
        self.reviewObject[@"reviewFollowDirections"] =  [NSString stringWithFormat:@"%d",reviewFollowDirectionsValue];
        self.reviewObject[@"reviewKnowCity"] =          [NSString stringWithFormat:@"%d",reviewKnowCityValue];
        self.reviewObject[@"reviewHonestFare"] =        [NSString stringWithFormat:@"%d",reviewHonestFareValue];
        self.reviewObject[@"reviewActCourteous"] =       [NSString stringWithFormat:@"%d",reviewCourteousValue];
        self.reviewObject[@"reviewComments"] =       reviewComments;
        
        [self.reviewObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@" Updated bcObjectId %@", self.reviewObject.objectId);
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.taxiObject.objectId forKey:@"userlastCabReviewed"];
    [defaults setObject:[NSDate date] forKey:@"userLastCabReviewDate"];
    [defaults synchronize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushSeqPostReviewToDetail"]) {
        DDSearchResultDetailController *destViewController = segue.destinationViewController;
        
        if([self.taxiObject.objectId length] > 0) {
            destViewController.taxiObject = self.taxiObject;
        }
    }
    
}

-(IBAction) searchBtnUserClick
{
    
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
