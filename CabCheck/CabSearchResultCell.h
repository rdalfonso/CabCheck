//
//  CabSearchResultCell.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/23/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Parse/Parse.h>

@interface CabSearchResultCell : PFTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *driverName;
@property (strong, nonatomic) IBOutlet UILabel *driverMedallion;
@property (strong, nonatomic) IBOutlet UILabel *driverLicense;
@property (strong, nonatomic) IBOutlet UILabel *driverCabMakeModel;

@end
