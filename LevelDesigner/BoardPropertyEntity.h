//
//  BoardPropertyEntity.h
//  LevelDesigner
//
//  Created by Ashwin Kamath on 1/20/15.
//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoardProperty.h"
#import "BattleOrb.h"
#import "BattleTile.h"

@protocol BoardPropertyEntity <NSObject>

- (NSArray *) performChangesAtPosX:(int)posX posY:(int)posY currentProperties:(NSArray *)properties;

@optional;
- (NSImage *) thumbnailIcon;
- (NSString *) title;

@end

@interface BoardPropertyEntity : NSObject <BoardPropertyEntity>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int value;

- (void) customizeNewProperty:(BoardProperty *)bp;
- (BOOL) propertyCanExistSimultaneously:(BoardProperty *)bp;
- (BOOL) foundSameProperty:(BoardProperty *)bp;

@end

@interface OrbColorPropertyEntity : BoardPropertyEntity

- (id) initWithOrbColor:(OrbColor)color;

@end

@interface OrbPowerupPropertyEntity : BoardPropertyEntity

- (id) initWithOrbPowerup:(PowerupType)powerup;

@end

@interface OrbSpecialPropertyEntity : BoardPropertyEntity

- (id) initWithOrbSpecial:(SpecialOrbType)special;

@end

@interface OrbEmptyPropertyEntity : BoardPropertyEntity

@end

@interface HolePropertyEntity : BoardPropertyEntity

- (id) initWithPassibility:(BOOL)isPassable;

@end

@interface OrbLockedPropertyEntity : BoardPropertyEntity

@end

@interface OrbVinesPropertyEntity : BoardPropertyEntity

@end

@interface TileTypePropertyEntity : BoardPropertyEntity

- (id) initWithTileType:(TileType)tileType;

@end

@interface SpawnTilePropertyEntity : BoardPropertyEntity

- (id) initWithShouldSpawn:(BOOL)shouldSpawn;

@end

@interface InitialSkillPropertyEntity : BoardPropertyEntity

@end

@interface ClearTilePropertyEntity : NSObject <BoardPropertyEntity>

@end
