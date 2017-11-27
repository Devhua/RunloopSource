//
//  HRCRunLoopInputSource.m
//  RunloopSource
//
//  Created by 华润策 on 16/6/27.
//  Copyright © 2016年 hrc. All rights reserved.
//



#import "AppDelegate.h"
#import "HRCRunLoopInputSource.h"

//注册source的回调
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    HRCRunLoopInputSource *obj = (__bridge HRCRunLoopInputSource *)info;
    AppDelegate *del = [UIApplication  sharedApplication].delegate;
    HRCRunLoopContext *theContext = [[HRCRunLoopContext alloc] initWithSource:obj  runLoop:rl];
    [del performSelectorOnMainThread:@selector(registerSource:)
                          withObject:theContext waitUntilDone:NO];
}
//source唤醒runloop后的回调
void RunLoopSourcePerformRoutine (void *info)
{
    HRCRunLoopInputSource *obj = (__bridge HRCRunLoopInputSource *)info;
    [obj sourceFired];
}

//删除source回调
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    HRCRunLoopInputSource *obj = (__bridge HRCRunLoopInputSource *)info;
    AppDelegate *del = [UIApplication  sharedApplication].delegate;
    HRCRunLoopContext *theContext = [[HRCRunLoopContext alloc] initWithSource:obj
                                                                      runLoop:rl];
    [del performSelectorOnMainThread:@selector(removeSource:)
                          withObject:theContext waitUntilDone:YES];
}

@implementation HRCRunLoopInputSource

- (instancetype)init
{
    if (self = [super init]) {
        //初始化source上下文，注册3个回调函数
        CFRunLoopSourceContext
        context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
            &RunLoopSourceScheduleRoutine,
            RunLoopSourceCancelRoutine,
            RunLoopSourcePerformRoutine};
        //创建source
        _runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
        _commands = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addToCurrentRunLoop
{
    NSLog(@"add to current runloop");
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    //source加入到runloop 并且设置为缺省Mode
    CFRunLoopAddSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

-(void)invalidate
{
    NSLog(@"source invalidate");
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopRemoveSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

-(void)sourceFired
{
    NSLog(@"sourceFired");
    if ([self.delegate respondsToSelector:@selector(source:command:)]) {
        if([_commands count]>0){
            NSInteger command = [_commands[0] integerValue];
            [self.delegate source:self command:command];
            [_commands removeLastObject];
        }
    }
}

-(void)addCommand:(NSInteger)command withData:(id)data
{
    NSLog(@"add command %d with data %@",(int)command,data);
    [_commands addObject:@(command)];
}

//唤醒休眠的runloop
-(void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    NSLog(@"fire all commands on runloop !");
    CFRunLoopSourceSignal(_runLoopSource);
    CFRunLoopWakeUp(runloop);
}

@end

@implementation HRCRunLoopContext

- (instancetype)initWithSource:(HRCRunLoopInputSource *)runLoopInputSource runLoop:(CFRunLoopRef)runLoop
{
    self = [super init];
    if (self) {
        _source = runLoopInputSource;
        _runLoop = runLoop;
    }
    return self;
}

@end


