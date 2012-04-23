//
//  EZBlockObject.h
//  Squeezit
//
//  Created by Apple on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EZBlock)(void);

@interface EZBlockObject : NSObject {
    NSString* name;
    EZBlockObject* child;
}

- (id) initWithName:(NSString*)name;

- (EZBlock) createBlock;

@property (nonatomic, strong) NSString* name;

@end
