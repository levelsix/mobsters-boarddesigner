//
//  BoardLayout.m
//  BoardDesigner
//
//  Created by Ashwin Kamath on 1/11/15.
//  Copyright (c) 2015 Ashwin Kamath. All rights reserved.
//

#import "BoardLayout.h"

@implementation BoardLayout

- (id) initWithGridSize:(CGSize)gridSize numColors:(int)numColors properties:(NSArray *)properties {
  if ((self = [super init])) {
    _numRows = gridSize.height;
    _numColumns = gridSize.width;
    _colorMask = numColors;
    
    self.properties = properties ? [properties mutableCopy] : [NSMutableArray array];
    
    _tiles = (__strong id **)calloc(sizeof(id *), _numColumns);
    _orbs = (__strong id **)calloc(sizeof(id *), _numColumns);
    for (int i = 0; i < _numColumns; i++) {
      _tiles[i] = (__strong id *)calloc(sizeof(id *), _numRows);
      _orbs[i] = (__strong id *)calloc(sizeof(id *), _numRows);
    }
  }
  return self;
}

- (NSArray *) propertiesForColumn:(int)column row:(int)row {
  NSMutableArray *arr = [NSMutableArray array];
  
  for (BoardProperty *prop in self.properties) {
    if (prop.posX == column && prop.posY == row) {
      [arr addObject:prop];
    }
  }
  
  return arr;
}

- (void) createTileAtColumn:(int)column row:(int)row {
  NSArray *properties = [self propertiesForColumn:column row:row];
  
  BOOL isHole = NO;
  BOOL canPassThrough = YES;
  BOOL canSpawnOrbs = row == _numRows-1;
  TileType typeTop = TileTypeNormal;
  TileType typeBottom = TileTypeNormal;
  BOOL shouldSpawnInitialSkill = NO;
  BOOL bottomFallsOut = row == 0;
  
  
  for (BoardProperty *prop in properties) {
    if ([prop.name isEqualToString:SPAWN_TILE]) {
      canSpawnOrbs = YES;
    } else if ([prop.name isEqualToString:NOT_SPAWN_TILE]) {
      canSpawnOrbs = NO;
    } else if ([prop.name isEqualToString:HOLE]) {
      isHole = YES;
      canPassThrough = NO;
    } else if ([prop.name isEqualToString:PASSABLE_HOLE]) {
      isHole = YES;
      canPassThrough = YES;
    } else if ([prop.name isEqualToString:TILE_TYPE]) {
      typeBottom = prop.value;
    } else if ([prop.name isEqualToString:INITIAL_SKILL]) {
      shouldSpawnInitialSkill = YES;
    } else if ([prop.name isEqualToString:BOTTOM_FALL]) {
      bottomFallsOut = YES;
    } else if ([prop.name isEqualToString:NOT_BOTTOM_FALL]){
      bottomFallsOut = NO;
    }
  }
  
  _tiles[column][row] = [[BattleTile alloc] initWithColumn:column row:row typeTop:typeTop typeBottom:typeBottom isHole:isHole canPassThrough:canPassThrough canSpawnOrbs:canSpawnOrbs shouldSpawnInitialSkill:shouldSpawnInitialSkill bottomFallsOut:bottomFallsOut];
}

- (BattleTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
  NSAssert(column >= 0 && column < _numColumns, @"Invalid column: %ld", (long)column);
  NSAssert(row >= 0 && row < _numRows, @"Invalid row: %ld", (long)row);
  
  return _tiles[column][row];
}

- (BattleOrb *)orbAtColumn:(NSInteger)column row:(NSInteger)row {
  NSAssert(column >= 0 && column < _numColumns, @"Invalid column: %ld", (long)column);
  NSAssert(row >= 0 && row < _numRows, @"Invalid row: %ld", (long)row);
  
  return _orbs[column][row];
}

- (void) setTile:(BattleTile *)tile column:(NSInteger)column row:(NSInteger)row {
  NSAssert(column >= 0 && column < _numColumns, @"Invalid column: %ld", (long)column);
  NSAssert(row >= 0 && row < _numRows, @"Invalid row: %ld", (long)row);
  
  _tiles[column][row] = tile;
}

