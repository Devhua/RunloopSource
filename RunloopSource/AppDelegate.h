//
//  AppDelegate.h
//  RunloopSource
//
//  Created by 华润策 on 16/6/27.
//  Copyright © 2016年 hrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRCRunLoopInputSource.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)fireInputSource:(id)sender;

@end

@interface AppDelegate(Runloop)

- (void)registerSource:(HRCRunLoopContext *)sourceContext;

- (void)removeSource:(HRCRunLoopContext *)sourceContext;

- (void)simulateInputSourceEvent;

@end

