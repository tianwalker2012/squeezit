//
//  EZButton.h
//  Squeezit
//
//  Created by Apple on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  Target

#import <UIKit/UIKit.h>

@interface EZButton : UIView
{
    id target;
    SEL tapAction;
}

- (void) addTapTarget:(id)target selector:(SEL)selector;

@end
