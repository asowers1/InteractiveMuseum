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
    
    [INITdatabase executeUpdate:@"create table object(name text primary key, waterfallIndex int, active int)"];
    [INITdatabase executeUpdate:@"create table current(name text primary key)"];
    [INITdatabase executeUpdate:@"create table photoReturn(state text primary key)"];

    
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex,active) values(?,?,?)",[NSString stringWithFormat:@"Object%d",1],[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex,active) values(?,?,?)",[NSString stringWithFormat:@"Object%d",2],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex,active) values(?,?,?)",[NSString stringWithFormat:@"Object%d",3],[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex,active) values(?,?,?)",[NSString stringWithFormat:@"Object%d",4],[NSNumber numberWithInt:3],[NSNumber numberWithInt:0],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex,active) values(?,?,?)",[NSString stringWithFormat:@"Object%d",5],[NSNumber numberWithInt:4],[NSNumber numberWithInt:0],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex,active) values(?,?,?)",[NSString stringWithFormat:@"Object%d",6],[NSNumber numberWithInt:5],[NSNumber numberWithInt:0],nil];
    [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex,active) values(?,?,?)",[NSString stringWithFormat:@"Object%d",7],[NSNumber numberWithInt:6],[NSNumber numberWithInt:0],nil];
    
/*
    for (int i=3; i<9; i++)
            [INITdatabase executeUpdate:@"insert into object(name, waterfallIndex,active) values(?,?,?)",[NSString stringWithFormat:@"Object%d",i+1],[NSNumber numberWithInt:i],[NSNumber numberWithInt:0],nil];
*/
    
    [INITdatabase executeUpdate:@"insert into photoReturn(state) values(?)",@"no",nil];
    [INITdatabase executeUpdate:@"insert into current(name) values(?)",@"Object1",nil];
    
    [self addMemiorObject:3];
    int count=0;
    
    FMResultSet *results = [INITdatabase executeQuery:@"select * from object"];
    while([results next]) {
        NSString *name = [results stringForColumn:@"name"];
        NSInteger index  = [results intForColumn:@"waterfallIndex"];
        NSInteger active = [results intForColumn:@"active"];
        NSLog(@"Initial data: %@ - %ld - %ld",name, (long)index,(long)active);
        count++;
    }
    NSLog(@"COUNT: %d",count);

    [INITdatabase close];
    
}

#pragma mark - Defined Functions

// Function to Create a writable copy of the bundled default database in the application Documents directory.
- (void)createCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Database filename can have extension db/sqlite.
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appDBPath = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite"];
    
    success = [fileManager fileExistsAtPath:appDBPath];
    if (success){
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    [self buildInitialDatabase];
    /*
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:appDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
     */
    
}
-(void)setSelectionIndex:(NSString *)object
{
    
    [database executeUpdate:@"UPDATE current SET name = ? WHERE rowid = ?", object, [NSNumber numberWithInt:1],nil];
}

-(void)setPhotoReturn:(NSString *)object
{
    [database executeUpdate:@"UPDATE photoReturn SET state = ? WHERE rowid = ?", object, [NSNumber numberWithInt:1],nil];
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

-(NSString *)getPhotoReturn
{
    FMResultSet *result = [database executeQuery:@"SELECT * FROM photoReturn"];
    while([result next]){
        NSString * string = [result stringForColumn:@"state"];
        //NSString * rowid = [result stringForColumn:@"rowid"];
        //NSLog(@"OUTDATA:%@:%@:",string,rowid);
        // to do: assert for invalid selection
        return string;
    }
    return @"error";
}

-(void)addMemiorObject:(int)index
{
    // count number of objects in database
    // insert new object based on count plus one
    // return
    NSLog(@"addMemiorObject: %d",index);
    [database executeUpdate:@"UPDATE object SET active = ? WHERE waterfallIndex = ?",[NSNumber numberWithInt:1],[NSNumber numberWithInt:3],nil];
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

-(int)getActiveCellCount
{
    int count = 0;
    FMResultSet *results = [database executeQuery:@"select * from object where active = 1"];
    while ([results next]) {
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

// check if object exists in database
-(BOOL)checkForObject:(NSString *)object
{
    NSString *objectFixed = [NSString stringWithFormat:@"%d",(int)([object integerValue]-1)];
    FMResultSet *result = [database executeQuery:[NSString stringWithFormat:@"select name from object where waterfallIndex = %@",objectFixed]];
    if ([result next]) {
        return true;
    }else
    return false;
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
