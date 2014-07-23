//
//  DDCabSearchResultsViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/22/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabSearchResultsViewController.h"

@interface DDCabSearchResultsViewController()  <UISearchDisplayDelegate, UISearchBarDelegate> {
    
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end


@implementation DDCabSearchResultsViewController

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
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
    
    self.searchResults = [NSMutableArray array];
    
   // [self.searchBar becomeFirstResponder];
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"DriverObject"];
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"driver"];
    
    return query;
}


- (void)filterResults:(NSString *)searchTerm {
    
    [self.searchResults removeAllObjects];
    //[self.searchBar resignFirstResponder];
    
    PFQuery *query = [PFQuery queryWithClassName: @"DriverObject"];
    query.limit = 5;
    [query whereKey:@"licenseNumber" containsString:searchTerm];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            long qCount = (unsigned long)results.count;
            NSLog(@"%@ %ld", results, qCount);
            [self.searchResults addObjectsFromArray:results];
            [self loadObjects];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    //NSArray *results  = [query findObjects];
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
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

- (void)configureSearchResult:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    cell.textLabel.text = [object objectForKey:@"driver"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Type not sr: %@", [object objectForKey:@"driverType"]];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"taxiCell";
    
    //Custom Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    if ([self.searchResults count] != 0) {
        
        PFObject *object = [PFObject objectWithClassName:@"DriverObject"];
        object = [self.searchResults objectAtIndex:indexPath.row];
        [self configureSearchResult:cell atIndexPath:indexPath object:object];
    }
    
    cell.textLabel.text = [object objectForKey:@"driver"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Type not sr: %@", [object objectForKey:@"driverType"]];
    
    return cell;
    
    /*
    NSString *uniqueIdentifier = @"taxiCell";
    UITableViewCell *cell = nil;
    
    cell = (UITableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UITableViewCell" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (UITableViewCell *)currentObject;
                break;
            }
        }
    }
    
    
    if (tableView != self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [object objectForKey:@"driver"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Type not sr: %@", [object objectForKey:@"driverType"]];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        cell.textLabel.text = [object objectForKey:@"driver"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Type IS sr: %@", [object objectForKey:@"driverType"]];
    }
    return cell;
     */
    
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
