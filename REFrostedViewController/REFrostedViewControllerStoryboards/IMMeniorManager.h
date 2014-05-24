//
//  IMMeniorManager.h
//  InteractiveMuseum
//
//  Created by Andrew Sowers on 5/20/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface IMMeniorManager : NSObject
{
    FMDatabase *database;
}
-(void)addMemiorObject;
-(void)buildInitialDatabase;
-(NSString *)getObjectFromIndex:(int)index;
-(BOOL)openDatabase;
-(BOOL)closeDatabase;
@property(strong, nonatomic) NSString * query;

@end
