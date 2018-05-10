//
//  NSURL+depth.m
//  Spider-Mac
//
//  Created by Mac on 2018/5/1.
//

#import "NSURL+depth.h"
#import <objc/runtime.h>

static const void * depth_key = "depth_key";

@implementation NSURL (depth)
@dynamic depth;

- (NSUInteger)depth{
    return [objc_getAssociatedObject(self, depth_key) unsignedIntegerValue];
}

- (void)setDepth:(NSUInteger)depth{
    objc_setAssociatedObject(self, depth_key, @(depth), OBJC_ASSOCIATION_ASSIGN);
}

@end
