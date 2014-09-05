//
//  YGAppDelegate.m
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import "YGAppDelegate.h"
#import "MBTilesDatabase.h"
#import "MBTilesDatabaseInfos.h"
@implementation YGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    
    NSURL * url = [NSURL URLWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"test.db"]];
    MBTilesDatabaseInfos * infos = [[[MBTilesDatabaseInfos alloc] initWithName:@"TEst" description:@"Desc" version:1 type:MBTilesDatabaseTypeBaseLayer format:MBTilesDatabaseTileFormatPNG] autorelease];
    MBTilesDatabase * dataBase = [[MBTilesDatabase alloc] initWithBaseURL:url andInfos:infos];
    
    
    
    
    [dataBase release];
}

@end
