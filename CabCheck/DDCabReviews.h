//
//  DDCabReviews.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/28/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Parse/Parse.h>

@interface DDCabReviews : PFQueryTableViewController <UITableViewDelegate>

@property NSString *taxiUniqueID;
@property (nonatomic, strong) PFObject *taxiObject;
@end
