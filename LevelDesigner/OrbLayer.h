//
//  OrbLayer.h
//  LevelDesigner
//
//  Created by Ashwin Kamath on 1/19/15.
//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "OrbSprite.h"

@interface OrbLayer : SKNode

- (OrbSprite*) createOrbSpriteForOrb:(BattleOrb *)orb;
- (void)addSpritesForOrbs:(NSSet *)orbs;
- (OrbSprite*) spriteForOrb:(BattleOrb*)orb;
- (void)removeAllOrbSprites;

@end
