//
//  BoardBgdView.h
//  BoardDesigner
//
//  Created by Ashwin Kamath on 1/11/15.
//  Copyright (c) 2015 Ashwin Kamath. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BoardLayout.h"

#define TILESIZE 84

@interface BoardBgdLayer : SKNode

- (void) updateForLayout:(BoardLayout *)layout;

@end
