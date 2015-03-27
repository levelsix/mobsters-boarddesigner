//
//  BoardPropertyEntity.m
//  LevelDesigner
//
//  Created by Ashwin Kamath on 1/20/15.
//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import "BoardPropertyEntity.h"

#import "OrbSprite.h"
#import "TileSprite.h"

@implementation BoardPropertyEntity

- (id) initWithName:(NSString *)name value:(int)value {
  if ((self = [super init])) {
    self.name = name;
    self.value = value;
  }
  return self;
}

- (NSArray *) performChangesAtPosX:(int)posX posY:(int)posY currentProperties:(NSArray *)properties {
  BOOL shouldAdd = YES;
  
  NSMutableArray *arr = [properties mutableCopy];
  
  NSMutableArray *toRemove = [NSMutableArray array];
  for (BoardProperty *prop in properties) {
    
    if ([prop.name isEqualToString:self.name]) {
      
      if (prop.value == self.value) {
        if ([self foundSameProperty:prop]) {
          // Remove the property
          [toRemove addObject:prop];
        }
      } else {
        // Change to current value
        prop.value = self.value;
        
        [self customizeNewProperty:prop];
      }
      
      shouldAdd = NO;
    } else if (![self propertyCanExistSimultaneously:prop]) {
      [toRemove addObject:prop];
    }
  }
  
  [arr removeObjectsInArray:toRemove];
  
  if (shouldAdd) {
    BoardProperty *bp = [[BoardProperty alloc] init];
    bp.name = self.name;
    bp.value = self.value;
    bp.posX = posX;
    bp.posY = posY;
    
    [self customizeNewProperty:bp];
    
    [arr addObject:bp];
  }
  
  return arr;
}

- (void) customizeNewProperty:(BoardProperty *)bp {
  bp.quantity = 0;
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  return YES;
}

// Return YES to remove it
- (BOOL) foundSameProperty:(BoardProperty *)bp {
  return YES;
}

@end

@implementation OrbColorPropertyEntity

- (id) initWithOrbColor:(OrbColor)color {
  return [super initWithName:ORB_COLOR value:color];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if ((PROP_EQUALS(bp.name, ORB_POWERUP) && bp.value == PowerupTypeAllOfOneColor) || // Rainbow orb
      (PROP_EQUALS(bp.name, ORB_SPECIAL) && bp.value == SpecialOrbTypeCloud) || // Cloud
      PROP_EQUALS(bp.name, ORB_EMPTY) ||
      PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE)) {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  BattleOrb *orb = [[BattleOrb alloc] init];
  orb.orbColor = self.value;
  return [NSImage imageNamed:[OrbSprite orbSpriteImageNameWithOrb:orb]];
}

- (NSString *) title {
  return [[OrbSprite stringForElement:self.value] stringByAppendingString:@" Orb"];
}

@end

@implementation OrbPowerupPropertyEntity

- (id) initWithOrbPowerup:(PowerupType)powerup {
  return [super initWithName:ORB_POWERUP value:powerup];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if ((PROP_EQUALS(bp.name, ORB_COLOR) && self.value == PowerupTypeAllOfOneColor) || // Rainbow orb
      (PROP_EQUALS(bp.name, ORB_SPECIAL) && bp.value == SpecialOrbTypeCloud) || // Cloud
      PROP_EQUALS(bp.name, ORB_EMPTY) ||
      PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE)) {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  BattleOrb *orb = [[BattleOrb alloc] init];
  orb.orbColor = OrbColorFire;
  orb.powerupType = self.value;
  return [NSImage imageNamed:[OrbSprite orbSpriteImageNameWithOrb:orb]];
}

- (NSString *) title {
  return [OrbSprite stringForPowerup:self.value];
}

@end

@implementation OrbSpecialPropertyEntity

- (id) initWithOrbSpecial:(SpecialOrbType)special {
  return [super initWithName:ORB_SPECIAL value:special];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if (PROP_EQUALS(bp.name, ORB_EMPTY) ||
      PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE)) {
    return NO;
  }
  
  if (self.value == SpecialOrbTypeCloud) {
    if (PROP_EQUALS(bp.name, ORB_COLOR) ||
        PROP_EQUALS(bp.name, ORB_POWERUP)) {
      return NO;
    }
  }
  
  return YES;
}

- (void) customizeNewProperty:(BoardProperty *)bp {
  if (bp.value == SpecialOrbTypeCloud) {
    bp.quantity = 1;
  }
}

- (BOOL) foundSameProperty:(BoardProperty *)bp {
  if (bp.value == SpecialOrbTypeCloud) {
    if (bp.quantity < MAX_CLOUD_COUNTER) {
      bp.quantity++;
      return NO;
    }
  }
  return YES;
}

- (NSImage *) thumbnailIcon {
  BattleOrb *orb = [[BattleOrb alloc] init];
  orb.specialOrbType = self.value;
  orb.cloudCounter = 1;
  return [NSImage imageNamed:[OrbSprite orbSpriteImageNameWithOrb:orb]];
}

- (NSString *) title {
  return [[OrbSprite stringForSpecial:self.value] stringByAppendingString:@" Orb"];
}

@end

@implementation OrbEmptyPropertyEntity

