//
//  GameScene.m
//  LevelDesigner
//
//  Created by Ashwin Kamath on 1/19/15.
//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
  [self createEntitiesList];
  
  self.layout = [[BoardLayout alloc] initWithGridSize:CGSizeMake(9, 9) numColors:0b1111110 properties:nil];
  
  self.bgdLayer = [[BoardBgdLayer alloc] init];
  [self addChild:self.bgdLayer];
  
  self.orbLayer = [[OrbLayer alloc] init];
  self.orbLayer.zPosition = 1.f;
  [self.bgdLayer addChild:self.orbLayer];
  
  [self updateView];
}

- (void) updateView {
  NSSet *orbs = [self.layout randomizeBoard];
  
  [self.bgdLayer updateForLayout:self.layout];
  [self.orbLayer addSpritesForOrbs:orbs];
  
  self.widthSlider.intValue = self.layout.numColumns;
  self.heightSlider.intValue = self.layout.numRows;
  
  for (int i = OrbColorFire; i < OrbColorNone; i++) {
    NSButton *b = [self.colorsView viewWithTag:i];
    b.alphaValue = (self.layout.colorMask & (1 << i)) + 0.5;
  }
}

-(void)mouseDown:(NSEvent *)theEvent {
  /* Called when a mouse click occurs */
  
  CGPoint location = [theEvent locationInNode:self.bgdLayer];
  
  // Convert click into a board coordinate
  int column, row;
  if ([self convertPoint:location toColumn:&column row:&row]) {
    NSArray *arr = [self.layout propertiesForColumn:column row:row];
    NSArray *new = [_currentEntity performChangesAtPosX:column posY:row currentProperties:arr];
    
    [self.layout.properties removeObjectsInArray:arr];
    [self.layout.properties addObjectsFromArray:new];
    
    [self updateView];
  }
}

// Converts a point relative to the orbLayer into column and row numbers.
- (BOOL) convertPoint:(CGPoint)point toColumn:(int *)column row:(int *)row {
  
  // "column" and "row" are output parameters, so they cannot be nil.
  NSParameterAssert(column);
  NSParameterAssert(row);
  
  int tileSize = TILESIZE;
  int numColumns = self.layout.numColumns;
  int numRows = self.layout.numRows;
  
  // Is this a valid location within the orbs layer? If yes,
  // calculate the corresponding row and column numbers.
  if (point.x >= 0 && point.x < numColumns*tileSize &&
      point.y >= 0 && point.y < numRows*tileSize) {
    
    *column = point.x / tileSize;
    *row = point.y / tileSize;
    return YES;
    
  }
  
  return NO;
}

#pragma mark - Properties

- (void) createEntitiesList {
  // Create the list
  NSMutableArray *arr = [NSMutableArray array];
  
  [arr addObject:[[ClearTilePropertyEntity alloc] init]];
  
  for (int i = OrbColorFire; i < OrbColorNone; i++) {
    [arr addObject:[[OrbColorPropertyEntity alloc] initWithOrbColor:i]];
  }
  
  for (int i = PowerupTypeHorizontalLine; i <= PowerupTypeAllOfOneColor; i++) {
    [arr addObject:[[OrbPowerupPropertyEntity alloc] initWithOrbPowerup:i]];
  }
  
  [arr addObject:[[OrbSpecialPropertyEntity alloc] initWithOrbSpecial:SpecialOrbTypeCloud]];
  
  [arr addObject:[[OrbLockedPropertyEntity alloc] init]];
  
  [arr addObject:[[OrbEmptyPropertyEntity alloc] init]];
  
  [arr addObject:[[TileTypePropertyEntity alloc] initWithTileType:TileTypeJelly]];
  
  [arr addObject:[[InitialSkillPropertyEntity alloc] init]];
  
  [arr addObject:[[HolePropertyEntity alloc] initWithPassibility:NO]];
  [arr addObject:[[HolePropertyEntity alloc] initWithPassibility:YES]];
  
  [arr addObject:[[SpawnTilePropertyEntity alloc] initWithShouldSpawn:YES]];
  [arr addObject:[[SpawnTilePropertyEntity alloc] initWithShouldSpawn:NO]];
  
  self.entitiesList = arr;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
  return self.entitiesList.count;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return self.entitiesList[row];
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification {
  NSTableView *table = notification.object;
  _currentEntity = self.entitiesList[table.selectedRow];
}

- (void) setEntitiesTable:(NSTableView *)entitiesTable {
  _entitiesTable = entitiesTable;
  entitiesTable.dataSource = self;
  entitiesTable.delegate = self;
}

- (void) setWidthSlider:(NSSlider *)widthSlider {
  _widthSlider = widthSlider;
  [widthSlider setTarget:self];
  [widthSlider setAction:@selector(widthSliderChanged)];
}

- (void) setHeightSlider:(NSSlider *)heightSlider {
  _heightSlider = heightSlider;
  [heightSlider setTarget:self];
  [heightSlider setAction:@selector(heightSliderChanged)];
}

- (void) setColorsView:(NSView *)colorsView {
  _colorsView = colorsView;
  
  for (int i = OrbColorFire; i < OrbColorNone; i++) {
    BattleOrb *orb = [[BattleOrb alloc] init];
    orb.orbColor = i;
    NSImage *img = [NSImage imageNamed:[OrbSprite orbSpriteImageNameWithOrb:orb]];
    
    NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 21, 21)];
    button.bordered = NO;
    
    int idx = i-OrbColorFire;
    button.center = ccp(10+30*(idx%3), 12+30*(1-idx/3));
    [button setImage:img];
    button.tag = i;
    
    button.target = self;
    button.action = @selector(orbClicked:);
    
    [colorsView addSubview:button];
    
    button.layer.sublayerTransform = CATransform3DMakeScale(0.1, 0.1, 0.f);
  }
}

