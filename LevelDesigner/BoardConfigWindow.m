//
//  BoardConfigWindow.m
//  LevelDesigner
//
//  Created by Ashwin Kamath on 1/20/15.
//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import "BoardConfigWindow.h"

@implementation BoardConfigWindow

- (IBAction)importClicked:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.alertStyle = NSWarningAlertStyle;
  alert.messageText = @"Are you sure you would like to overwrite your current layout?";
  [alert addButtonWithTitle:@"Yes"];
  [alert addButtonWithTitle:@"Cancel"];
  [alert beginSheetModalForWindow:self completionHandler:^(NSModalResponse returnCode) {
    if (returnCode == NSAlertFirstButtonReturn) {
      [self.boardConfigDelegate importWithBoardConfigWindow:self];
    }
  }];
}

- (IBAction)exportClicked:(id)sender {
  [self.boardConfigDelegate exportWithBoardConfigWindow:self];
}

@end
