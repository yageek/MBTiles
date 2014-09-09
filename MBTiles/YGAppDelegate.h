//
//  YGAppDelegate.h
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBMapView.h"
@interface YGAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet MBMapView *mapView;

@end
