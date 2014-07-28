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
        self.lblSearchResults.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (PFQuery *)queryForTable {
    
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
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return self.objects.count;
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
