//
//  MBTilesDatabaseInfo.m
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import "MBTilesDatabaseInfos.h"

@implementation MBTilesDatabaseInfos

@synthesize name = _name, version = _version, type =_type, format = _format, description = _description;


- (id) initWithName:(NSString*) name description:(NSString*) description version:(NSInteger) version type:(MBTilesDatabaseType) type format:(MBTilesDatabaseTileFormat) format
{
    if(self = [super init])
    {
        _name = [name copy];
        _description = [description copy];
        _type = type;
        _format = format;
    }
    return self;
}
- (void) dealloc
{
    [_name release];
    [_description release];
    [super dealloc];
}
- (NSString*) description
{
    return [NSString stringWithFormat:@"[MBTILES] %@: %@ %li %@ %@ ", _name, _description, _version, [self typeStringFromType:_type],  [self formatStringFromTilesFormat:_format]];
}

- (NSString *) formatStringFromTilesFormat:(MBTilesDatabaseTileFormat) format
{
    if(format == MBTilesDatabaseTileFormatJPG)
        return @"JPG";
    else
        return @"PNG";
}

- (NSString * )typeStringFromType:(MBTilesDatabaseType) type
{
    if(type == MBTilesDatabaseTypeBaseLayer)
        return @"baseLayer";
    else
        return @"overlay";
}
@end
