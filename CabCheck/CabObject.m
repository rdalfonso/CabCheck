//
//  CabObject.m
//  CabCheck
//
//  Created by Rich DAlfonso on 9/2/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "CabObject.h"

@implementation CabObject

@synthesize uniqueCabId = _uniqueCabId;
@synthesize driverType = _driverType;
@synthesize driverName = _driverName;
@synthesize driverMedallion = _driverMedallion;
@synthesize driverDMVLicense = _driverDMVLicense;
@synthesize driverVIN = _driverVIN;
@synthesize driverCabMake = _driverCabMake;
@synthesize driverCabModel = _driverCabModel;
@synthesize driverCabYear = _driverCabYear;
@synthesize driverCompany = _driverCompany;
@synthesize driverCompanyPhone = _driverCompanyPhone;


- (id)initWithUniqueId:(int)uniqueCabId driverType:(NSString *)driverType driverName:(NSString *)driverName driverMedallion:(NSString *)driverMedallion driverDMVLicense:(NSString *)driverDMVLicense driverVIN:(NSString *)driverVIN driverCabMake:(NSString *)driverCabMake driverCabModel:(NSString *)driverCabModel driverCabYear:(NSString *)driverCabYear driverCompany:(NSString *)driverCompany driverCompanyPhone:(NSString *)driverCompanyPhone{
    if ((self = [super init])) {
        self.uniqueCabId = uniqueCabId;
        self.driverType = driverType;
        self.driverName = driverName;
        self.driverMedallion = driverMedallion;
        self.driverDMVLicense = driverDMVLicense;
        self.driverVIN = driverVIN;
        self.driverCabMake = driverCabMake;
        self.driverCabModel = driverCabModel;
        self.driverCabYear = driverCabYear;
        self.driverCompany = driverCompany;
        self.driverCompanyPhone = driverCompanyPhone;
    }
    return self;
}

- (void) dealloc {
    self.driverType = nil;
    self.driverName = nil;
    self.driverMedallion = nil;
    self.driverDMVLicense = nil;
    self.driverVIN = nil;
    self.driverCabMake = nil;
    self.driverCabModel = nil;
    self.driverCabYear = nil;
    self.driverCompany = nil;
    self.driverCompanyPhone = nil;
}

@end