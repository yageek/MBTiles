//
//  MBTile.h
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBTile : NSObject
{
    @public
    NSUInteger _column;
    NSUInteger _row;
    NSInteger _zoomLevel;
    @protected
    NSData * _blob;
}

@property(retain, nonatomic, readwrite) NSData * blob;

@property(nonatomic) NSUInteger column;
@property(nonatomic) NSUInteger row;
@property(nonatomic) NSInteger zoomLevel;

- (id) initWithRow:(NSInteger) row column:(NSInteger) column zoomLevel:(NSInteger) zoom blob:(NSData*) data;
@end
