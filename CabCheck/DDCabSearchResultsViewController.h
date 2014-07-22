//
//  DDCabSearchResultsViewController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/22/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Parse/Parse.h>

@interface DDCabSearchResultsViewController : PFQueryTableViewController<UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarTaxis;

@property (strong,nonatomic) NSMutableArray *filteredTaxiArray;
@end
