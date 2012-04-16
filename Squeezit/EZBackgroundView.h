//
//  EZBackgroundView.h
//  Squeezit
//
//  Created by Apple on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EZTouchHandler <NSObject>

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface EZBackgroundView : UIView
{
    id<EZTouchHandler> __weak touchHandler;
}
    
@property (nonatomic, weak) id<EZTouchHandler> touchHandler;

@end