- (void) widthSliderChanged {
  self.layout.numColumns = MAX(MIN(9, self.widthSlider.intValue), 2);
  [self updateView];
}

- (void) heightSliderChanged {
  self.layout.numRows = MAX(MIN(9, self.heightSlider.intValue), 2);
  [self updateView];
}

- (void) orbClicked:(NSButton *)sender {
  int tag = (int)sender.tag;
  self.layout.colorMask ^= (1<<tag);
  [self updateView];
}

#pragma mark - Board Config Delegate

- (NSString *)getBitStringForInt:(int)value {
  NSMutableString *s = [NSMutableString stringWithFormat:@""];
  for (int i = OrbColorFire; i < OrbColorNone; i++) {
    [s appendFormat:@"%d", !!(self.layout.colorMask & (1<<i))];
  }
  return s;
}

- (void) exportWithBoardConfigWindow:(BoardConfigWindow *)window {
  int boardId = window.boardIdField.stringValue.intValue;
  int boardPropId = window.boardPropertyIdField.stringValue.intValue;
  
  NSString *str = [NSString stringWithFormat:@"'%d', '%d', '%d', '%@'", boardId, self.layout.numColumns, self.layout.numRows, [self getBitStringForInt:self.layout.colorMask]];
  window.boardTextView.string = str;
  
  NSMutableString *props = [NSMutableString stringWithFormat:@""];
  for (BoardProperty *prop in self.layout.properties) {
    [props appendFormat:@"'%d', '%d', '%@', '%d', '%d', NULL, %@, %@\n", boardPropId++, boardId, prop.name, prop.posX, prop.posY, prop.value ? [NSString stringWithFormat:@"'%d'", prop.value] : @"NULL", prop.quantity ? [NSString stringWithFormat:@"'%d'", prop.quantity] : @"NULL"];
  }
  window.boardPropertyTextView.string = props;
}

- (void) importWithBoardConfigWindow:(BoardConfigWindow *)window {
  NSString *boardStr = [window.boardTextView.string stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSArray *chunks = [boardStr componentsSeparatedByString:@","];
  
  for (int i = 0; i < chunks.count; i++) {
    NSString *chunk = [chunks[i] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    if (i == 0) {
      int val = chunk.intValue;
      if (val > 0) {
        window.boardIdField.intValue = val;
      }
    } else if (i == 1) {
      self.layout.numColumns = chunk.intValue;
    } else if (i == 2) {
      self.layout.numRows = chunk.intValue;
    } else if (i == 3) {
      int colorMask = 0;
      for (int i = OrbColorFire; i <= OrbColorNone && chunk.length > 0; i++) {
        NSString *cur = [chunk substringToIndex:1];
        int val = [cur intValue];
        
        colorMask |= val << i;
        
        chunk = [chunk substringFromIndex:1];
      }
      
      self.layout.colorMask = colorMask;
    }
  }
  
  [self.layout.properties removeAllObjects];
  
  int lowestPropId = 0;
  
  NSString *propsStr = window.boardPropertyTextView.string;
  for (NSString *propStr in [propsStr componentsSeparatedByString:@"\n"]) {
    NSArray *chunks = [[[propStr stringByReplacingOccurrencesOfString:@"'" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@","];
    
    if (chunks.count > 2) {
      BoardProperty *prop = [[BoardProperty alloc] init];
      
      for (int i = 0; i < chunks.count; i++) {
        
        NSString *chunk = chunks[i];
        
        if (![chunk isEqualToString:@"NULL"]) {
          if (i == 0) {
            int propId = chunk.intValue;
            if (!lowestPropId || propId < lowestPropId) {
              lowestPropId = propId;
            }
          } else if (i == 2) {
            prop.name = chunk;
          } else if (i == 3) {
            prop.posX = chunk.intValue;
          } else if (i == 4) {
            prop.posY = chunk.intValue;
          } else if (i == 6) {
            prop.value = chunk.intValue;
          } else if (i == 7) {
            prop.quantity = chunk.intValue;
          }
        }
      }
      
      [self.layout.properties addObject:prop];
    }
  }
  
  if (lowestPropId) {
    window.boardPropertyIdField.intValue = lowestPropId;
  }
  
  [self updateView];
}

@end
