//
//  CabObjectDataBase.m
//  CabCheck
//
//  Created by Rich DAlfonso on 9/2/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import "CabObjectDataBase.h"
#import "CabObject.h"


@implementation CabObjectDataBase

static CabObjectDataBase *_database;

+ (CabObjectDataBase*)database {
    if (_database == nil) {
        _database = [[CabObjectDataBase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"CabCheck" ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_database);
}

- (NSArray *)cabObjectInfos {
    
    NSMutableArray *cabObjectList = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT id, driverType, driverName, driverMedallion, driverDMVLicense, driverVIN, driverCabMake, driverCabModel, driverCabYear, driverCompany, driverCompanyPhone FROM cabObjectsNewYork ORDER BY driverMedallion ASC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueCabId = sqlite3_column_int(statement, 0);
            char *driverTypeChars = (char *) sqlite3_column_text(statement, 1);
            char *driverNameChars = (char *) sqlite3_column_text(statement, 2);
            char *driverMedallionChars = (char *) sqlite3_column_text(statement, 3);
            char *driverDMVLicenseChars = (char *) sqlite3_column_text(statement, 4);
            char *driverVINChars = (char *) sqlite3_column_text(statement, 5);
            char *driverCabMakeChars = (char *) sqlite3_column_text(statement, 6);
            char *driverCabModelChars = (char *) sqlite3_column_text(statement, 7);
            char *driverCabYearChars = (char *) sqlite3_column_text(statement, 8);
            char *driverCompanyChars = (char *) sqlite3_column_text(statement, 9);
            char *driverCompanyPhoneChars = (char *) sqlite3_column_text(statement, 10);
            
            NSString *driverType = [[NSString alloc] initWithUTF8String:driverTypeChars];
            NSString *driverName = [[NSString alloc] initWithUTF8String:driverNameChars];
            NSString *driverMedallion = [[NSString alloc] initWithUTF8String:driverMedallionChars];
            NSString *driverDMVLicense = [[NSString alloc] initWithUTF8String:driverDMVLicenseChars];
            NSString *driverVIN = [[NSString alloc] initWithUTF8String:driverVINChars];
            NSString *driverCabMake = [[NSString alloc] initWithUTF8String:driverCabMakeChars];
            NSString *driverCabModel = [[NSString alloc] initWithUTF8String:driverCabModelChars];
            NSString *driverCabYear = [[NSString alloc] initWithUTF8String:driverCabYearChars];
            NSString *driverCompany = [[NSString alloc] initWithUTF8String:driverCompanyChars];
            NSString *driverCompanyPhone = [[NSString alloc] initWithUTF8String:driverCompanyPhoneChars];
            
           CabObject *cab = [[CabObject alloc] initWithUniqueId:uniqueCabId driverType:driverType driverName:driverName driverMedallion:driverMedallion driverDMVLicense:driverDMVLicense driverVIN:driverVIN driverCabMake:driverCabMake driverCabModel:driverCabModel driverCabYear:driverCabYear driverCompany:driverCompany driverCompanyPhone:driverCompanyPhone];
           [cabObjectList addObject:cab];
            
        }
        sqlite3_finalize(statement);
    }
    return cabObjectList;
    
}


- (CabObject *)cabObjectDetails:(int)uniqueCabId {
    CabObject *cabObject = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT id, driverType, driverName, driverMedallion, driverDMVLicense, driverVIN, driverCabMake, driverCabModel, driverCabYear, driverCompany, driverCompanyPhone FROM cabObjectsNewYork  WHERE id=%d", uniqueCabId];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            int uniqueCabId = sqlite3_column_int(statement, 0);
            char *driverTypeChars = (char *) sqlite3_column_text(statement, 1);
            char *driverNameChars = (char *) sqlite3_column_text(statement, 2);
            char *driverMedallionChars = (char *) sqlite3_column_text(statement, 3);
            char *driverDMVLicenseChars = (char *) sqlite3_column_text(statement, 4);
            char *driverVINChars = (char *) sqlite3_column_text(statement, 5);
            char *driverCabMakeChars = (char *) sqlite3_column_text(statement, 6);
            char *driverCabModelChars = (char *) sqlite3_column_text(statement, 7);
            char *driverCabYearChars = (char *) sqlite3_column_text(statement, 8);
            char *driverCompanyChars = (char *) sqlite3_column_text(statement, 9);
            char *driverCompanyPhoneChars = (char *) sqlite3_column_text(statement, 10);

            NSString *driverType = [[NSString alloc] initWithUTF8String:driverTypeChars];
            NSString *driverName = [[NSString alloc] initWithUTF8String:driverNameChars];
            NSString *driverMedallion = [[NSString alloc] initWithUTF8String:driverMedallionChars];
            NSString *driverDMVLicense = [[NSString alloc] initWithUTF8String:driverDMVLicenseChars];
            NSString *driverVIN = [[NSString alloc] initWithUTF8String:driverVINChars];
            NSString *driverCabMake = [[NSString alloc] initWithUTF8String:driverCabMakeChars];
            NSString *driverCabModel = [[NSString alloc] initWithUTF8String:driverCabModelChars];
            NSString *driverCabYear = [[NSString alloc] initWithUTF8String:driverCabYearChars];
            NSString *driverCompany = [[NSString alloc] initWithUTF8String:driverCompanyChars];
            NSString *driverCompanyPhone = [[NSString alloc] initWithUTF8String:driverCompanyPhoneChars];
            
            cabObject = [[CabObject alloc] initWithUniqueId:uniqueCabId driverType:driverType driverName:driverName driverMedallion:driverMedallion driverDMVLicense:driverDMVLicense driverVIN:driverVIN driverCabMake:driverCabMake driverCabModel:driverCabModel driverCabYear:driverCabYear driverCompany:driverCompany driverCompanyPhone:driverCompanyPhone];
            
            break;
        }
        sqlite3_finalize(statement);
    }
    return cabObject;
}

@end
