//
//  CabReviewCell.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/28/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Parse/Parse.h>

@interface CabReviewCell : PFTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *reviewText;
@property (strong, nonatomic) IBOutlet UILabel *reviewItems;
@property (strong, nonatomic) IBOutlet UILabel *reviewDate;
@end
