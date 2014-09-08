//
//  MBTilesDatabase.h
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

#import "MBTilesDatabaseInfos.h"
#import "MBFoundation.h"
#import "MBTileDataSource.h"
#import "MBTileCache.h"


@interface MBTilesDB : NSObject <MBTileDataSource>
{
    
   FMDatabase * _dbFile;
   FMDatabaseQueue * _dbQueue;
    
   MBTilesDatabaseInfos * _dbInfos;
   MBTileCache * _tileCache;
    
   BOOL _useCache;
    
    
}

- (id) initWithBaseURL:(NSURL*) url andInfos:(MBTilesDatabaseInfos*) infos;
- (id) initWithBaseURL:(NSURL*) url;

- (void) addBlobs:(NSArray*) blobs ForTile:(NSArray*) tiles;
- (void) addBlob:(NSData*) blob ForTile:(MBTile) tile;

@end
