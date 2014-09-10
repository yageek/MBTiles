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

@synthesize dataSource = _dataSource, zoomLevel = _zoomLevel;

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

    [_tiledLayer setNeedsDisplay];
    
}
- (void) setDataSource:(id<MBTileDataSource>)dataSource
{
    if(!dataSource)
        return;
    
    _dataSource = dataSource;

    [_tileDelegate release];

    [_tiledLayer removeFromSuperlayer];
    [_tiledLayer release];
    _tiledLayer = [[CATiledLayer new] retain];
    _tiledLayer.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), 50000, 50000);
    
    
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
    _tiledLayer.position = CGPointMake(_tiledLayer.position.x, _tiledLayer.position.y +100.0f);
}


-(void) moveUp:(id)sender
{
    _tiledLayer.position = CGPointMake(_tiledLayer.position.x, _tiledLayer.position.y -100.0f);
}
-(void) moveLeft:(id)sender
{
    _tiledLayer.position = CGPointMake(_tiledLayer.position.x -100.0f, _tiledLayer.position.y);
}

- (void) setZoomLevel:(NSInteger)zoomLevel
{
    _zoomLevel = zoomLevel;
    _tileDelegate.zoomLevel = zoomLevel;
    
    [_tiledLayer setNeedsDisplay];
}

-(void) moveRight:(id)sender
{
    _tiledLayer.position = CGPointMake(_tiledLayer.position.x+100.0f, _tiledLayer.position.y );
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    [CATransaction setAnimationDuration:0];
    _tiledLayer.position = CGPointMake(_tiledLayer.position.x+[theEvent deltaX], _tiledLayer.position.y - [theEvent deltaY]);
}


-(void) swipeWithEvent:(NSEvent *)theEvent
{
    [CATransaction setAnimationDuration:0];
    _tiledLayer.position = CGPointMake(_tiledLayer.position.x+[theEvent deltaX], _tiledLayer.position.y - [theEvent deltaY]);
    
}
- (void) scrollWheel:(NSEvent *)theEvent
{
    NSLog(@"Scroll Delta: (%f,%f)", [theEvent scrollingDeltaX], [theEvent scrollingDeltaY]);
    
      if([theEvent scrollingDeltaY] > 0)
        self.zoomLevel = self.zoomLevel +1;
    else
        self.zoomLevel = self.zoomLevel -1;
//    _tiledLayer.position = [self convertPoint:[theEvent locationInWindow] fromView:nil];
}
@end
