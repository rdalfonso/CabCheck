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
@property (strong, nonatomic) IBOutlet UILabel *lblSearchResults;
@property NSString *taxi;
@property (nonatomic, strong) PFObject *taxiObject;
@end
