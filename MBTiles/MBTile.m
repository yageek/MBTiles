//
//  MBTile.m
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import "MBTile.h"

@implementation MBTile

@synthesize blob = _blob, row = _row, column = _column , zoomLevel = _zoomLevel;

- (id) initWithRow:(NSInteger) row column:(NSInteger) column zoomLevel:(NSInteger) zoom blob:(NSData*) data
{
    if(self = [super init])
    {
        _blob = [data retain];
        _row = row;
        _column = column;
        _zoomLevel = zoom;
    }
    return self;
}

- (void) dealloc
{
    [_blob release];
    [super dealloc];
}
@end
