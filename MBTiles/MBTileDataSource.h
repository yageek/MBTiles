//
//  MBTileDataSource.h
//  MBTiles
//
//  Created by Yannick Heinrich on 08/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBFoundation.h"

@protocol MBTileDataSource <NSObject>

@required
- (CGImageRef) CGImageForTile:(MBTile) tile;
- (CGFloat) tileSide;

/** A `BOOL` value indicating whether the tiles from this source should be cached. */
@property (nonatomic, assign, getter=isUsingCache) BOOL useCache;

@end
