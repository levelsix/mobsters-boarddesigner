//
//  AppDelegate.m
//  LevelDesigner
//
//  Created by Ashwin Kamath on 1/19/15.
//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import "AppDelegate.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
  /* Retrieve scene file path from the application bundle */
  NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
  /* Unarchive the file to an SKScene object */
  NSData *data = [NSData dataWithContentsOfFile:nodePath
                                        options:NSDataReadingMappedIfSafe
                                          error:nil];
  NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  [arch setClass:self forClassName:@"SKScene"];
  SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
  [arch finishDecoding];
  
  return scene;
}

@end

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  for (NSWindow *win in [NSApp windows]) {
    win.canHide = NO;
  }
  
  GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
  
  scene.entitiesTable = self.entitiesTable;
  scene.widthSlider = self.widthSlider;
  scene.heightSlider = self.heightSlider;
  scene.colorsView = self.colorsView;
  self.boardConfigWindow.boardConfigDelegate = scene;
  
  /* Set the scale mode to scale to fit the window */
  scene.scaleMode = SKSceneScaleModeAspectFit;
  
  [self.skView presentScene:scene];
  
  /* Sprite Kit applies additional optimizations to improve rendering performance */
  self.skView.ignoresSiblingOrder = YES;
  
  self.skView.showsFPS = YES;
  self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

- (BOOL) windowShouldClose:(id)sender {
  return NO;
}

@end
