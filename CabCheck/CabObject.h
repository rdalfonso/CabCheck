//
//  CabObject.h
//  CabCheck
//
//  Created by Rich DAlfonso on 9/2/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CabObject : NSObject {
    int _uniqueCabId;
    NSString *_driverType;
    NSString *_driverName;
    NSString *_driverMedallion;
    NSString *_driverDMVLicense;
    NSString *_driverVIN;
    NSString *_driverCabMake;
    NSString *_driverCabModel;
    NSString *_driverCabYear;
    NSString *_driverCompany;
    NSString *_driverCompanyPhone;
}
@property (nonatomic, assign) int uniqueCabId;
@property (nonatomic, copy) NSString *driverType;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *driverMedallion;
@property (nonatomic, copy) NSString *driverDMVLicense;
@property (nonatomic, copy) NSString *driverVIN;
@property (nonatomic, copy) NSString *driverCabMake;
@property (nonatomic, copy) NSString *driverCabModel;
@property (nonatomic, copy) NSString *driverCabYear;
@property (nonatomic, copy) NSString *driverCompany;
@property (nonatomic, copy) NSString *driverCompanyPhone;


- (id)initWithUniqueId:(int)uniqueCabId driverType:(NSString *)driverType driverName:(NSString *)driverName driverMedallion:(NSString *)driverMedallion driverDMVLicense:(NSString *)driverDMVLicense driverVIN:(NSString *)driverVIN driverCabMake:(NSString *)driverCabMake driverCabModel:(NSString *)driverCabModel driverCabYear:(NSString *)driverCabYear driverCompany:(NSString *)driverCompany driverCompanyPhone:(NSString *)driverCompanyPhone;

@end



