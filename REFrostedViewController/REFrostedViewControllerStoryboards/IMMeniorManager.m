//
//  IMMeniorManager.m
//  InteractiveMuseum
//
//  Created by Andrew Sowers on 5/20/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "IMMeniorManager.h"

@implementation IMMeniorManager

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
    }
    return self;
}


-(void)addMemiorObject
{
    
    
}

-(BOOL)openDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    
    return [database open];
}

-(BOOL)closeDatabase
{
    return [database close];
}

//FOR TESTING PURPOSES ONLY test initial memior data
-(void)buildInitialDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    
    FMDatabase * INITdatabase = [FMDatabase databaseWithPath:path];
    
    [INITdatabase open];
    
    [INITdatabase executeUpdate:@"create table object(name text primary key, waterfallIndex int)"];
    [INITdatabase executeUpdate:@"create table currentObject(name text primary key, waterfallIndex int)"];
    
    
    // Building the string ourself
    //NSString *query = [NSString stringWithFormat:@"insert into user values ('%@', %d)",@"sally", 25];
    //[database executeUpdate:query];
    
    // Let fmdb do the work
    //[database executeUpdate:@"insert into user(name, age) values(?,?)",@"bob",[NSNumber numberWithInt:25],nil];
    
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex) values(?,?)",@"Object1",[NSNumber numberWithInt:0],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex) values(?,?)",@"Object2",[NSNumber numberWithInt:1],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex) values(?,?)",@"Object3",[NSNumber numberWithInt:2],nil];
    
    FMResultSet *results = [INITdatabase executeQuery:@"select * from object"];
    while([results next]) {
        NSString *name = [results stringForColumn:@"name"];
        NSInteger index  = [results intForColumn:@"waterfallIndex"];
        NSLog(@"Initial data: %@ - %d",name, index);
    }
    
    [INITdatabase close];
    
}

-(int)getWaterfallIndex:(NSString *)object
{
    FMResultSet *result = [database executeQuery:[NSString stringWithFormat:@"select waterfallIndex from object where name = %@",object]];
    return [result intForColumn:@"waterfallIndex"];
}

// set the name of object and index
-(void)setWaterfallIndex:(NSString *)object :(int)index
{
    
}

// get name of object from index
-(NSString *)getObjectFromIndex:(int)index
{ 

    FMResultSet *results = [database executeQuery:[NSString stringWithFormat:@"select * from object where waterfallIndex = %d",index]];
    while([results next]) {
        return [results stringForColumn:@"name"];

    }
    return @"Error";
}




@end
