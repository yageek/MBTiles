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

@interface MBTilesDatabase : NSObject
{
   FMDatabase * _dbFile;
   MBTilesDatabaseInfos * _dbInfos;
}

- (id) initWithBaseURL:(NSURL*) url andInfos:(MBTilesDatabaseInfos*) infos;
- (id) initWithBaseURL:(NSURL*) url;


@end
