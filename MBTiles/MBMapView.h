//
//  MBMapView.h
//  MBTiles
//
//  Created by Yannick Heinrich on 08/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "MBTileDataSource.h"
#import "MBTilesDelegate.h"

@interface MBMapView : NSView{
    
    MBTilesDelegate * _tileDelegate;
    CATiledLayer *_tiledLayer;
    NSInteger _zoomLevel;
}

@property(assign, nonatomic,readwrite) id<MBTileDataSource> dataSource;
@property(nonatomic) NSInteger zoomLevel;
@end
