//
//  OrbLayer.m
//  LevelDesigner
//
//  Created by Ashwin Kamath on 1/19/15.
//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import "OrbLayer.h"

#import "BoardBgdLayer.h"

#define ORB_NAME_TAG(d) [NSString stringWithFormat:@"%p", d]

@implementation OrbLayer

#pragma mark - Game Setup

- (OrbSprite*) createOrbSpriteForOrb:(BattleOrb*)orb
{
  OrbSprite* orbLayer = [OrbSprite orbSpriteWithOrb:orb];
  orbLayer.position = [self pointForColumn:orb.column row:orb.row];
  orbLayer.name = ORB_NAME_TAG(orb);
  [self addChild:orbLayer];
  return orbLayer;
}

- (void) addSpritesForOrbs:(NSSet *)orbs {
  for (SKNode *node in self.children.copy) {
    [node removeFromParent];
  }
  
  for (BattleOrb *orb in orbs) {
    // Create a new sprite for the orb and add it to the orbSwipeLayer.
    [self createOrbSpriteForOrb:orb];
  }
}

- (OrbSprite*) spriteForOrb:(BattleOrb *)orb {
  return (OrbSprite*)[self childNodeWithName:ORB_NAME_TAG(orb)];
}

- (void) removeAllOrbSprites {
  [self removeAllChildren];
}

// Converts a column,row pair into a CGPoint that is relative to the orbLayer.
- (CGPoint) pointForColumn:(NSInteger)column row:(NSInteger)row {
  int tileSize = TILESIZE;
  return CGPointMake(column*tileSize + tileSize/2, row*tileSize + tileSize/2);
}

@end
