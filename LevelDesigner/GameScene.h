//
//  GameScene.h
//  LevelDesigner
//

//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BoardLayout.h"
#import "BoardBgdLayer.h"
#import "OrbLayer.h"
#import "BoardPropertyEntity.h"
#import "BoardConfigWindow.h"

@interface GameScene : SKScene <NSTableViewDelegate, NSTableViewDataSource, BoardConfigDelegate> {
  BoardPropertyEntity *_currentEntity;
}

@property (nonatomic, retain) BoardLayout *layout;

@property (nonatomic, retain) BoardBgdLayer *bgdLayer;
@property (nonatomic, retain) OrbLayer *orbLayer;

@property (nonatomic, retain) NSArray *entitiesList;

@property (nonatomic, retain) NSTableView *entitiesTable;
@property (nonatomic, retain) NSSlider *widthSlider;
@property (nonatomic, retain) NSSlider *heightSlider;
@property (nonatomic, retain) NSView *colorsView;

@end
