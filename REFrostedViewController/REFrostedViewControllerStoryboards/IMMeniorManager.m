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

-(BOOL)openDatabase
{
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"data.sqlite"];
    database = [self templateDatabase];//[FMDatabase databaseWithPath:path];
    */
    
    [self createCopyOfDatabaseIfNeeded];
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
    [INITdatabase executeUpdate:@"create table current(name text primary key)"];

    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex) values(?,?)",@"Object1",[NSNumber numberWithInt:0],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex) values(?,?)",@"Object2",[NSNumber numberWithInt:1],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex) values(?,?)",@"Object3",[NSNumber numberWithInt:2],nil];
    
    [INITdatabase executeUpdate:@"insert into current(name) values(?)",@"Object1",nil];
    
    
    int count=0;
    
    FMResultSet *results = [INITdatabase executeQuery:@"select * from object"];
    while([results next]) {
        NSString *name = [results stringForColumn:@"name"];
        NSInteger index  = [results intForColumn:@"waterfallIndex"];
        NSLog(@"Initial data: %@ - %ld",name, (long)index);
        count++;
    }
    NSLog(@"COUNT: %d",count);

    [INITdatabase close];
    
}

// Function to Create a writable copy of the bundled default database in the application Documents directory.
- (void)createCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Database filename can have extension db/sqlite.
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appDBPath = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite"];
    
    success = [fileManager fileExistsAtPath:appDBPath];
    if (success){
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:appDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }else
        [self buildInitialDatabase];
}

-(void)setSelectionIndex:(NSString *)object
{
    
    [database executeUpdate:@"UPDATE current SET name = ? WHERE rowid = ?", object, [NSNumber numberWithInt:1],nil];
}

-(NSString *)getSelectionIndex
{
    FMResultSet *result = [database executeQuery:@"SELECT * FROM current"];
    while([result next]){
        NSString * string = [result stringForColumn:@"name"];
        //NSString * rowid = [result stringForColumn:@"rowid"];
        //NSLog(@"OUTDATA:%@:%@:",string,rowid);
        // to do: assert for invalid selection
        return string;
    }
    return @"error";
}

-(void)addMemiorObject
{
    // count number of objects in database
    // insert new object based on count plus one
    // return
    
}

-(int)getObjectCount
{
    int count = 0;
    FMResultSet *results = [database executeQuery:@"select * from object"];
    while([results next]){
        count++;
    }
    return count;
}

-(int)getWaterfallIndex:(NSString *)object
{
    FMResultSet *result = [database executeQuery:[NSString stringWithFormat:@"select waterfallIndex from object where name = %@",object]];
    while([result next]){
        return [result intForColumn:@"waterfallIndex"];
    }
    return -1;
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
