//
//  DDSearchResultDetailController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/24/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDSearchResultDetailController.h"

@interface DDSearchResultDetailController ()

@end

@implementation DDSearchResultDetailController
@synthesize taxiUniqueID;

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
    // Do any additional setup after loading the view.
     NSLog(@"taxiUniqueID: %@", taxiUniqueID);
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    PFQuery *searchDriver = [PFQuery queryWithClassName:@"DriverObject"];
    [searchDriver whereKey:@"objectId" containsString:taxiUniqueID];
    searchDriver.limit = 20;
    [searchDriver findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            for (PFObject *object in results) {
                _driverName.text = [object objectForKey:@"driverIsGoodDriver"];
                _driverMedallion.text = [object objectForKey:@"driverSpeaksEnglish"];
                _driverLicense.text = [object objectForKey:@"driverIsFairMeter"];
                _driverCabMakeModel.text = [object objectForKey:@"driverKnowsCity"];
                _driverVIN.text = [object objectForKey:@"driverIsCrazy"];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    _driverIsSafeDriver.text = @"YES";
    _driverSpeaksEnglish.text = @"YES";
    _driverIsHonest.text = @"YES";
    _driverKnowsDirections.text = @"YES";
    _driverIsCourteous.text = @"YES";
    /*
    PFQuery *driverRatings = [PFQuery queryWithClassName:@"DriverReviewObject"];
    [driverRatings whereKey:@"driverObjectID" containsString:@"b7KSFF9EBG"];
    [driverRatings findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            for (PFObject *object in results) {
                _driverIsSafeDriver.text = @"YES"; //[object objectForKey:@"driverIsGoodDriver"];
                _driverSpeaksEnglish.text = @"YES"; //[object objectForKey:@"driverSpeaksEnglish"];
                _driverIsHonest.text = @"YES"; //[object objectForKey:@"driverIsFairMeter"];
                _driverKnowsDirections.text = @"YES"; //[object objectForKey:@"driverKnowsCity"];
                _driverIsCourteous.text = @"YES"; //[object objectForKey:@"driverIsCrazy"];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
     */
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
