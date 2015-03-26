//
//  BoardProperty.h
//  BoardDesigner
//
//  Created by Ashwin Kamath on 1/11/15.
//  Copyright (c) 2015 Ashwin Kamath. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PROP_EQUALS(a, b) [a isEqualToString:b]

#define SPAWN_TILE @"SPAWN_TILE"
#define NOT_SPAWN_TILE @"NOT_SPAWN_TILE"

#define HOLE @"HOLE"
#define PASSABLE_HOLE @"PASSABLE_HOLE"

#define ORB_COLOR @"ORB_COLOR"
#define ORB_POWERUP @"ORB_POWERUP"
#define ORB_SPECIAL @"ORB_SPECIAL"
#define ORB_EMPTY @"ORB_EMPTY"
#define ORB_LOCKED @"ORB_LOCKED"
#define ORB_VINES @"ORB_VINES"
#define TILE_TYPE @"TILE_TYPE"

#define INITIAL_SKILL @"INITIAL_SKILL"

#define MAX_CLOUD_COUNTER 2


@interface BoardProperty : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int posX;
@property (nonatomic, assign) int posY;
@property (nonatomic, assign) int value;
@property (nonatomic, assign) int quantity;

@end
