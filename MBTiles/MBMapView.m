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
    CATiledLayer * tilelayer =  [CATiledLayer new];
    return tilelayer;
}
- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx
{
    CGRect rect   = CGContextGetClipBoundingBox(ctx);
    int column = floor(rect.origin.x / layer.tileSize.width); int row = floor(rect.origin.y / layer.tileSize.height);
    
    CGImageRef image = [_dataSource CGImageForTile:MBTileMake(row,column,5)];
    
    CGContextDrawImage(ctx, rect, image);
    
    
	CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);  // outline green
	CGContextStrokeRect(ctx, rect);
    

    CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSelectFont(ctx, "Helvetica", 12.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(ctx, 1.7);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    
    
    char text [5] = {0};
    sprintf(text, "(%i,%i)", row,column);
    CGContextShowTextAtPoint(ctx, rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2,text, 5);
}


- (void)viewDidEndLiveResize
{
    [super viewDidEndLiveResize];
    
    [self.layer setNeedsDisplay];
    
}
- (void) setDataSource:(id<MBTileDataSource>)dataSource
{
    _dataSource = dataSource;
    
    
    [self.layer setNeedsDisplay];
}

@end
