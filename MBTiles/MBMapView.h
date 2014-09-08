//
//  MBMapView.h
//  MBTiles
//
//  Created by Yannick Heinrich on 08/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBTileDataSource.h"

@interface MBMapView : NSView{
    
    id<MBTileDataSource> _dataSource;
}

@property(assign, nonatomic,readwrite) id<MBTileDataSource> dataSource;
@end