- (id) init {
  return [super initWithName:ORB_EMPTY value:0];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if (PROP_EQUALS(bp.name, ORB_SPECIAL) ||
      PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE) ||
      PROP_EQUALS(bp.name, ORB_COLOR) ||
      PROP_EQUALS(bp.name, ORB_POWERUP) ||
      PROP_EQUALS(bp.name, ORB_LOCKED) ||
      PROP_EQUALS(bp.name, ORB_VINES)) {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  return nil;
}

- (NSString *) title {
  return @"Empty Tile";
}

@end

@implementation HolePropertyEntity

- (id) initWithPassibility:(BOOL)isPassable {
  return [super initWithName:isPassable ? PASSABLE_HOLE : HOLE value:0];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if (PROP_EQUALS(bp.name, ORB_SPECIAL) ||
      PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE) ||
      PROP_EQUALS(bp.name, ORB_COLOR) ||
      PROP_EQUALS(bp.name, ORB_POWERUP) ||
      PROP_EQUALS(bp.name, ORB_EMPTY) ||
      PROP_EQUALS(bp.name, ORB_LOCKED) ||
      PROP_EQUALS(bp.name, SPAWN_TILE) ||
      PROP_EQUALS(bp.name, NOT_SPAWN_TILE) ||
      PROP_EQUALS(bp.name, ORB_VINES) ||
      PROP_EQUALS(bp.name, BOTTOM_FALL)) {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  return nil;
}

- (NSString *) title {
  return PROP_EQUALS(self.name, HOLE) ? @"Hole" : @"Passable Hole";
}

@end

@implementation OrbLockedPropertyEntity

- (id) init {
  return [super initWithName:ORB_LOCKED value:0];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if (PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE) ||
      PROP_EQUALS(bp.name, ORB_EMPTY) ||
      PROP_EQUALS(bp.name, ORB_VINES)) {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  return [NSImage imageNamed:@"6lockedorb.png"];
}

- (NSString *) title {
  return @"Locked Orb";
}

@end

@implementation OrbVinesPropertyEntity

- (id) init {
  return [super initWithName:ORB_VINES value:0];
}

- (BOOL)propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if (PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE) ||
      PROP_EQUALS(bp.name, ORB_EMPTY) ||
      PROP_EQUALS(bp.name, ORB_LOCKED))
    return NO;
  
  return YES;
}

- (NSImage *)thumbnailIcon{
  return [NSImage imageNamed:@"6lockedorb.png"];
}

- (NSString *) title {
  return @"Vines";
}

@end

@implementation TileTypePropertyEntity

- (id) initWithTileType:(TileType)tileType {
  return [super initWithName:TILE_TYPE value:tileType];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if (PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE)) {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  return [NSImage imageNamed:[TileSprite tileSpriteImageNameWithTileType:self.value]];
}

- (NSString *) title {
  switch (self.value) {
    case TileTypeJelly:
      return @"Jelly";
      break;
      
    case TileTypeMud:
      return @"Mud";
      break;
      
    default:
      break;
  }
  return nil;
}

@end

@implementation SpawnTilePropertyEntity

- (id) initWithShouldSpawn:(BOOL)shouldSpawn {
  return [super initWithName:shouldSpawn ? SPAWN_TILE : NOT_SPAWN_TILE value:0];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if (PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE) ||
      PROP_EQUALS(bp.name, SPAWN_TILE) ||
      PROP_EQUALS(bp.name, NOT_SPAWN_TILE) ||
      PROP_EQUALS(bp.name, BOTTOM_FALL)) {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  return nil;
}

- (NSString *)title {
  return PROP_EQUALS(self.name, SPAWN_TILE) ? @"Spawn Tile" : @"Not Spawn Tile";
}

@end

@implementation InitialSkillPropertyEntity

- (id) init {
  return [super initWithName:INITIAL_SKILL value:0];
}

- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp {
  
  if (PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE) ||
      PROP_EQUALS(bp.name, ORB_POWERUP) ||
      PROP_EQUALS(bp.name, ORB_SPECIAL) ||
      PROP_EQUALS(bp.name, ORB_LOCKED)) {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  return nil;
}

- (NSString *)title {
  return @"Initial Skill";
}

@end

@implementation ClearTilePropertyEntity

- (NSArray *) performChangesAtPosX:(int)posX posY:(int)posY currentProperties:(NSArray *)properties {
  return nil;
}

- (NSImage *) thumbnailIcon {
  return nil;
}

- (NSString *)title {
  return @"Clear Tile";
}

@end

@implementation BottomFallPropertyEntity

- (id)initWithShouldFall:(BOOL)shouldFall{
  return [super initWithName:shouldFall ? BOTTOM_FALL : NOT_BOTTOM_FALL value:0];
}

- (BOOL)propertyCanExistSimultaneously:(BoardProperty *)bp{
  
  if (PROP_EQUALS(bp.name, HOLE) ||
      PROP_EQUALS(bp.name, PASSABLE_HOLE) ||
      PROP_EQUALS(bp.name, SPAWN_TILE) ||
      PROP_EQUALS(bp.name, BOTTOM_FALL) ||
      PROP_EQUALS(bp.name, NOT_BOTTOM_FALL))
  {
    return NO;
  }
  
  return YES;
}

- (NSImage *) thumbnailIcon {
  return nil;
}

- (NSString *)title{
  return PROP_EQUALS(self.name, BOTTOM_FALL) ? @"Bottom Fall Out Tile" : @"Not Bottom Fall Out Tile";
}

@end