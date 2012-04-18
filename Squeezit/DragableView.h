//
//  DragableView.h
//  Squeezit
//
//  Created by Apple on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DragContainer <NSObject>

- (void) dropView:(UIView*)droped;

- (void) setDraggableView:(UIView*)draggable;

- (void) moveDetection:(UIView*)draggable;

@end

@interface DragableView : UIView
{
    CGRect originalFrame;
    CGRect oldLocation;
    CGPoint prevTouchPoint;
    BOOL animationGoing;
    BOOL moveUp;
    BOOL dragModel;
    UIView* topCycle;
    UIView* bottomCycle;
    UIView* parent;
    UIView* shadow;
    id<DragContainer> __weak container;
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

- (void) disableDraggable;

@property (nonatomic, weak) id<DragContainer> container;

@end
