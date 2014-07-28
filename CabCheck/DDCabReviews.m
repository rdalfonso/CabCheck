//
//  DDCabReviews.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/28/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabReviews.h"
#import "CabReviewCell.h"

@interface DDCabReviews ()

@end

@implementation DDCabReviews
@synthesize taxiUniqueID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    
    if(self = [super initWithCoder:aDecoder]) {
        self.parseClassName = @"DriverReviewObject";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 20;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *driverRatings = [PFQuery queryWithClassName:@"DriverReviewObject"];
    [driverRatings whereKey:@"taxiUniqueID" equalTo:taxiUniqueID];
    driverRatings.limit = 20;
    
    if (self.pullToRefreshEnabled) {
        driverRatings.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    if (self.objects.count == 0) {
        driverRatings.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [driverRatings orderByAscending:@"createdAt"];
    return driverRatings;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self loadObjects];
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
    
    NSString *uniqueIdentifier = @"taxiReviewCell";
    CabReviewCell *cell = nil;
    
    cell = (CabReviewCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UITableViewCell" owner:nil options:nil];
        
        for (id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[CabReviewCell class]])
            {
                cell = (CabReviewCell *)currentObject;
                break;
            }
        }
    }
    
    NSDate *createdAt = [object createdAt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d, h:mm a"];

    NSString *reviewText = [object objectForKey:@"reviewComments"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.reviewText.text = reviewText;
    cell.reviewDetails.text = @"Bad Driver, Speaks English";
    cell.reviewDate.text = [NSString stringWithFormat:@"Reviewed: %@", [dateFormat stringFromDate:createdAt]];
    
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
