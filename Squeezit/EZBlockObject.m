//
//  EZBlockObject.m
//  Squeezit
//
//  Created by Apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZBlockObject.h"

@implementation EZBlockObject
@synthesize name;

- (id) initWithName:(NSString *)nm
{
    self = [super init];
    name = nm;
    return self;
}

- (void) dealloc
{
    NSLog(@"Get dealloced: %@",name);
}

- (EZBlock) createBlock
{
    EZBlockObject* stackBlock = [[EZBlockObject alloc] initWithName:@"Stack block"];
    child = [[EZBlockObject alloc] initWithName:@"child block"];
    return ^(){ 
        NSLog(@"Block executed, name:%@",self.name); 
        NSLog(@"Member block: %@",child.name);
        NSLog(@"Stack block:%@",stackBlock.name);
    };
}

@end
