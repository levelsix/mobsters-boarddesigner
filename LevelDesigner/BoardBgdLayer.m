//
//  BoardBgdView.m
//  BoardDesigner
//
//  Created by Ashwin Kamath on 1/11/15.
//  Copyright (c) 2015 Ashwin Kamath. All rights reserved.
//

#import "BoardBgdLayer.h"

#import "TileSprite.h"

@implementation BoardBgdLayer

- (void) updateForLayout:(BoardLayout *)layout {
  for (SKNode *v in self.children.copy) {
    if ([v isKindOfClass:[SKSpriteNode class]] ||
        [v isKindOfClass:[TileSprite class]] ||
        [v isKindOfClass:[SKShapeNode class]]) {
      [v removeFromParent];
    }
  }
  
  // Setup board background
  CGSize gridSize = CGSizeMake(layout.numColumns, layout.numRows);
  int tileSize = TILESIZE;
  for (int i = 0; i < gridSize.width; i++) {
    for (int j = 0; j < gridSize.height; j++) {
      BattleTile *tile = [layout tileAtColumn:i row:j];
      
      if (!tile.isHole) {
        NSString *fileName = (i+j)%2==0 ? @"lightboardsquare" : @"darkboardsquare";
        
        SKSpriteNode *square = [SKSpriteNode spriteNodeWithImageNamed:fileName];
        square.xScale = tileSize;
        square.yScale = tileSize;
        
        [self addChild:square];
        square.position = ccp((i+0.5)*tileSize, (j+0.5)*tileSize);
        
        if (tile.typeBottom) {
          TileSprite *ts = [TileSprite tileSpriteWithTile:tile depth:TileDepthBottom];
          ts.position = square.position;
          
          [self addChild:ts];
        }
      } else if (tile.canPassThrough) {
        SKSpriteNode *square = [SKSpriteNode spriteNodeWithImageNamed:@"6passablearrow.png"];
        
        [self addChild:square];
        
        square.position = ccp((i+0.5)*tileSize, (j+0.5)*tileSize);
      }
      
      if (tile.canSpawnOrbs) {
        SKSpriteNode *line = [SKSpriteNode spriteNodeWithColor:[NSColor greenColor] size:CGSizeMake(tileSize, 4)];
        [self addChild:line];
        line.zPosition = 3.f;
        line.position = ccp((i+0.5)*tileSize, (j+1)*tileSize);
      }
      
      if (tile.shouldSpawnInitialSkill) {
        SKShapeNode *rect = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(tileSize, tileSize) cornerRadius:2];
        [self addChild:rect];
        rect.lineWidth = 2.f;
        rect.strokeColor = [NSColor redColor];
        rect.zPosition = 3.f;
        rect.position = ccp((i+0.5)*tileSize, (j+0.5)*tileSize);
      }
    }
  }
  
  CGSize size = CGSizeMake(tileSize*gridSize.width*self.xScale, tileSize*gridSize.height*self.yScale);
  self.position = ccp(self.parent.frame.size.width/2-size.width/2, self.parent.frame.size.height/2-size.height/2);
}

@end
