//
//  OrbSprite.m
//  Utopia
//
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "OrbSprite.h"

@implementation OrbSprite

#pragma mark - Initialization

+ (OrbSprite*) orbSpriteWithOrb:(BattleOrb*)orb
{
  return [[OrbSprite alloc] initWithOrb:orb];
}

- (id) initWithOrb:(BattleOrb*)orb
{
  self = [super init];
  if ( ! self )
    return nil;
  
  _orb = orb;
  
  // Create a new sprite for the orb
  [self loadSprite];
  
  return self;
}

- (void) loadSprite
{
  NSString *imageName = [OrbSprite orbSpriteImageNameWithOrb:_orb];
  _orbSprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
  
  [self addChild:self.orbSprite];
  
  if (_orb.isLocked) {
    if (_orb.isVines)
      [self loadVineElements];
    else
      [self loadLockElements];
  }
  
  if (_orb.isRandom && _orb.powerupType != PowerupTypeAllOfOneColor) {
    if (_orb.powerupType || _orb.specialOrbType) {
      _orbSprite.alpha = 0.7f;
    } else {
      _orbSprite.alpha = 0.3f;
    }
  }
}

- (void) loadLockElements {
  SKSpriteNode *_lockedSprite = [SKSpriteNode spriteNodeWithImageNamed:@"6lockedorb.png"];
  _lockedSprite.zPosition = 1.f;
  [self addChild:_lockedSprite];
}

- (void) loadVineElements {
#warning temp code for placeholder art
  SKSpriteNode *_lockedSprite = [SKSpriteNode spriteNodeWithImageNamed:@"6lockedorb.png"];
  _lockedSprite.zPosition = 1.f;
  _lockedSprite.colorBlendFactor = 1.f;
  _lockedSprite.color = [NSColor greenColor];
  [self addChild:_lockedSprite];
}

#pragma mark - Helpers

+ (NSString *) imageNameForElement:(OrbColor)element suffix:(NSString *)str {
  NSString *base = [[[self stringForElement:element] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
  return [base stringByAppendingString:str];
}

+ (NSString *) stringForElement:(OrbColor)element {
  switch (element) {
    case OrbColorDark:
      return @"Night";
      
    case OrbColorFire:
      return @"Fire";
      
    case OrbColorEarth:
      return @"Earth";
      
    case OrbColorLight:
      return @"Light";
      
    case OrbColorWater:
      return @"Water";
      
    case OrbColorRock:
      return @"Rock";
      
    case OrbColorNone:
      return @"No Element";
      
    default:
      return nil;
      break;
  }
}

+ (NSString *) stringForPowerup:(PowerupType)powerup {
  switch (powerup) {
    case PowerupTypeHorizontalLine:
      return @"Horizontal Rocket";
      break;
      
    case PowerupTypeVerticalLine:
      return @"Vertical Rocket";
      break;
      
    case PowerupTypeExplosion:
      return @"Grenade";
      break;
      
    case PowerupTypeAllOfOneColor:
      return @"Rainbow";
      break;
      
    default:
      return nil;
      break;
  }
}

+ (NSString *) stringForSpecial:(SpecialOrbType)special {
  switch (special) {
    case SpecialOrbTypeCloud:
      return @"Cloud";
      break;
      
    default:
      return nil;
      break;
  }
}

+ (NSString *) orbSpriteImageNameWithOrb:(BattleOrb *)orb {
  OrbColor orbColor = orb.orbColor;
  PowerupType powerupType = orb.powerupType;
  SpecialOrbType special = orb.specialOrbType;
  
  NSString *resPrefix = @"6";
  
  switch (special) {
    case SpecialOrbTypeCake:
      return [resPrefix stringByAppendingString:@"cakeorb.png"];
      break;
      
    case SpecialOrbTypeCloud:
      return [resPrefix stringByAppendingFormat:@"cloud%d.png", (int)orb.cloudCounter];
      break;
      
    case SpecialOrbTypeBomb:
      if (orbColor == OrbColorRock || orbColor == OrbColorNone)
        return nil;
      return [NSString stringWithFormat:@"%@%@.png", resPrefix, [OrbSprite imageNameForElement:orbColor suffix:@"bomb"] ];
      break;
      
    case SpecialOrbTypeHeadshot:
      if (orbColor == OrbColorNone)
        return nil;
      return [NSString stringWithFormat:@"%@%@.png", resPrefix, [OrbSprite imageNameForElement:orbColor suffix:@"headshot"] ];
      break;
      
    case SpecialOrbTypePoison:
      if (orbColor == OrbColorNone)
        return nil;
      if (orb.powerupType == PowerupTypeNone)
        return [NSString stringWithFormat:@"%@%@.png", resPrefix, [OrbSprite imageNameForElement:orbColor suffix:@"poison"] ];
      break;
      
    default:
      break;
  }
  
  NSString *colorPrefix = @"";
  switch (orbColor) {
    case OrbColorFire:
    case OrbColorDark:
    case OrbColorLight:
    case OrbColorEarth:
    case OrbColorWater:
    case OrbColorRock:
      colorPrefix = [OrbSprite imageNameForElement:orbColor suffix:@""];
      break;
    case OrbColorNone:
      colorPrefix = @"all";
      break;
    default: return nil; break;
  }
  
  NSString *powerupSuffix = @"";
  switch (powerupType) {
    case PowerupTypeNone: powerupSuffix = @"orb"; break;
    case PowerupTypeHorizontalLine: powerupSuffix = @"sideways"; break;
    case PowerupTypeVerticalLine: powerupSuffix = @"updown"; break;
    case PowerupTypeExplosion: powerupSuffix = @"grenade"; break;
    case PowerupTypeAllOfOneColor:
      colorPrefix = @"all";
      powerupSuffix = @"cocktail";
      break;
    default: return nil; break;
  }
  
  return [NSString stringWithFormat:@"%@%@%@.png", resPrefix, colorPrefix, powerupSuffix];
}

@end
