//
//  TileSprite.h
//  Utopia
//
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BattleTile.h"

static const float tileUpdateAnimDuration = 0.3f;

typedef enum {
  TileDepthTop,
  TileDepthBottom
} TileDepth;

@interface TileSprite : SKNode
{
  BattleTile* _tile;
  TileType    _tileType;
}

@property (nonatomic, strong, readonly) SKSpriteNode* sprite;
@property (nonatomic, assign, readonly) TileDepth depth;

+ (TileSprite*) tileSpriteWithTile:(BattleTile*)tile depth:(TileDepth)depth;

+ (NSString *) tileSpriteImageNameWithTileType:(TileType)tileType;

- (void) updateSprite;

@end
