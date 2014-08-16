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
    [driverRatings whereKey:@"taxiUniqueID" equalTo:self.taxiObject.objectId];
    driverRatings.limit = 20;
    
    if (self.pullToRefreshEnabled) {
        driverRatings.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    if (self.objects.count == 0) {
        driverRatings.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [driverRatings orderByDescending:@"createdAt"];
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
    
    NSString *driverMedallion = [self.taxiObject objectForKey:@"driverMedallion"];
    _lblCabReviewsHeader.text = [NSString stringWithFormat:@"  Driver Reviews - %@", driverMedallion];
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

    NSMutableString *reviewTags = [NSMutableString stringWithString:@""];
    NSMutableString *reviewTextFill = [NSMutableString stringWithString:@""];
    
    NSString *reviewText = [object objectForKey:@"reviewComments"];
    
    NSInteger reviewOverall = [[object objectForKey:@"reviewOverall"] integerValue];
    NSInteger reviewActCourteous = [[object objectForKey:@"reviewActCourteous"] integerValue];
    NSInteger reviewDriveSafe = [[object objectForKey:@"reviewDriveSafe"] integerValue];
    NSInteger reviewFollowDirections = [[object objectForKey:@"reviewFollowDirections"] integerValue];
    NSInteger reviewHonestFare = [[object objectForKey:@"reviewHonestFare"] integerValue];
    NSInteger reviewKnowCity = [[object objectForKey:@"reviewKnowCity"] integerValue];
    
    if(reviewActCourteous == 1){
        [reviewTags appendString:@"Rude. "];
    }
    
    if(reviewKnowCity == 1){
        [reviewTags appendString:@"Bad Sense of Direction. "];
    }
    if(reviewDriveSafe == 1){
        [reviewTags appendString:@"Terrible Driver. "];
    }
    if(reviewFollowDirections == 1){
        [reviewTags appendString:@"Poor English. "];
    }
    if(reviewHonestFare == 1){
       [reviewTags appendString:@"Dishonest Fare. "];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([reviewText length] > 0) {
        [reviewTextFill appendString:@"\""];
        [reviewTextFill appendString:reviewText];
        [reviewTextFill appendString:@"\""];
        cell.reviewText.text = reviewTextFill;
    } else {
         cell.reviewText.text = @"No comments from passenger.";
    }
    if([reviewTags length] > 0) {
        cell.reviewDetails.text = reviewTags;
    } else {
        cell.reviewDetails.text = @"Good Driver. No complaints.";
    }
    cell.reviewDate.text = [NSString stringWithFormat:@"Reviewed: %@", [dateFormat stringFromDate:createdAt]];
    
    if(reviewOverall == 0){
        UIImage *image = [UIImage imageNamed: @"review-green-small.jpg"];
        [cell.reviewImage setImage:image];
    }
    
    if(reviewOverall == 1){
        UIImage *image = [UIImage imageNamed: @"review-yellow-small.jpg"];
        [cell.reviewImage setImage:image];
    }
    
    if(reviewOverall == 2){
        UIImage *image = [UIImage imageNamed: @"review-red-small.jpg"];
        [cell.reviewImage setImage:image];
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
