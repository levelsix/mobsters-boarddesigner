//
//  RWTCookie.h
//  CookieCrunch
//
//  Created by Matthijs on 25-02-14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

typedef enum {
  OrbColorFire = 1,
  OrbColorEarth,
  OrbColorWater,
  OrbColorLight,
  OrbColorDark,
  OrbColorRock,
  OrbColorNone
} OrbColor;

typedef enum {
  SpecialOrbTypeNone = 0,
  SpecialOrbTypeCake = 1,
  SpecialOrbTypeBomb = 2,
  SpecialOrbTypePoison = 3,
  SpecialOrbTypeHeadshot = 4,
  SpecialOrbTypeCloud = 5,
} SpecialOrbType;

typedef enum {
  PowerupTypeNone = 0,
  PowerupTypeHorizontalLine = 1,
  PowerupTypeVerticalLine = 2,
  PowerupTypeExplosion = 3,
  PowerupTypeAllOfOneColor = 4,
  PowerupTypeEnd = 20
} PowerupType;

@interface BattleOrb : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) OrbColor orbColor;
@property (assign, nonatomic) SpecialOrbType specialOrbType;
@property (assign, nonatomic) PowerupType powerupType;

@property (assign, nonatomic) BOOL isRandom;

@property (assign, nonatomic) BOOL isLocked;

// Special orb variables
@property (assign, nonatomic) NSInteger bombCounter;
@property (assign, nonatomic) NSInteger bombDamage;
@property (assign, nonatomic) NSInteger headshotCounter;
@property (assign, nonatomic) NSInteger cloudCounter;

- (BOOL) isMovable;

@end
