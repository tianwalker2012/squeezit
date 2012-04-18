//
//  EZTimeSettingController.h
//  Squeezit
//
//  Created by Apple on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZBackgroundView.h"
#import "DragableView.h"

@class DragableView, EZBackgroundView;


@interface EZTimeSettingController : UIViewController<EZTouchHandler,DragContainer,UIScrollViewDelegate>
{
    UIScrollView* scrollView;
    DragableView* dragView;
    UIView* shadowView;
    EZBackgroundView* background;
    DragableView* activeDragableView;
    BOOL animated;
    
}


@end
