//
//  DDCabListingController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/21/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCabListingController : UITableViewController
@property (strong, nonatomic) NSArray *taxis;

@property NSArray *reviews;
@property NSString *taxiDriver;
@property NSString *taxiDriverMedallion;
@end
