//
//  AppDelegate.h
//  LevelDesigner
//

//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

#import "BoardConfigWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;

@property (assign) IBOutlet NSTableView *entitiesTable;
@property (nonatomic, retain) IBOutlet id widthSlider;
@property (nonatomic, retain) IBOutlet id heightSlider;
@property (nonatomic, retain) IBOutlet NSView *colorsView;

@property (nonatomic, retain) IBOutlet BoardConfigWindow *boardConfigWindow;

@end
