//
//  Live.m
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import "Live.h"
#import <objc/runtime.h>

void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"DynamicMethodIMP~~~~");
}

@implementation Live


//*****oc runtime 测试
//+(BOOL)resolveInstanceMethod:(SEL)sel{
//    if (sel == @selector(test)) {
//        NSLog(@"--哈哈哈-调用我了");
//        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

//runtime 消息转发至另一个对象
-(id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector == @selector(test)) {
        return [Creator new];
    }
    return nil;
}


@end
