//
//  MBTilesDatabase.m
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import "MBTilesDB.h"
#pragma mark - MBTilesDatabase
@implementation MBTilesDB

@synthesize useCache = _useCache;

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
                    _tileCache = [[MBTileCache alloc] init];
                    
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
                    
                    
                    NSString * typeString = [_dbFile stringForQuery:@"SELECT value FROM metadata WHERE name = 'type'"] ;
                    NSString * formatString = [_dbFile stringForQuery:@"SELECT value FROM metadata WHERE name = 'format'"];

                    readInfos.type = [MBTilesDatabaseInfos typeFromTypeString:typeString];
                    readInfos.format = [MBTilesDatabaseInfos formatFromFormatString:formatString];
                    _dbInfos = readInfos;
                    
                    CGImageRef image = [self CGImageForTile:MBTileMake(0, 0, 0)];
                    
                    readInfos.tileSide = CGImageGetHeight(image);
                    
                    [_tileCache removeImageForTile:MBTileMake(0, 0, 0)];
                    
                    
                    NSLog(@"Infos: %@", _dbInfos);
                   _tileCache = [[MBTileCache alloc] init];
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
    [_tileCache release];
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


- (void) addBlobs:(NSArray*) blobs ForTile:(NSArray*) tiles
{
    if(blobs.count != tiles.count)
        return;
    
    [_dbQueue inDatabase:^(FMDatabase * db){
        
        [db beginTransaction];
        
        NSUInteger index;
        for(index = 0; index < blobs.count; index++)
        {
            NSValue * tileValue = tiles[index];
            NSData * blob = blobs[index];
            MBTile tile;
            
            [tileValue getValue:&tile];
            [db executeQuery:@"INSERT INTO tiles VALUES (?,?,?,?)",tile.zoomLevel, tile.column, tile.row, blob];
        }
        [db commit];
    }];

    
}
- (void) addBlob:(NSData*) blob ForTile:(MBTile) tile
{
    NSValue * tileValue = [NSValue valueWithBytes:&tile objCType:@encode(MBTile)];
    
    [self addBlobs:@[blob] ForTile:@[tileValue]];
}

#pragma mark - MBTilesDataSource
- (CGImageRef) CGImageForTile:(MBTile)tile
{
    
    __block CGImageRef image = NULL;
    if(_useCache && [_tileCache containsTile:tile])
    {
        return [_tileCache CGImageForTile:tile];
    }
    
    [_dbQueue inDatabase:^(FMDatabase * db){

        
     NSData * data = [db dataForQuery:@"SELECT tile_data FROM tiles WHERE zoom_level = ? and tile_column = ? and tile_row = ?", @(tile.zoomLevel),@(tile.column),@(tile.row)];
        
        if(data)
        {
            CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef) data);
            if(_dbInfos.type == MBTilesDatabaseTileFormatJPG)
            {
              image = CGImageCreateWithJPEGDataProvider(provider, NULL, YES, kCGRenderingIntentDefault);
            }
            else
            {
               image = CGImageCreateWithPNGDataProvider(provider, NULL, YES, kCGRenderingIntentDefault);
            }
            
            if(image)
            {
                [_tileCache addCGImage:image forTile:tile];
                CGImageRelease(image);
            }
            
            CGDataProviderRelease(provider);

            
        }
    }];
    
    return image;
}

- (CGFloat) tileSide
{
    return _dbInfos.tileSide;
}
@end