- (void) setOrb:(BattleOrb *)orb column:(NSInteger)column row:(NSInteger)row {
  NSAssert(column >= 0 && column < _numColumns, @"Invalid column: %ld", (long)column);
  NSAssert(row >= 0 && row < _numRows, @"Invalid row: %ld", (long)row);
  
  //LNLog(@"Changing (%d, %d) orb from %@ to %@.", column, row, _orbs[column][row], orb);
  
  _orbs[column][row] = orb;
}

#pragma mark - Randomizing



- (void) generateRandomOrbData:(BattleOrb*)orb atColumn:(int)column row:(int)row {
  // Get a random color based on the available colors
  
  int rand;
  
  // Get a rand that is valid
  while (!(1 << (rand = arc4random_uniform(OrbColorNone)) & _colorMask));
  
  orb.orbColor = rand;
  orb.specialOrbType = SpecialOrbTypeNone;
}

- (NSSet *) randomizeBoard {
  
  for (int row = 0; row < _numRows; row++) {
    for (int column = 0; column < _numColumns; column++) {
      
      for (int j = 0; j < _numRows; j++) {
        [self createTileAtColumn:column row:row];
      }
    }
  }
  
  NSMutableSet *set = [NSMutableSet set];
  
  // Loop through the rows and columns of the 2D array. Note that column 0,
  // row 0 is in the bottom-left corner of the array.
  
  BOOL redo = NO;
  int numTries = 0;
  do {
    numTries++;
    
    [set removeAllObjects];
    
    // This will only add to the set if there are properties defined for inital colors/powerups
    for (int row = 0; row < _numRows; row++) {
      for (int column = 0; column < _numColumns; column++) {
        BattleOrb *orb = [self createInitialOrbAtColumn:column row:row];
        
        if (orb) {
          [set addObject:orb];
        }
      }
    }
    
    
    for (int row = 0; row < _numRows; row++) {
      for (int column = 0; column < _numColumns; column++) {
        
        // Only make a new orb if there is a tile at this spot.
        BattleTile *tile = [self tileAtColumn:column row:row];
        if (!tile.isHole) {
          
          // Pick the orb type at random, and make sure that this never
          // creates a chain of 3 or more. We want there to be 0 matches in
          // the initial state.
          BattleOrb *orb = [self orbAtColumn:column row:row];
          
          if (!orb) {
            int numTries2 = 0;
            do {
              numTries2++;
              // Create a new orb and add it to the 2D array.
              orb = [self createOrbAtColumn:column row:row type:OrbColorRock powerup:PowerupTypeNone special:SpecialOrbTypeNone];
              
              [self generateRandomOrbData:orb atColumn:column row:row];
              
              orb.isRandom = YES;
            }
            // Can't afford to have a chain in initial set
            while ([self hasChainAtColumn:column row:row] && numTries2 < 100);
            
            // Also add the orb to the set so we can tell our caller about it.
            [set addObject:orb];
            
          } else {
            // Empty tile
            if (orb.orbColor == OrbColorNone && orb.powerupType == PowerupTypeNone && orb.specialOrbType == SpecialOrbTypeNone) {
              [self setOrb:nil column:column row:row];
              
              [set removeObject:orb];
            }
            
            // Make sure there are no chains
            if ([self hasChainAtColumn:column row:row]) {
              redo = YES;
            }
          }
        }
      }
    }
  }
  while (redo && numTries < 100);
  
  return set;
}

- (BOOL)hasChainAtColumn:(NSInteger)column row:(NSInteger)row {
  NSUInteger orbColor = [self orbAtColumn:column row:row].orbColor;
  
  if (orbColor && orbColor != OrbColorNone) {
    NSUInteger horzLength = 1;
    for (NSInteger i = column - 1; i >= 0 && [self orbAtColumn:i row:row].orbColor == orbColor; i--, horzLength++) ;
    for (NSInteger i = column + 1; i < _numColumns && [self orbAtColumn:i row:row].orbColor == orbColor; i++, horzLength++) ;
    if (horzLength >= 3) return YES;
    
    NSUInteger vertLength = 1;
    for (NSInteger i = row - 1; i >= 0 && [self orbAtColumn:column row:i].orbColor == orbColor; i--, vertLength++) ;
    for (NSInteger i = row + 1; i < _numRows && [self orbAtColumn:column row:i].orbColor == orbColor; i++, vertLength++) ;
    return (vertLength >= 3);
  }
  return NO;
}

