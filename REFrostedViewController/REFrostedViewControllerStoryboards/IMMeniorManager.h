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
-(void)addMemiorObject:(int)index;
-(void)buildInitialDatabase;
-(NSString *)getObjectFromIndex:(int)index;
-(void)setSelectionIndex:(NSString *)object;
-(void)setPhotoReturn:(NSString *)object;
-(NSString *)getSelectionIndex;
-(NSString *)getPhotoReturn;
-(BOOL)openDatabase;
-(BOOL)closeDatabase;
-(BOOL)checkForObject:(NSString *)object;
-(int)getObjectCount;
-(int)getActiveCellCount;
@property(strong, nonatomic) NSString * query;

@end
