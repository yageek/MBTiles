//
//  MBMapView.m
//  MBTiles
//
//  Created by Yannick Heinrich on 08/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "MBMapView.h"

@implementation MBMapView

@synthesize dataSource = _dataSource;

- (void) commonInit
{
    [self setWantsLayer:YES];

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
    CAScrollLayer * rootLayer =  [CAScrollLayer new];
    return rootLayer;
}


- (void)viewDidEndLiveResize
{
    [super viewDidEndLiveResize];
     _tiledLayer.frame = self.layer.bounds;
    [_tiledLayer setNeedsDisplay];
    
}
- (void) setDataSource:(id<MBTileDataSource>)dataSource
{
    _dataSource = dataSource;

    [_tileDelegate release];

    [_tiledLayer removeFromSuperlayer];
    [_tiledLayer release];
    _tiledLayer = [[CATiledLayer new] retain];
    _tiledLayer.frame = self.layer.bounds;
    
    
    _tileDelegate = [[MBTilesDelegate alloc] initWithTileDataSource:dataSource];
    _tiledLayer.delegate = _tileDelegate;
    _tiledLayer.tileSize = CGSizeMake([_dataSource tileSide],[_dataSource tileSide]);
    [self.layer addSublayer:_tiledLayer];
    
    [_tiledLayer setNeedsDisplay];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

-(void) moveDown:(id)sender
{
    _tiledLayer.position = CGPointMake(_tiledLayer.position.x, _tiledLayer.position.y -10.0f);
}
@end
