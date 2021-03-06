//
//  MBTile.h
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MBTileMake(ROW,COLUMN,ZOOM) (MBTile){.row = ROW, .column = COLUMN, .zoomLevel = ZOOM}

typedef struct  {
    uint32_t row, column;
	short zoomLevel;
} MBTile;
