//
//  DDCabSearchResultsViewController.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/22/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabSearchResultsViewController.h"
#import "DDSearchResultDetailController.h"
#import "CabCheckSearchViewController.h"
#import "CabSearchResultCell.h"


@interface DDCabSearchResultsViewController ()
@end

@implementation DDCabSearchResultsViewController
@synthesize globalSearchTerm;

- (id)initWithCoder:(NSCoder*)aDecoder
{
    
    if(self = [super initWithCoder:aDecoder]) {
        self.parseClassName = @"DriverCompleteObject";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
    }
    return self;
}

- (PFQuery *)queryForTable {
    
    PFQuery *searchByName = [PFQuery queryWithClassName:@"DriverObjectComplete"];
    [searchByName whereKey:@"driverName" containsString:globalSearchTerm];
    
    PFQuery *searchByMedallion = [PFQuery queryWithClassName:@"DriverObjectComplete"];
    [searchByMedallion whereKey:@"driverMedallion" containsString:globalSearchTerm];
    
    PFQuery *searchByDMVLicense = [PFQuery queryWithClassName:@"DriverObjectComplete"];
    [searchByDMVLicense whereKey:@"driverDMVLicense" containsString:globalSearchTerm];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[searchByName, searchByMedallion,searchByDMVLicense]];
    query.limit = 20;
    
    if (self.pullToRefreshEnabled) {
       query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    if (self.objects.count == 0) {
       query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    return query;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self loadObjects];
}

-(void)setSearchTerm:(NSString *)searchTerm
{
    globalSearchTerm = searchTerm;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stop-light.jpg"]];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
       target:self action:@selector(searchBtnUserClick:)];
    
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [self.navigationItem setHidesBackButton:NO animated:YES];
}


-(void)searchBtnUserClick:(id)sender
{
    [self performSegueWithIdentifier:@"seqPushToSearchController" sender:sender];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    NSString *uniqueIdentifier = @"taxiCell";
    CabSearchResultCell *cell = nil;
    
    cell = (CabSearchResultCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    /*
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
    */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *driverType = [object objectForKey:@"driverType"];
    NSString *driverName = [object objectForKey:@"driverName"];
    NSString *driverMedallion = [object objectForKey:@"driverMedallion"];
    NSString *driverDMVLicense = [object objectForKey:@"driverDMVLicense"];
    if([driverDMVLicense length] <= 0){
        driverDMVLicense = @"N/A";
    }
    NSString *driverVIN = [object objectForKey:@"driverVIN"];
    NSString *driverCabMake =[object objectForKey:@"driverCabMake"];
    NSString *driverCabModel =[object objectForKey:@"driverCabModel"];
    NSString *driverCabYear =[object objectForKey:@"driverCabYear"];
    
    cell.driverName.text = driverName;
    
    if ([driverType isEqualToString:@"Y"])
    {
        cell.driverType.text = @"Yellow Medallion Taxi";
        cell.driverVinLabel.text = @"VIN:";
        cell.driverVIN.text = driverVIN;
        cell.driverLicense.text = [NSString stringWithFormat:@"%@ %@ %@", driverCabMake, driverCabModel, driverCabYear];
        
    } else if ([driverType isEqualToString:@"L"])
    {
        cell.driverType.text = @"TLC Street Hail Livery";
        cell.driverVinLabel.text = @"License:";
        cell.driverVIN.text = driverDMVLicense;
        cell.driverLicense.text = @"Livery Sedan";
    }
    
    if([driverMedallion length] > 0) {
        cell.driverMedallion.text = driverMedallion;
    }
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    PFObject *taxiObject = [self.objects objectAtIndex:indexPath.row];
    self.taxiObject = taxiObject;
    
    // Perform Segue
    [self performSegueWithIdentifier:@"pushSeqResultsToDetail" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushSeqResultsToDetail"]) {
        DDSearchResultDetailController *destViewController = segue.destinationViewController;
        
        if([self.taxiObject.objectId length] > 0) {
            destViewController.taxiObject = self.taxiObject;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
