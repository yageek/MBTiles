//
//  MBTilesDatabaseInfo.h
//  MBTiles
//
//  Created by Yannick Heinrich on 05/09/14.
//  Copyright (c) 2014 ___yageek__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MBTilesDatabaseType){
    MBTilesDatabaseTypeOverlay,
    MBTilesDatabaseTypeBaseLayer
};

typedef NS_ENUM(NSInteger, MBTilesDatabaseTileFormat){
    MBTilesDatabaseTileFormatPNG,
    MBTilesDatabaseTileFormatJPG
};

@interface MBTilesDatabaseInfos : NSObject
{
    NSString *_name;
    NSString *_description;
    MBTilesDatabaseTileFormat _format;
    MBTilesDatabaseType _type;
    NSInteger _version;
}

- (id) initWithName:(NSString*) name description:(NSString*) description version:(NSInteger) version type:(MBTilesDatabaseType) type format:(MBTilesDatabaseTileFormat) format;

@property(copy, nonatomic,readwrite) NSString * name;
@property(copy, nonatomic,readwrite) NSString * description;
@property(nonatomic,readwrite) MBTilesDatabaseTileFormat format;
@property(nonatomic,readwrite) MBTilesDatabaseType type;
@property(nonatomic,readwrite) NSInteger version;


+ (MBTilesDatabaseType) typeFromTypeString:(NSString*) type;
+ (MBTilesDatabaseTileFormat) formatFromFormatString:(NSString* ) format;
+ (NSString * )typeStringFromType:(MBTilesDatabaseType) type;
+ (NSString *) formatStringFromTilesFormat:(MBTilesDatabaseTileFormat) format;
@end
