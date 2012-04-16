//
//  DragableView.h
//  Squeezit
//
//  Created by Apple on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragableView : UIView
{
    CGRect originalFrame;
    CGPoint prevTouchPoint;
    BOOL animationGoing;
    BOOL moveUp;
    BOOL dragModel;
    UIView* topCycle;
    UIView* bottomCycle;
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end
