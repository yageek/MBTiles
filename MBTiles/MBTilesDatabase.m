//
//  MBTilesDatabase.m
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import "MBTilesDatabase.h"
#pragma mark - MBTilesDatabase
@implementation MBTilesDatabase

- (id) initWithBaseURL:(NSURL *)url
{
    return [self initWithBaseURL:url andInfos:nil];
}
- (id) initWithBaseURL:(NSURL*) url andInfos:(MBTilesDatabaseInfos*) infos
{
    if(self = [super init])
    {
        
        BOOL creation = ![[NSFileManager defaultManager] fileExistsAtPath:url.path];
        if(creation && !infos)
        {
            NSLog(@"Could not create a database without provided informations");
            [self release];
            return nil;
        }
        
        FMDatabase * base = [FMDatabase databaseWithPath:url.path];
        if(base)
        {
            _dbFile = [base retain];
            _dbQueue = [[FMDatabaseQueue databaseQueueWithPath:url.path] retain];
            
            if (![_dbFile open])
            {
                [self release];
                return nil;
            }
            else
            {
                if(creation)
                {
                    _dbInfos = [infos retain];
                    [self createBasicTables];
                    
                }
                else
                {
                    FMResultSet * set = [_dbFile getSchema];
                    NSMutableArray * existingTablesName = [NSMutableArray array];
                    while([set next])
                    {
                        [existingTablesName addObject:[set objectForColumnName:@"name"]];
                    }
                    
                    if(![existingTablesName containsObject:@"tiles"] && ![existingTablesName containsObject:@"metadata"])
                    {
                        
                        NSLog(@"Missing required tables");
                        [self release];
                        return nil;
                    }
                    
                    MBTilesDatabaseInfos * readInfos = [[MBTilesDatabaseInfos alloc] init];
                    
                    readInfos.name = [_dbFile stringForQuery:@"SELECT value FROM metadata WHERE name = 'name'"];
                    readInfos.description = [_dbFile stringForQuery:@"SELECT value FROM metadata WHERE name = 'description'"];
                    readInfos.version = [[_dbFile stringForQuery:@"SELECT value FROM metadata WHERE name = 'version'"] integerValue];
                    readInfos.type = [[_dbFile stringForQuery:@"SELECT value FROM metadata WHERE name = 'type'"] integerValue];
                    readInfos.format = [[_dbFile stringForQuery:@"SELECT value FROM metadata WHERE name = 'format'"] integerValue];

                    _dbInfos = readInfos;
                    
                    NSLog(@"Infos: %@", _dbInfos);
                }
            }
        }
        else
        {
            [self release];
            return nil;
        }
    }
    return self;
}


- (void) dealloc
{
    [_dbFile close];
    [_dbQueue release];
    [_dbFile release];
    [_dbInfos release];
    [super dealloc];
}

#pragma mark - Creation
- (void) createBasicTables
{
    [_dbFile beginTransaction];
    
    [_dbFile executeUpdate:@"CREATE TABLE metadata (name text, value text);"];
    [_dbFile executeUpdate:@"INSERT INTO metadata (name, value) VALUES ('name', :value)" withParameterDictionary:@{@"value" : _dbInfos.name}];
    [_dbFile executeUpdate:@"INSERT INTO metadata (name, value) VALUES ('version', :value)" withParameterDictionary:@{@"value" : [NSString stringWithFormat:@"%li", (long)_dbInfos.version]}];
    [_dbFile executeUpdate:@"INSERT INTO metadata (name, value) VALUES ('description', :value)" withParameterDictionary:@{@"value" : _dbInfos.description}];
    
    NSString * format;
    if(_dbInfos.format == MBTilesDatabaseTileFormatPNG)
        format = @"png";
    else
        format = @"jpg";
    
    NSString * type;
    if(_dbInfos.type == MBTilesDatabaseTypeBaseLayer)
        type = @"baselayer";
    else
        type = @"overlay";
    [_dbFile executeUpdate:@"INSERT INTO metadata (name, value) VALUES ('type', :value)" withParameterDictionary:@{@"value" : type}];
    [_dbFile executeUpdate:@"INSERT INTO metadata (name, value) VALUES ('format', :value)" withParameterDictionary:@{@"value" : format}];
    
    [_dbFile executeUpdate:@"CREATE TABLE tiles (zoom_level integer, tile_column integer, tile_row integer, tile_data blob);"];

    
    [_dbFile commit];
    
}

- (void) addTile:(MBTile *)tile
{
    [self addTiles:@[tile]];
}

- (void) addTiles:(NSArray*) tilesArray
{
    [_dbQueue inDatabase:^(FMDatabase * db){
       
        [db beginTransaction];
        for(MBTile * tile in tilesArray)
        {
            [db executeQuery:@"INSERT INTO tiles VALUES (?,?,?,?)",tile.zoomLevel, tile.column, tile.row, tile.blob];
        }
         [db commit];
    }];
}
@end
