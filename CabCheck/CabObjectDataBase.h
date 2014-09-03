//
//  CabObjectDataBase.h
//  CabCheck
//
//  Created by Rich DAlfonso on 9/2/14.
//  Copyright (c) 2014 DuomoDigital. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CabObject;
@interface CabObjectDataBase : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(NSMutableArray *)cabObjectInfos:(NSString *)searchTerm withString:(NSString*)cityObject;

@end
