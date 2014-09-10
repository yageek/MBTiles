//
//  MBTilesDelegate.m
//  MBTiles
//
//  Created by Yannick Heinrich on 09/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//
#import<QuartzCore/QuartzCore.h>
#import "MBTilesDelegate.h"

@implementation MBTilesDelegate
@synthesize zoomLevel = _zoomLevel;

- (id) initWithTileDataSource:(id<MBTileDataSource>) dataSource
{
    if(self = [super init])
    {
        _dataSource = dataSource;
    }
    return self;
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    CGRect rect   = CGContextGetClipBoundingBox(ctx);
    int column = floor(rect.origin.x / layer.tileSize.width); int row = floor(rect.origin.y / layer.tileSize.height);
    
    CGImageRef image = [_dataSource CGImageForTile:MBTileMake(row,column,_zoomLevel)];
    
    CGContextDrawImage(ctx, CGRectMake(rect.origin.x, rect.origin.y, 256, 256), image);
    
    
	CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);  // outline green
	CGContextStrokeRect(ctx, rect);
    
    
    CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSelectFont(ctx, "Helvetica", 12.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(ctx, 1.7);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    
    
    char text [5] = {0};
    sprintf(text, "(%i,%i)", row,column);
    CGContextShowTextAtPoint(ctx, rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2,text, strlen(text));
}

@end
