//
//  DDCabSearchResult.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/23/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "DDCabSearchResult.h"

@implementation DDCabSearchResult

@synthesize driverName = _driverName;
@synthesize driverCompany = _driverCompany;
@synthesize driverLicensePlate = _driverLicensePlate;
@synthesize driverMedallion = _driverMedallion;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
