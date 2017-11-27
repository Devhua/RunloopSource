//
//  HRCRunLoopInputSource.h
//  RunloopSource
//
//  Created by 华润策 on 16/6/27.
//  Copyright © 2016年 hrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRCRunLoopInputSource;

@protocol HRCRunLoopInputSourceDelegate <NSObject>

@optional

- (void)source:(HRCRunLoopInputSource *)source command:(NSInteger)command;

@end

@interface HRCRunLoopInputSource : NSObject
{
    CFRunLoopSourceRef _runLoopSource;
    NSMutableArray *_commands;
}

@property (nonatomic, weak) id<HRCRunLoopInputSourceDelegate> delegate;

//增加source到runloop
-(void)addToCurrentRunLoop;
//删除source
-(void)invalidate;
//接收到source事件
-(void)sourceFired;
//提供给外部的command操作接口
-(void)addCommand:(NSInteger)command withData:(id)data;
//command唤醒runloop
-(void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;

@end

//source 和 runloop关联的上下文对象
@interface HRCRunLoopContext : NSObject

@property (nonatomic,assign) CFRunLoopRef runLoop;
@property (nonatomic,strong) HRCRunLoopInputSource *source;

- (instancetype)initWithSource:(HRCRunLoopInputSource *)runLoopInputSource runLoop:(CFRunLoopRef)runLoop;

@end
