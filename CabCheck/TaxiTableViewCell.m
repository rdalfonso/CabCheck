//
//  TaxiTableViewCell.m
//  CabCheck
//
//  Created by Rich DAlfonso on 7/21/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "TaxiTableViewCell.h"

@implementation TaxiTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
