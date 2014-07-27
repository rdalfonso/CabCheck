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


-(void)setUniqueTaxiID:(NSString *)uniqueTaxiID
{
    taxiUniqueID = uniqueTaxiID;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"taxiUniqueID: %@", taxiUniqueID);
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    PFQuery *searchDriver = [PFQuery queryWithClassName:@"DriverObject"];
    [searchDriver whereKey:@"objectId" equalTo:taxiUniqueID];
    searchDriver.limit = 1;
    [searchDriver findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            
            long qCount = (unsigned long)results.count;
            NSLog(@"qCount %ld", qCount);
            
            for (PFObject *object in results) {
                
                _driverName.text = [object objectForKey:@"driverName"];
                _driverMedallion.text = [object objectForKey:@"driverMedallion"];
                
                NSMutableString *make = [NSMutableString stringWithString:@""];
                NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
                if([driverCabMake length] > 0) {
                    [make appendString:[object objectForKey:@"driverCabMake"]];
                }
                [make appendString: @" "];
                NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
                if([driverCabModel length] > 0) {
                    [make appendString:[object objectForKey:@"driverCabModel"]];
                }
                _driverLicense.text = make;
                _driverCabMakeModel.text = [object objectForKey:@"driverCabYear"];
                _driverVIN.text = [object objectForKey:@"driverVin"];
                
                
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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
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

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSMS:(NSString*)file {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@"2019686897"];
    NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", file];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
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

- (IBAction)btnSendData:(id)sender {
    
    NSString *selectedFile = @"testing";
    [self showSMS:selectedFile];
}
@end
