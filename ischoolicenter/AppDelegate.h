//
//  AppDelegate.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 28/7/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "MyObject.h"
#import "MainViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>{
    sqlite3 *isdb;
    GlobalVariables *globalvariables;
    BOOL gotomessage;
}

@property (strong, nonatomic) UIWindow *window;


@end

