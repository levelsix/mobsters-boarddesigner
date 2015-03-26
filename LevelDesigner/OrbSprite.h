//
//  OrbSprite.h
//  Utopia
//
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BattleOrb.h"

static const float orbUpdateAnimDuration = 0.3f;

@interface OrbSprite : SKNode
{
  BattleOrb *_orb;
}

@property (nonatomic, strong, readonly) SKSpriteNode* orbSprite;

+ (OrbSprite*) orbSpriteWithOrb:(BattleOrb*)orb;

+ (NSString *) stringForElement:(OrbColor)element;
+ (NSString *) stringForPowerup:(PowerupType)powerup;
+ (NSString *) stringForSpecial:(SpecialOrbType)special;

+ (NSString *) orbSpriteImageNameWithOrb:(BattleOrb *)orb;

@end
