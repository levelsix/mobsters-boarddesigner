//
//  UIView+Coordinates.h
//  Extended UI
//

#import <Cocoa/Cocoa.h>


static inline CGPoint ccp( CGFloat x, CGFloat y )
{
  return CGPointMake(x, y);
}

@interface NSView (Coordinates)

@property (nonatomic) CGFloat originX;
@property (nonatomic) CGFloat originY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGSize size;

@property (nonatomic) CGPoint center;

@end