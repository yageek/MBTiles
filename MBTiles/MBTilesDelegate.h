//
//  MBTilesDelegate.h
//  MBTiles
//
//  Created by Yannick Heinrich on 09/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTileDataSource.h"
@interface MBTilesDelegate : NSObject{
    id<MBTileDataSource> _dataSource;
    NSInteger _zoomLevel;
}
- (id) initWithTileDataSource:(id<MBTileDataSource>) dataSource;

@property(nonatomic) NSInteger zoomLevel;
@end
