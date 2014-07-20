//
//  DDSearchResultsController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/20/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDSearchResultsController.h"
#import <Parse/Parse.h>

@interface DDSearchResultsController ()

@end

@implementation DDSearchResultsController

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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
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

- (IBAction)btnSearch:(id)sender {
    

     NSLog(@"qCounting: %@ ", _txtSearchString.text);
     
     PFQuery *cabbies = [PFQuery queryWithClassName:@"DriverObject"];
     [cabbies whereKey:@"dmvLicensePlate" equalTo:_txtSearchString.text];
     [cabbies whereKey:@"driver" equalTo:_txtSearchString.text];
     [cabbies whereKey:@"dmvLicensePlate" equalTo:_txtSearchString.text];
     [cabbies setLimit:20];
     [cabbies orderByDescending:@"createdAt"];
     
     [cabbies findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     if (!error) {
     long qCount = (unsigned long)objects.count;
     NSLog(@"qCount: %ld ", qCount);
     } else {
     // Log details of the failure
     NSLog(@"Error: %@ %@", error, [error userInfo]);
     }
     }];
  
    
}
@end
