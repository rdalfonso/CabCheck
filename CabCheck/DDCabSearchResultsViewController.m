//
//  DDCabSearchResultsViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/22/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabSearchResultsViewController.h"
#import "DDSearchResultDetailController.h"
#import "CabSearchResultCell.h"

@interface DDCabSearchResultsViewController() <UISearchDisplayDelegate, UISearchBarDelegate> {
    
}

@property (nonatomic, strong) UILabel *CabCheckHeader;
@property (nonatomic, strong) UILabel *CabCheckSubHeader;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end


@interface DDCabSearchResultsViewController ()

@end


@implementation DDCabSearchResultsViewController
@synthesize globalSearchTerm;

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

- (void)viewWillAppear:(BOOL)animated
{
    [self loadObjects];
}

-(void)setSearchTerm:(NSString *)searchTerm
{
    globalSearchTerm = searchTerm;
    NSLog(@"searchTerm frm main %@", globalSearchTerm);
    self.searchBar.text = globalSearchTerm;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    self.searchBar.placeholder = @"Enter medallion number or driver name.";
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    if([globalSearchTerm length] > 0) {
        self.searchBar.text = globalSearchTerm;
    }
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    self.searchResults = [NSMutableArray array];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
    self.searchController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
}

- (void)filterResults:(NSString *)searchTerm {
    
    [self.searchResults removeAllObjects];
    
    PFQuery *searchByMedallion = [PFQuery queryWithClassName:@"DriverObject"];
    [searchByMedallion whereKey:@"driverName" containsString:searchTerm];
    
    PFQuery *searchByDMVLicense = [PFQuery queryWithClassName:@"DriverObject"];
    [searchByDMVLicense whereKey:@"driverMedallion" containsString:searchTerm];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[searchByMedallion,searchByDMVLicense]];
    query.limit = 5;
    
    NSArray *results  = [query findObjects];
    [self.searchResults addObjectsFromArray:results];
    NSLog(@"%u", results.count);
  
    
    /*
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSLog(@"%u", results.count);
            [self.searchResults addObjectsFromArray:results];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    */

    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Author
    PFObject *taxiObject = [self.searchResults objectAtIndex:indexPath.row];
    
    NSLog(@"taxi object: %@", taxiObject);
    self.taxi =  taxiObject.objectId;
    [self performSegueWithIdentifier:@"pushSeqResultToDetails" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"pushSeqResultToDetails"]) {
        DDSearchResultDetailController *destViewController = segue.destinationViewController;
        destViewController.taxiUniqueID = self.taxi;
    }
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    if([searchString length] > 2)
    {
        [self filterResults:searchString];
        return YES;
    } else {
        return NO;
    }
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.objects.count;
        
    } else {
        return self.searchResults.count;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectedBackgroundView.backgroundColor=[UIColor redColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    NSString *uniqueIdentifier = @"taxiCell";
    CabSearchResultCell *cell = nil;
    
    cell = (CabSearchResultCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UITableViewCell" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[CabSearchResultCell class]])
            {
                cell = (CabSearchResultCell *)currentObject;
                break;
            }
        }
    }
    
    cell.selectedBackgroundView.backgroundColor=[UIColor redColor];
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        
        cell.driverName.text = [object objectForKey:@"driverName"];
        cell.driverMedallion.text = [object objectForKey:@"driverMedallion"];
        
        NSMutableString *make = [NSMutableString stringWithString:@""];
        NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
        if([driverCabMake length] > 0) {
            [make appendString:[object objectForKey:@"driverCabMake"]];
        }
        NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
        if([driverCabModel length] > 0) {
            [make appendString:[object objectForKey:@"driverCabModel"]];
        }
        cell.driverLicense.text = make;
        cell.driverCabMakeModel.text = [object objectForKey:@"driverCabYear"];
        
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        PFObject *object = [self.searchResults objectAtIndex:indexPath.row];
        cell.driverName.text = [object objectForKey:@"driverName"];
        cell.driverMedallion.text = [object objectForKey:@"driverMedallion"];
        NSMutableString *make = [NSMutableString stringWithString:@""];
        NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
        if([driverCabMake length] > 0) {
            [make appendString:[object objectForKey:@"driverCabMake"]];
        }
        NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
        if([driverCabModel length] > 0) {
            [make appendString:[object objectForKey:@"driverCabModel"]];
        }
        cell.driverLicense.text = make;
        cell.driverCabMakeModel.text = [object objectForKey:@"driverCabYear"];
    }
    return cell;
    
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
