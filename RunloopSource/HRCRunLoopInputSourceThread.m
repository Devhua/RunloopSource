//
//  HRCRunLoopInputSourceThread.m
//  RunloopSource
//
//  Created by 华润策 on 16/6/28.
//  Copyright © 2016年 hrc. All rights reserved.
//

#import "HRCRunLoopInputSourceThread.h"
#import "HRCRunLoopInputSource.h"

@interface HRCRunLoopInputSourceThread()<HRCRunLoopInputSourceDelegate>

@property (nonatomic, strong) HRCRunLoopInputSource *source;

@end

@implementation HRCRunLoopInputSourceThread

- (void)main
{
    @autoreleasepool {
        NSLog(@"HRCRunLoopInputSourceThread Enter");
        //获取线程的runloop
        NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
        self.source = [[HRCRunLoopInputSource alloc] init];
        self.source.delegate = self;
        //增加source并将其加入到runloop
        [self.source addToCurrentRunLoop];
        while (!self.cancelled) {
            NSLog(@"Enter Run loop");
            [self doOtherWork];
            [currentRunloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"Exit Run Loop");
        }
        NSLog(@"HRCRunLoopInputSourceThread Exit");
    }
}

- (void)doOtherWork
{
    NSLog(@"Begin Do OtherWork");
    NSLog(@"-------------------");
    NSLog(@"End Do OtherWork");
}

#pragma mark - HRCRunLoopInputSourceDelegate
- (void)source:(HRCRunLoopInputSource *)source command:(NSInteger)command
{
    NSLog(@"command = %ld",command);
}

@end
