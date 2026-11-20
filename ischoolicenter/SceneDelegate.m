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

static void *SceneWindowBoundsContext = &SceneWindowBoundsContext;

@interface SceneDelegate ()
- (void)parkSidePanelsInWindow:(UIWindow *)window previousWidth:(CGFloat)previousWidth;
@end

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
    [self.window addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:SceneWindowBoundsContext];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    if (self.window) {
        @try {
            [self.window removeObserver:self forKeyPath:@"bounds" context:SceneWindowBoundsContext];
        } @catch (NSException *exception) {
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != SceneWindowBoundsContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    CGRect oldBounds = [change[NSKeyValueChangeOldKey] CGRectValue];
    CGRect newBounds = [change[NSKeyValueChangeNewKey] CGRectValue];
    if (fabs(oldBounds.size.width - newBounds.size.width) < 0.5 && fabs(oldBounds.size.height - newBounds.size.height) < 0.5) {
        return;
    }
    UIWindow *window = (UIWindow *)object;
    CGFloat previousWidth = oldBounds.size.width;
    // Apply after the current animation transaction. Changing frames inside the
    // bounds callback joins the side-panel open animation and slides it shut.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self parkSidePanelsInWindow:window previousWidth:previousWidth];
    });
}

- (void)parkSidePanelsInWindow:(UIWindow *)window previousWidth:(CGFloat)previousWidth {
    (void)previousWidth;
    CGFloat windowWidth = window.bounds.size.width;
    CGFloat windowHeight = window.bounds.size.height;
    for (UIView *subview in [window.subviews copy]) {
        if (subview.tag != -200 || [subview isKindOfClass:[UIButton class]]) {
            continue;
        }
        subview.autoresizingMask = UIViewAutoresizingNone;
        CGFloat origin = subview.frame.origin.x;
        CGFloat panelSpan = subview.frame.size.width;
        CGFloat maxX = origin + panelSpan;
        CGRect intersection = CGRectIntersection(subview.frame, CGRectMake(0, 0, windowWidth, windowHeight));
        CGFloat visibleWidth = CGRectIsNull(intersection) ? 0 : intersection.size.width;
        // A parked panel is wider than the part of it that is actually on screen,
        // so resizing reveals a gray strip. An open panel is fully on screen.
        BOOL sliver = panelSpan > 1.0 && visibleWidth > 0 && visibleWidth < panelSpan - 24.0;
        BOOL openPanel = !subview.hidden && panelSpan > 1.0 && !sliver && origin < windowWidth - 1.0 && maxX <= windowWidth + 1.0;
        if (!openPanel) {
            subview.hidden = YES;
            subview.frame = CGRectMake(windowWidth, 0, 0, windowHeight);
            continue;
        }
        CGFloat panelWidth = MIN(panelSpan, windowWidth);
        CGRect target = CGRectMake(windowWidth - panelWidth, 0, panelWidth, windowHeight);
        if (CGRectEqualToRect(subview.frame, target)) {
            continue;
        }
        [UIView performWithoutAnimation:^{
            subview.frame = target;
            for (UIView *child in subview.subviews) {
                if ([child isKindOfClass:[UIActivityIndicatorView class]]) {
                    continue;
                }
                child.frame = subview.bounds;
            }
        }];
    }
    BOOL anyPanelVisible = NO;
    for (UIView *subview in window.subviews) {
        if (subview.tag == -200 && ![subview isKindOfClass:[UIButton class]] && !subview.hidden && subview.frame.size.width > 1.0 && subview.frame.origin.x < windowWidth - 1.0) {
            anyPanelVisible = YES;
            break;
        }
    }
    if (!anyPanelVisible) {
        for (UIView *subview in window.subviews) {
            if (subview.tag == -200 && [subview isKindOfClass:[UIButton class]]) {
                subview.hidden = YES;
            }
        }
    }
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    if (@available(iOS 16.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] setBadgeCount:0 withCompletionHandler:nil];
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}



@end
