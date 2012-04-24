//
//  AppDelegate.m
//  HelloGLKit
//
//  Created by Steve Baker on 4/23/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate {
    float curRed;
    BOOL increasing;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    EAGLContext * context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.context = context;
    view.delegate = self;
    
    increasing = YES;
    curRed = 0.0;
    
    GLKViewController * viewController = [[GLKViewController alloc] initWithNibName:nil bundle:nil]; // 1
    viewController.view = view; // 2
    viewController.delegate = self; // 3
    viewController.preferredFramesPerSecond = 60; // 4
    self.window.rootViewController = viewController; // 5
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    if (increasing) {
        curRed += 0.01;
    } else {
        curRed -= 0.01;
    }
    if (curRed >= 1.0) {
        curRed = 1.0;
        increasing = NO;
    }
    if (curRed <= 0.0) {
        curRed = 0.0;
        increasing = YES;
    }
    
    glClearColor(curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
}

- (void)render:(CADisplayLink*)displayLink {
    GLKView * view = [self.window.subviews objectAtIndex:0];
    [view display];
}

@end
