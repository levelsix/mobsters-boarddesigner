//
//  TileSprite.m
//  Utopia
//
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "TileSprite.h"

@implementation TileSprite

+ (TileSprite*) tileSpriteWithTile:(BattleTile*)tile depth:(TileDepth)depth
{
  return [[TileSprite alloc] initWithTile:tile depth:depth];
}

- (id) initWithTile:(BattleTile*)tile depth:(TileDepth)depth
{
  // Super init
  self = [super init];
  if ( ! self )
    return nil;
  
  _tile = tile;
  _depth = depth;
  if (_depth == TileDepthTop)
    _tileType = tile.typeTop;
  else
    _tileType = tile.typeBottom;
  
  // Reload sprite
  [self reloadSprite];
  
  return self;
}

- (void) reloadSprite
{
  // Remove previous
  if (_sprite)
  {
    [self.sprite removeFromParent];
  }
  
  _sprite = [SKSpriteNode spriteNodeWithImageNamed:[TileSprite tileSpriteImageNameWithTileType:_tileType]];
  [self addChild:_sprite];
}

+ (NSString *) tileSpriteImageNameWithTileType:(TileType)tileType {
  
  NSString *resPrefix = @"6";
  
  // Check if this tile is not empty
  NSString* imageName;
  switch (tileType)
  {
    case TileTypeJelly:
      imageName = @"boardgoo.png";
      break;
    case TileTypeMud:
      imageName = @"boardmud.png";
      break;
      
    default: break;
  }
  
  return [resPrefix stringByAppendingString:imageName];
}

- (void) updateSprite
{
  TileType oldType = _tileType;
  if (_depth == TileDepthTop)
    _tileType = _tile.typeTop;
  else
    _tileType = _tile.typeBottom;
  
  if (oldType != _tileType)
    [self reloadSprite];
}

@end
