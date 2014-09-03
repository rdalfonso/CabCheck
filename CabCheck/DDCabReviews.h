//
//  DDCabReviews.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/28/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Parse/Parse.h>
#import "CabObject.h"
@interface DDCabReviews : PFQueryTableViewController <UITableViewDelegate>

@property NSString *taxiUniqueID;
@property (strong, nonatomic) IBOutlet UILabel *lblCabReviewsHeader;
@property (nonatomic, strong) CabObject *taxiObject;
@end
