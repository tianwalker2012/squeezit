//
//  EZTimeSettingController.h
//  Squeezit
//
//  Created by Apple on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZBackgroundView.h"
@class DragableView, EZBackgroundView;


@interface EZTimeSettingController : UIViewController<EZTouchHandler>
{
    UIScrollView* scrollView;
    DragableView* dragView;
    EZBackgroundView* background;
    
}


@end
