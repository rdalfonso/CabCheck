//
//  CabSearchResultCell.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/23/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Parse/Parse.h>

@interface CabSearchResultCell : PFTableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnReadReviews;
@property (strong, nonatomic) IBOutlet UILabel *driverName;
@property (strong, nonatomic) IBOutlet UILabel *driverMedallion;
@property (strong, nonatomic) IBOutlet UILabel *driverLicense;
@property (strong, nonatomic) IBOutlet UILabel *driverCabMakeModel;
@property (strong, nonatomic) IBOutlet UILabel *driverVIN;
@property (strong, nonatomic) IBOutlet UILabel *driverResultHeader;
@property (strong, nonatomic) IBOutlet UILabel *driverResultMainHeader;
@property (strong, nonatomic) IBOutlet UILabel *driverRating;
@property (strong, nonatomic) IBOutlet UIImageView *driverRatingImage;
@property (strong, nonatomic) IBOutlet UILabel *driverRatingProsAndCons;
@property (strong, nonatomic) IBOutlet UILabel *lblSafeDriver;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeaksEnglish;
@property (strong, nonatomic) IBOutlet UILabel *lblKnowsDirections;
@property (strong, nonatomic) IBOutlet UILabel *lblIsCourteous;

@property (strong, nonatomic) IBOutlet UILabel *lblHonestFare;
@property (strong, nonatomic) IBOutlet UILabel *driverType;


@end
