//
//  MBMapView.m
//  MBTiles
//
//  Created by Yannick Heinrich on 08/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MBMapView.h"

@implementation MBMapView

@synthesize dataSource = _dataSource;

- (void) commonInit
{
    [self setWantsLayer:YES];
    
    [self.layer setNeedsDisplay];

}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
        
    }
    return self;
}
- (id) initWithFrame:(NSRect)frameRect
{
    if(self = [super initWithFrame:frameRect])
    {
        [self commonInit];
    }
    return self;
}

- (CALayer *) makeBackingLayer
{
    return [CATiledLayer new];
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    NSRect bounds = CGContextGetClipBoundingBox(ctx);
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
    
    
    
}

- (void) setDataSource:(id<MBTileDataSource>)dataSource
{
    _dataSource = dataSource;
    
    
    [self.layer setNeedsDisplay];
}
@end
