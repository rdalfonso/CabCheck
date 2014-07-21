//
//  DDCabListingController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/21/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCabReviewsViewController.h"
#import <Parse/Parse.h>

@interface DDCabListingController : PFQueryTableViewController
    @property (strong, nonatomic) NSArray *taxis;
    @property NSArray *reviews;
    @property NSString *taxiDriver;
    @property NSString *taxiDriverMedallion;
@end
