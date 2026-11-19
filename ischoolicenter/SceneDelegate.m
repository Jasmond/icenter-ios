//
//  SceneDelegate.m
//  iCenter
//
//  Created by Jasmond Luk on 25/9/2026.
//  Copyright © 2026 DreamHigh Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneDelegate.h"
#import <UserNotifications/UserNotifications.h>

@implementation SceneDelegate
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    // Lock window size restrictions to prevent resizing in Stage Manager / windowed modes
    if (@available(iOS 13.0, *)) {
        CGSize screenSize = windowScene.coordinateSpace.bounds.size;
        windowScene.sizeRestrictions.minimumSize = screenSize;
        windowScene.sizeRestrictions.maximumSize = screenSize;
    }
    
    
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    // Load the initial view controller from Main.storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *rootVC = [storyboard instantiateInitialViewController];
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    if (@available(iOS 16.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] setBadgeCount:0 withCompletionHandler:nil];
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}



@end
