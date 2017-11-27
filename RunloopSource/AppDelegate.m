//
//  AppDelegate.m
//  RunloopSource
//
//  Created by 华润策 on 16/6/27.
//  Copyright © 2016年 hrc. All rights reserved.
//

#import "AppDelegate.h"
#import "HRCRunLoopInputSourceThread.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray *sources;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self startInputSourceRunLoopThread];
    
    return YES;
}

- (void)startInputSourceRunLoopThread
{
    HRCRunLoopInputSourceThread *thread = [[HRCRunLoopInputSourceThread alloc] init];
    [thread start];
}

- (void)fireInputSource:(id)sender
{
    [self simulateInputSourceEvent];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

@implementation AppDelegate (RunLoop)

- (void)registerSource:(HRCRunLoopContext *)sourceContext {
    if (!self.sources) {
        self.sources = [NSMutableArray array];
    }
    [self.sources addObject:sourceContext];
}

- (void)removeSource:(HRCRunLoopContext *)sourceContext {
    [self.sources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HRCRunLoopContext *context = obj;
        if ([context isEqual:sourceContext]) {
            [self.sources removeObject:context];
            *stop = YES;
        }
    }];
}

- (void)simulateInputSourceEvent {
    HRCRunLoopContext *runLoopContext = [self.sources objectAtIndex:0];
    HRCRunLoopInputSource *inputSource = runLoopContext.source;
    NSInteger command = random() % 100;
    [inputSource addCommand:command withData:nil];
    [inputSource fireAllCommandsOnRunLoop:runLoopContext.runLoop];
}

@end
