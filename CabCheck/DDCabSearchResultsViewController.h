//
//  DDCabSearchResultsViewController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/22/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Parse/Parse.h>

@interface DDCabSearchResultsViewController : PFQueryTableViewController <UITableViewDelegate>
@property (nonatomic, strong) NSString *globalSearchTerm;
@property NSString *taxi;
@end