// Will return YES if something should be randomly generated
- (BattleOrb *) createInitialOrbAtColumn:(int)column row:(int)row {
  
  NSArray *properties = [self propertiesForColumn:column row:row];
  
  BattleOrb *orb = [self createOrbAtColumn:column row:row type:OrbColorRock powerup:PowerupTypeNone special:SpecialOrbTypeNone];
  
  orb.isRandom = YES;
  
  OrbColor color = 0;
  PowerupType powerup = 0;
  SpecialOrbType special = 0;
  
  BOOL shouldCreate = NO;
  for (BoardProperty *prop in properties) {
    if ([prop.name isEqualToString:@"ORB_COLOR"]) {
      color = prop.value;
      shouldCreate = YES;
      
      orb.isRandom = NO;
    } else if ([prop.name isEqualToString:@"ORB_POWERUP"]) {
      powerup = prop.value;
      shouldCreate = YES;
    } else if ([prop.name isEqualToString:@"ORB_SPECIAL"]) {
      special = prop.value;
      shouldCreate = YES;
      
      if (special == SpecialOrbTypeCloud) {
        orb.cloudCounter = MAX(1, prop.quantity);
      }
    } else if ([prop.name isEqualToString:@"ORB_EMPTY"]) {
      color = OrbColorNone;
      powerup = PowerupTypeNone;
      special = SpecialOrbTypeNone;
      shouldCreate = YES;
    } else if ([prop.name isEqualToString:@"ORB_LOCKED"]) {
      orb.isLocked = YES;
      shouldCreate = YES;
    } else if ([prop.name isEqualToString:@"ORB_VINES"]) {
      orb.isLocked = YES;
      orb.isVines = YES;
      shouldCreate = YES;
    }
  }
  
  if (!shouldCreate) {
    [self setOrb:nil column:column row:row];
    orb = nil;
  } else {
    [self generateRandomOrbData:orb atColumn:column row:row];
    
    if (color) {
      orb.orbColor = color;
    }
    if (powerup) {
      orb.powerupType = powerup;
    }
    if (special) {
      orb.specialOrbType = special;
    }
  }
  
  return orb;
}

- (BattleOrb *)createOrbAtColumn:(NSInteger)column row:(NSInteger)row type:(OrbColor)orbColor powerup:(PowerupType)powerup special:(SpecialOrbType)special {
  BattleOrb *orb = [[BattleOrb alloc] init];
  orb.orbColor = orbColor;
  orb.column = column;
  orb.row = row;
  orb.powerupType = powerup;
  orb.specialOrbType = special;
  [self setOrb:orb column:column row:row];
  return orb;
}

#pragma mark - Description

- (NSString *) description {
  NSMutableString *str = [NSMutableString stringWithFormat:@"\n"];
  
  for (int i = _numRows-1; i >= 0; i--) {
    [str appendFormat:@"%d |", i];
    for (int j = 0; j < _numColumns; j++) {
      BattleOrb *orb = [self orbAtColumn:j row:i];
      
      if (orb) {
        [str appendFormat:@" %d", orb.orbColor];
      } else {
        [str appendFormat:@"  "];
      }
    }
    
    [str appendFormat:@"\t\t\t\t\t\t"];
    
    // Print addresses far to the right
    for (int j = 0; j < _numColumns; j++) {
      BattleOrb *orb = [self orbAtColumn:j row:i];
      
      if (orb) {
        [str appendFormat:@" %p", orb];
      } else {
        [str appendFormat:@" ----------"];
      }
    }
    
    [str appendFormat:@"\n"];
  }
  
  [str appendFormat:@"  |"];
  
  for (int i = 0; i < _numColumns; i++) {
    [str appendFormat:@"--"];
  }
  
  [str appendFormat:@"\n   "];
  for (int i = 0; i < _numColumns; i++) {
    [str appendFormat:@" %d", i];
  }
  
  return str;
}

@end
