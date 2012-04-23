//
//  DragableView.h
//  Squeezit
//
//  Created by Apple on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DragContainer <NSObject>

//Appearantly, the interface need refactor. 
//My current strategy is to get it as simple and stupid as possible.
//My next goal will be to refector it. Make it clean and straightforward. 
- (void) dropView:(UIView*)droped;

- (void) setDraggableView:(UIView*)draggable;

- (void) moveDetection:(UIView*)draggable;

- (void) dismissShadow:(UIView*)shadow;


//Following method are related with stretch
- (void) stretchBegan:(UIView*)stretched;

- (void) stretchMoved:(UIView*)stretched;

- (void) stretchEnded:(UIView*)stretched;

- (void) setScrollEnabled:(BOOL)endabled;

- (void) scrollStep:(CGFloat)step stopDelegate:(id)delegate;

//Tell the dragView what will the proper frame size and position
-(CGRect) normalizeFrame:(CGRect)frame;

@end

@protocol StretchTouchHandler <NSObject>

- (void)stretchTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)stretchTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)stretchTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)stretchTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface DragableView : UIView<StretchTouchHandler,UIScrollViewDelegate>
{
    CGRect originalFrame;
    CGRect oldLocation;
    CGPoint prevTouchPoint;
    CGPoint prevStretchPoint;
    BOOL animationGoing;
    BOOL moveUp;
    BOOL dragModel;
    BOOL stretchModel;
    UIView* topCycle;
    UIView* bottomCycle;
    UIView* parent;
    UIView* shadow;
    UIView* background;
    UITouch* currentStretchTouch;
    UITouch* recordedStretchTouch;
    id<UIScrollViewDelegate>  __weak oldScrollDelegate;
    id<DragContainer, UIScrollViewDelegate> __weak container;
}

- (void) disableDraggable;

- (void) addStretchControl;

- (void) adjustStretchControl;

- (void) stretchScoll:(UITouch*)touch;

@property (nonatomic, weak) id<DragContainer,UIScrollViewDelegate> container;
@property (nonatomic, strong) UIView* background;
@property (nonatomic, weak) id<UIScrollViewDelegate> oldScrollDelegate;

@end
