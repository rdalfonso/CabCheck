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
        self.objectsPerPage = 20;
    }
    return self;
}

/*

- (PFQuery *)queryForTable {
    
    NSLog(@"globalSearchTerm queryForTable: %@",globalSearchTerm);
    
    PFQuery *searchByMedallion = [PFQuery queryWithClassName:@"DriverObject"];
    [searchByMedallion whereKey:@"driverName" containsString:globalSearchTerm];
    
    PFQuery *searchByDMVLicense = [PFQuery queryWithClassName:@"DriverObject"];
    [searchByDMVLicense whereKey:@"driverMedallion" containsString:globalSearchTerm];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[searchByMedallion,searchByDMVLicense]];
    query.limit = 5;
    
    
    if (self.pullToRefreshEnabled) {
       query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    if (self.objects.count == 0) {
       query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    return query;
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [self loadObjects];
}

-(void)setSearchTerm:(NSString *)searchTerm
{
    globalSearchTerm = searchTerm;
}



- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
   self.searchBar.placeholder = @"Enter medallion number or driver name.";
   [self.searchBar setShowsCancelButton:NO animated:NO];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    self.searchResults = [NSMutableArray array];

    self.searchController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
    
    [self.searchBar resignFirstResponder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    if([globalSearchTerm length] > 0){
        self.searchBar.text = globalSearchTerm;
    }
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    
}

- (void)dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}

- (void)filterResults:(NSString *)searchTerm {
    
    NSLog(@"globalSearchTerm filterResults %@", globalSearchTerm);
    [self.searchResults removeAllObjects];
    
    PFQuery *searchByMedallion = [PFQuery queryWithClassName:@"DriverObject"];
    [searchByMedallion whereKey:@"driverName" containsString:searchTerm];
    
    PFQuery *searchByDMVLicense = [PFQuery queryWithClassName:@"DriverObject"];
    [searchByDMVLicense whereKey:@"driverMedallion" containsString:searchTerm];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[searchByMedallion,searchByDMVLicense]];
    query.limit = 20;
    
    NSArray *results  = [query findObjects];
    [self.searchResults addObjectsFromArray:results];
    NSLog(@"filter %lu", (unsigned long)results.count);

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
        NSLog(@"self.objects.count: %lu", (unsigned long)self.objects.count);
        return self.objects.count;
        
    } else {
        NSLog(@"searchResults: %lu", (unsigned long)self.searchResults.count);
        return self.searchResults.count;
    }
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        
        cell.driverName.text = [object objectForKey:@"driverName"];
        cell.driverMedallion.text = [object objectForKey:@"driverMedallion"];
        
        NSMutableString *make = [NSMutableString stringWithString:@""];
        NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
        if([driverCabMake length] > 0) {
            [make appendString:[object objectForKey:@"driverCabMake"]];
        }
        [make appendString: @" "];
        NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
        if([driverCabModel length] > 0) {
            [make appendString:[object objectForKey:@"driverCabModel"]];
        }
        cell.driverLicense.text = make;
        cell.driverCabMakeModel.text = [object objectForKey:@"driverCabYear"];
        cell.driverVIN.text = [object objectForKey:@"driverVin"];
        
        /*
        NSString *driverObjectId = object.objectId;
        PFQuery *driverRatings = [PFQuery queryWithClassName:@"DriverReviewObject"];
        [driverRatings whereKey:@"driverObjectID" containsString:@"b7KSFF9EBG"];
        [driverRatings findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            if (!error) {
                for (PFObject *object in results) {
                    cell.lblSafeDriver.text = [object objectForKey:@"driverIsGoodDriver"];
                    cell.lblSpeaksEnglish.text = [object objectForKey:@"driverSpeaksEnglish"];
                    cell.lblHonestFare.text = [object objectForKey:@"driverIsFairMeter"];
                    cell.lblKnowsDirections.text = [object objectForKey:@"driverKnowsCity"];
                    cell.lblIsCourteous.text = [object objectForKey:@"driverIsCrazy"];
                }
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        */
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
        [make appendString: @" "];
        NSString *driverCabModel = [object objectForKey:@"driverCabModel"];
        if([driverCabModel length] > 0) {
            [make appendString: [object objectForKey:@"driverCabModel"]];
        }
        cell.driverLicense.text = make;
        cell.driverCabMakeModel.text = [object objectForKey:@"driverCabYear"];
        cell.driverVIN.text = [object objectForKey:@"driverVin"];
        
        /*
         NSString *driverObjectId = object.objectId;
         PFQuery *driverRatings = [PFQuery queryWithClassName:@"DriverReviewObject"];
         [driverRatings whereKey:@"driverObjectID" containsString:@"b7KSFF9EBG"];
         [driverRatings findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
         if (!error) {
         for (PFObject *object in results) {
         cell.lblSafeDriver.text = [object objectForKey:@"driverIsGoodDriver"];
         cell.lblSpeaksEnglish.text = [object objectForKey:@"driverSpeaksEnglish"];
         cell.lblHonestFare.text = [object objectForKey:@"driverIsFairMeter"];
         cell.lblKnowsDirections.text = [object objectForKey:@"driverKnowsCity"];
         cell.lblIsCourteous.text = [object objectForKey:@"driverIsCrazy"];
         }
         } else {
         NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         }];
         */
    }
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
