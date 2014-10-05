//
//  CabObjectDataBase.m
//  CabCheck
//
//  Created by Rich DAlfonso on 9/2/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//


#import "CabObjectDataBase.h"
#import "CabObject.h"
#import <sqlite3.h>

@interface CabObjectDataBase()
@property (nonatomic, strong) NSMutableArray *cabObjectList;
@end

@implementation CabObjectDataBase
#pragma mark - Initialization

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}


-(void)copyDatabaseIntoDocumentsDirectory{
    
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
       
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    } else {
        NSLog(@"Exists");
    }
}

- (NSMutableArray *)cabObjectInfos:(NSString*)searchTerm withString:(NSString*)cityObject {
    
    sqlite3 *sqlite3Database;
    
    // Initialize the results array.
    if (self.cabObjectList != nil) {
        [self.cabObjectList removeAllObjects];
        self.cabObjectList = nil;
    }
	self.cabObjectList = [[NSMutableArray alloc] init];
    
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
	if(openDatabaseResult == SQLITE_OK)
    {
      sqlite3_stmt *statement;
        
        NSString *searchClean = [searchTerm stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        NSString *query = [NSString stringWithFormat:@"SELECT id, driverType, driverName, driverMedallion, driverDMVLicense, driverVIN, driverCabMake, driverCabModel, driverCabYear, driverCompany, driverCompanyPhone FROM %@  WHERE driverMedallion like '%%%@%%' ORDER BY LENGTH(driverMedallion) ASC, driverMedallion ASC LIMIT 100", cityObject, searchClean];
        
        if (sqlite3_prepare_v2(sqlite3Database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
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
                NSString *driverMedallionClean = [driverMedallion stringByReplacingOccurrencesOfString:@"+" withString:@""];
                NSString *driverDMVLicense = [[NSString alloc] initWithUTF8String:driverDMVLicenseChars];
                NSString *driverVIN = [[NSString alloc] initWithUTF8String:driverVINChars];
                NSString *driverCabMake = [[NSString alloc] initWithUTF8String:driverCabMakeChars];
                NSString *driverCabModel = [[NSString alloc] initWithUTF8String:driverCabModelChars];
                NSString *driverCabYear = [[NSString alloc] initWithUTF8String:driverCabYearChars];
                NSString *driverCompany = [[NSString alloc] initWithUTF8String:driverCompanyChars];
                NSString *driverCompanyPhone = [[NSString alloc] initWithUTF8String:driverCompanyPhoneChars];
                
                CabObject *cab = [[CabObject alloc] initWithUniqueId:uniqueCabId driverType:driverType driverName:driverName driverMedallion:driverMedallionClean driverDMVLicense:driverDMVLicense driverVIN:driverVIN driverCabMake:driverCabMake driverCabModel:driverCabModel driverCabYear:driverCabYear driverCompany:driverCompany driverCompanyPhone:driverCompanyPhone];
                
                [self.cabObjectList addObject:cab];
                cab = nil;
            }
            
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Database returned error %d: %s", sqlite3_errcode(sqlite3Database), sqlite3_errmsg(sqlite3Database));
        }
        
    }
    // Close the database.
	sqlite3_close(sqlite3Database);
    
    //return the Array
    return self.cabObjectList;
}



@end
