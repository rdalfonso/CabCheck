//
//  DDSearchResultDetailController.h
//  CabCheck
//
//  Created by Rich DAlfonso on 7/24/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DDSearchResultDetailController : UIViewController
@property (nonatomic, strong) NSString *taxiUniqueID;

@property (strong, nonatomic) IBOutlet UILabel *driverName;
@property (strong, nonatomic) IBOutlet UILabel *driverMedallion;
@property (strong, nonatomic) IBOutlet UILabel *driverLicense;
@property (strong, nonatomic) IBOutlet UILabel *driverCabMakeModel;
@property (strong, nonatomic) IBOutlet UILabel *driverVIN;
@property (strong, nonatomic) IBOutlet UILabel *driverSpeaksEnglish;

@property (strong, nonatomic) IBOutlet UIImageView *driverRatingImage;
@property (strong, nonatomic) IBOutlet UILabel *driverIsSafeDriver;
@property (strong, nonatomic) IBOutlet UILabel *driverIsHonest;
@property (strong, nonatomic) IBOutlet UILabel *driverKnowsDirections;
@property (strong, nonatomic) IBOutlet UILabel *driverIsCourteous;

@end
