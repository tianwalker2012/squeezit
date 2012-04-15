//
//  EZTimeInfo.h
//  Squeezit
//
//  Created by Apple on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZTimeInfo : NSObject
{
    NSString* headerStr;
    NSString* timeStr;
    CGPoint start;
    CGPoint end;
    BOOL isDotted;
}

- (id) initWith:(NSString*)header time:(NSString*)time start:(CGPoint)start end:(CGPoint)end isDotted:(BOOL)dotted;

@property (nonatomic, strong) NSString* headerStr;
@property (nonatomic, strong) NSString* timeStr;
@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint end;
@property (nonatomic, assign) BOOL isDotted;

@end
