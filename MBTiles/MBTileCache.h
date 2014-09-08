//
//  MBTileCache.h
//  MBTiles
//
//  Created by Yannick Heinrich on 08/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBFoundation.h"

@interface MBTileCache : NSObject{
    
    NSMutableDictionary * _tilesDict;
}

- (id) initWithCapacity:(NSUInteger) capacity;
- (void) addCGImage:(CGImageRef) image forTile:(MBTile) tile;
- (void) removeImageForTile:(MBTile) tile;
- (BOOL) containsTile:(MBTile) tile;

- (CGImageRef) CGImageForTile:(MBTile ) tile;
@end
