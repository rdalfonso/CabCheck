//
//  DDCabSearchResultsViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/22/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabSearchResultsViewController.h"

@interface DDCabSearchResultsViewController ()

@end


@implementation DDCabSearchResultsViewController
@synthesize filteredTaxiArray;
@synthesize searchBarTaxis;

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.parseClassName = @"DriverObject";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 5;
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResults = [NSMutableArray array];

    
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"driver"];
    
    return query;
}


-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
     NSLog(@"filterContentForSearchText searchText: %@", searchText);
   
}

- (void)filterResults:(NSString *)searchTerm {
    [self.searchResults removeAllObjects];
    NSLog(@"searchTerm: %@", searchTerm);
    NSLog(@"parseClassName: %@", self.parseClassName);
    
    PFQuery *query = [PFQuery queryWithClassName: self.parseClassName];
    query.limit = 10;
    NSArray *results  = [query findObjects];
    
    
    NSLog(@"count: %lu", (unsigned long)results.count);
    
    [self.searchResults addObjectsFromArray:results];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.objects.count;
    } else {
        return self.searchResults.count ;
    }
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    
     NSLog(@"searchDisplayController shouldReloadTableForSearchScope searchText: %ld", (long)searchOption);
    
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"driver"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Type: %@",
                                 [object objectForKey:@"driverType"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
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
