//
//  BoardLayout.h
//  BoardDesigner
//
//  Created by Ashwin Kamath on 1/11/15.
//  Copyright (c) 2015 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BattleOrb.h"
#import "BattleTile.h"

#import "BoardProperty.h"

@interface BoardLayout : NSObject {
  int _numColumns;
  int _numRows;
  int _colorMask;
  
  // The 2D array that contains the layout of the level.
  // Will contain BattleTile objects
  __strong id **_tiles;
  
  // The 2D array that keeps track of where the BattleOrbs are.
  // Will contain BattleOrb objects
  __strong id **_orbs;
}

@property (nonatomic, assign) int numColumns;
@property (nonatomic, assign) int numRows;
@property (nonatomic, assign) int colorMask;

@property (nonatomic, retain) NSMutableArray *properties;

- (id) initWithGridSize:(CGSize)gridSize numColors:(int)numColors properties:(NSArray *)properties;

- (NSArray *) propertiesForColumn:(int)column row:(int)row;

// Returns the orb at the specified column and row, or nil when there is none.
- (BattleOrb *)orbAtColumn:(NSInteger)column row:(NSInteger)row;

// Determines whether there's a tile at the specified column and row.
- (BattleTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;

- (NSSet *) randomizeBoard;

@end
