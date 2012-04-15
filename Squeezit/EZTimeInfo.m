//
//  EZTimeInfo.m
//  Squeezit
//
//  Created by Apple on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTimeInfo.h"

@implementation EZTimeInfo
@synthesize headerStr, timeStr, start, end, isDotted;

- (id) initWith:(NSString*)header time:(NSString*)time start:(CGPoint)star end:(CGPoint)endi isDotted:(BOOL)dotted
{
    self = [super init];
    self.headerStr = header;
    self.timeStr = time;
    self.start = star;
    self.end = endi;
    self.isDotted = dotted;
    return self;
}


@end
