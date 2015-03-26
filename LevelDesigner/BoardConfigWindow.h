//
//  BoardConfigWindow.h
//  LevelDesigner
//
//  Created by Ashwin Kamath on 1/20/15.
//  Copyright (c) 2015 LVL6. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol BoardConfigDelegate <NSObject>

- (void) exportWithBoardConfigWindow:(id)window;
- (void) importWithBoardConfigWindow:(id)window;

@end

@interface BoardConfigWindow : NSWindow <NSAlertDelegate>

@property (nonatomic, retain) IBOutlet NSTextField *boardIdField;
@property (nonatomic, retain) IBOutlet NSTextField *boardPropertyIdField;
@property (nonatomic, retain) IBOutlet NSTextView *boardTextView;
@property (nonatomic, retain) IBOutlet NSTextView *boardPropertyTextView;

@property (nonatomic, assign) id<BoardConfigDelegate> boardConfigDelegate;

@end
