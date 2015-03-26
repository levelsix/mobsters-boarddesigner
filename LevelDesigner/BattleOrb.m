//
//  RWTCookie.m
//  CookieCrunch
//
//  Created by Matthijs on 25-02-14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "BattleOrb.h"


@implementation BattleOrb

- (id) copy {
  BattleOrb *cp = [[BattleOrb alloc] init];
  cp.column = self.column;
  cp.row = self.row;
  cp.orbColor = self.orbColor;
  cp.specialOrbType = self.specialOrbType;
  cp.powerupType = self.powerupType;
  cp.bombCounter = self.bombCounter;
  cp.bombDamage = self.bombDamage;
  cp.headshotCounter = self.headshotCounter;
  cp.cloudCounter = self.cloudCounter;
  return cp;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@: color - %ld powerup - %ld special - %ld square - (%ld,%ld)", [super description], (long)self.orbColor, (long)self.powerupType, (long)self.specialOrbType, (long)self.column, (long)self.row];
}

- (BOOL) isMovable {
  return self.specialOrbType != SpecialOrbTypeCloud && !self.isLocked;
}

- (void) setSpecialOrbType:(SpecialOrbType)specialOrbType {
  _specialOrbType = specialOrbType;
  
  if (self.specialOrbType != SpecialOrbTypeNone) {
    _powerupType = PowerupTypeNone;
  }
  
  if (self.specialOrbType == SpecialOrbTypeCake ||
      self.specialOrbType == SpecialOrbTypeCloud) {
    self.orbColor = OrbColorNone;
  }
}

@end

