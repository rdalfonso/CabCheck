//
//  CabObjectDataBase.h
//  CabCheck
//
//  Created by Rich DAlfonso on 9/2/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class CabObject;
@interface CabObjectDataBase : NSObject{
    sqlite3 *_database;
}

+ (CabObjectDataBase*)database;
- (NSArray *)cabObjectInfos;
- (CabObject *)cabObjectDetails:(int)uniqueId;

@end
