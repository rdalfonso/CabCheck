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
    @property NSString *lastCabReviewed;
    @property NSDate *lastCabReviewDate;
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
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    
    [self.reviewComments becomeFirstResponder];
    [self.reviewComments resignFirstResponder];
    
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
}

-(void) getCurrentReview
{

    NSLog(@"deviceID%@", self.deviceID);
    NSLog(@"taxiObject%@", self.taxiObject.objectId);
    
    PFQuery *broadCast = [PFQuery queryWithClassName:@"DriverReviewObject"];
    [broadCast whereKey:@"deviceID" equalTo:@"B6813010-9CB8-4B86-8538-F063F20F83AB"];
    //[broadCast whereKey:@"taxiUniqueID" equalTo:self.taxiObject.objectId];
    [broadCast findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"%lu objects found for deletion.", (unsigned long)objects.count);
            for (PFObject *object in objects)
            {
                NSString *deviceID = [object objectForKey:@"deviceID"];
                NSString *taxiUniqueID =[object objectForKey:@"taxiUniqueID"];
                
                NSString *reviewOverallValue =              [object objectForKey:@"reviewOverall"];
                NSString *reviewCarServiceValue =           [object objectForKey:@"reviewCarService"];
                NSString *reviewDriveSafeValue =            [object objectForKey:@"reviewDriveSafe"];
                NSString *reviewFollowDirectionsValue =     [object objectForKey:@"reviewFollowDirections"];
                NSString *reviewKnowCityValue =             [object objectForKey:@"reviewKnowCity"];
                NSString *reviewHonestFareValue =           [object objectForKey:@"reviewHonestFare"];
                NSString *reviewCourteousValue =            [object objectForKey:@"reviewActCourteous"];
                NSString *reviewCommentsValue =            [object objectForKey:@"reviewComments"];
                
                NSLog(@"deviceID %@", deviceID);
                NSLog(@"taxiUniqueID %@", taxiUniqueID);
                
                NSLog(@"reviewOverall %@", reviewOverallValue);
                NSLog(@"reviewCarService %@", reviewCarServiceValue);
                NSLog(@"reviewDriveSafe %@", reviewDriveSafeValue);
                NSLog(@"reviewFollowDirections %@", reviewFollowDirectionsValue);
                NSLog(@"reviewKnowCity %@", reviewKnowCityValue);
                NSLog(@"reviewHonestFare %@", reviewHonestFareValue);
                NSLog(@"reviewCourteous %@", reviewCourteousValue);
                NSLog(@"reviewComments %@", reviewCommentsValue);
                
                [_reviewOverall setSelectedSegmentIndex:[reviewOverallValue intValue]];
                [_reviewCarService setSelectedSegmentIndex:[reviewCarServiceValue intValue]];
                [_reviewDriveSafe setSelectedSegmentIndex:[reviewDriveSafeValue intValue]];
                [_reviewFollowDirections setSelectedSegmentIndex:[reviewFollowDirectionsValue intValue]];
                [_reviewKnowCity setSelectedSegmentIndex:[reviewKnowCityValue intValue]];
                [_reviewHonestFare setSelectedSegmentIndex:[reviewHonestFareValue intValue]];
                [_reviewCourteous setSelectedSegmentIndex:[reviewCourteousValue intValue]];
                _reviewComments.text = reviewCommentsValue;
                
                [_btnSaveReview setTitle:@"Edit Your Review >" forState:UIControlStateNormal];
               
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.taxiObject.objectId forKey:@"userlastCabReviewed"];
    [defaults setObject:[NSDate date] forKey:@"userLastCabReviewDate"];
    [defaults synchronize];
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
