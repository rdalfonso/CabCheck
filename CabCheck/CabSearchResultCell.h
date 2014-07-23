//
//  CabSearchResultCell.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/23/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Parse/Parse.h>

@interface CabSearchResultCell : PFTableViewCell
@property (nonatomic, weak) IBOutlet UILabel *driverName;
@property (nonatomic, weak) IBOutlet UILabel *driverCompany;
@property (nonatomic, weak) IBOutlet UILabel *driverLicensePlate;
@property (nonatomic, weak) IBOutlet UILabel *driverMedallion;
@end
