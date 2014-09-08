//
//  MBTileCache.m
//  MBTiles
//
//  Created by Yannick Heinrich on 08/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import "MBTileCache.h"


uint64_t RMTileHash(MBTile tile)
{
	uint64_t accumulator = 0;
    
	for (int i = 0; i < tile.zoomLevel; i++)
    {
		accumulator |= ((uint64_t)tile.row & (1LL<<i)) << i;
		accumulator |= ((uint64_t)tile.column & (1LL<<i)) << (i+1);
	}
    
	accumulator |= 1LL<<(tile.zoomLevel * 2);
	return accumulator;
}

@implementation MBTileCache

- (id) init
{
    return [self initWithCapacity:64];
}
- (id) initWithCapacity:(NSUInteger) capacity
{
    if(self = [super init])
    {
        _tilesDict = [[NSMutableDictionary alloc] initWithCapacity:capacity];
    }
    return self;
}

- (void) dealloc
{

    for(NSValue * imageValue in [_tilesDict allValues])
    {
        CGImageRef image;
        [imageValue getValue:&image];
        CGImageRelease(image);
    }
    
    [_tilesDict release];
    [super dealloc];
}

- (void) addCGImage:(CGImageRef) image forTile:(MBTile) tile
{
    CGImageRef rimage = CGImageRetain(image);
    
    NSValue * imageValue = [NSValue valueWithBytes:&rimage objCType:@encode(CGImageRef)];
    [_tilesDict setObject:imageValue forKey:@(RMTileHash(tile))];
}

- (void) removeImageForTile:(MBTile) tile
{
    
    NSValue * imageValue = [_tilesDict objectForKey:@(RMTileHash(tile))];
    CGImageRef image;
    [imageValue getValue:&image];
    
    CGImageRelease(image);
}
- (BOOL) containsTile:(MBTile) tile
{
    return [[_tilesDict allValues] containsObject:@(RMTileHash(tile))];
}
- (CGImageRef) CGImageForTile:(MBTile ) tile
{
    NSValue * imageValue = [_tilesDict objectForKey:@(RMTileHash(tile))];
    CGImageRef image;
    [imageValue getValue:&image];
    return image;
}
@end
