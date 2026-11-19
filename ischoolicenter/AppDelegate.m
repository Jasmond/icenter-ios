//
//  AppDelegate.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 28/7/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "AppDelegate.h"
#import "MyClass.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "SDImageCache.h"

#define ReloadTimeoutInMinute 720
#define RefreshTimeoutInMinute 5

@interface AppDelegate ()
{
    AVAudioPlayer *beepPlayer;
}

@end

@implementation AppDelegate


            
/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}*/

//- (void)applicationWillResignActive:(UIApplication *)application {
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//
//    
//    globalvariables=[GlobalVariables singleObj];
//    [MyClass updatelocaldbwithparameter:@"lastlogout" value:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"]];
//
//    if(![globalvariables.generalphpfullpath isEqualToString:@""] && globalvariables.username && ![globalvariables.username isEqualToString:@""]){
//        //reset badgecount
//        NSString *strURL=[NSString stringWithFormat:@"%@?action=resetbadgecount&username=%@&appname=%@&iparentos=%@",globalvariables.generalphpfullpath,globalvariables.username,@"iCenter",@"iOS"];
//        
//        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
//        }];
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    globalvariables=[GlobalVariables singleObj];
    [MyClass updatelocaldbwithparameter:@"lastlogout" value:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"]];

    if(![globalvariables.generalphpfullpath isEqualToString:@""] && globalvariables.username && ![globalvariables.username isEqualToString:@""]){
        NSString *strURL=[NSString stringWithFormat:@"%@?action=resetbadgecount&username=%@&appname=%@&iparentos=%@",globalvariables.generalphpfullpath,globalvariables.username,@"iCenter",@"iOS"];
        [MyClass callGETwithURL:strURL completionBlock:nil];
    }
    
    [self clearBadgeCount];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    
    
    globalvariables=[GlobalVariables singleObj];
    
    
    if (globalvariables.backfromappstore) {
        globalvariables.backfromappstore=FALSE;
        globalvariables.appbecomeactiveaction=@"reload";
    }else{
        NSDate *lastlogoutdate=[MyClass convertToNSDateWithDate:[MyClass getlocaldbwithparameter:@"lastlogout"] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSTimeInterval secondsBetween=[[NSDate date] timeIntervalSinceDate:lastlogoutdate];
        
        if (secondsBetween>ReloadTimeoutInMinute*60) {
            globalvariables.appbecomeactiveaction=@"reload";
            [[SDImageCache sharedImageCache]clearMemory];
            [[SDImageCache sharedImageCache]clearDiskOnCompletion:nil];
        }else if (secondsBetween>RefreshTimeoutInMinute*60){
            globalvariables.appbecomeactiveaction=@"refresh";
        }
    }
    
    

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self clearBadgeCount];
}

- (void)clearBadgeCount {
    if (@available(iOS 16.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] setBadgeCount:0 withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error clearing badge count: %@", error.localizedDescription);
            }
        }];
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

    // Show banner, sound, and update badge even while the app is active in the foreground
    completionHandler(UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    
//
//    gotomessage=NO;
//    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
//        gotomessage=YES;
//    }
//    
//
//    
//    return YES;
    
    // Request notification permissions using UNUserNotificationCenter
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
        UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        
        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            } else if (error) {
                NSLog(@"Notification authorization error: %@", error.localizedDescription);
            }
        }];

        gotomessage = NO;
        if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
            gotomessage = YES;
        }

        return YES;
}

- (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];

    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }

    return [token copy];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{

    
    globalvariables=[GlobalVariables singleObj];
    globalvariables.deviceToken=[self stringWithDeviceToken:deviceToken];
    
    if (gotomessage) {
//        globalvariables.firstredirectscreen=@"6";
    }


}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    globalvariables=[GlobalVariables singleObj];
    NSLog(@"Failed to get token, error: %@", error);
    globalvariables.deviceToken=@"";
}


//-(void) application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
//{
//    globalvariables=[GlobalVariables singleObj];
//    //NSLog(@"%li",(long)application.applicationState);
////    MainViewController *mainviewcontroller = (MainViewController*) [self.window rootViewController];
//    // Safely retrieve MainViewController across window scenes
//        MainViewController *mainviewcontroller = [self activeMainViewController];
//    
//    if ([userInfo[@"category"] isEqualToString:@"documenttrigger"]) {
//        NSLog(@"Document Triggered");
//        if (application.applicationState != UIApplicationStateActive && !globalvariables.documentfolderdict){
//
//            [mainviewcontroller sendOutboxDocument];
//            globalvariables.documentfolderdict=nil;
//            completionHandler(UIBackgroundFetchResultNewData);
//        }
//    }else if ([userInfo[@"category"] isEqualToString:@"assessmenttrigger"]) {
//        NSLog(@"Asessment Triggered");
//        if (application.applicationState != UIApplicationStateActive && !globalvariables.documentfolderdict){
//
//            [mainviewcontroller sendAssessmentReport];
//            globalvariables.documentfolderdict=nil;
//            completionHandler(UIBackgroundFetchResultNewData);
//        }
//    }else if ([userInfo[@"category"] isEqualToString:@"messagepreload"]) {
//        NSLog(@"messagepreload Triggered");
//        float randomsec=(arc4random() %(100)-1)/10.0;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randomsec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (application.applicationState == UIApplicationStateBackground){
//                if (userInfo[@"centerkey"] && [globalvariables.centerrecord.centerkey isEqualToString:userInfo[@"centerkey"]]) {
//                    [mainviewcontroller backgroundretrievemessagecontactlistwithcenterkey:userInfo[@"centerkey"]];
//                }
//            }
//            completionHandler(UIBackgroundFetchResultNewData);
//        });
//    }else{
//        if (application.applicationState == UIApplicationStateActive){
//            if ([globalvariables.centerrecord.centerkey isEqualToString:userInfo[@"centerkey"]]) {
//                if ([globalvariables.leftmenuindex intValue]==6) {
//                    globalvariables.appbecomeactiveaction=@"refresh";
//                    [mainviewcontroller refreshscreenindex:6];
//                }
//                [MyClass playBeepSoundWithType:@"newmessage"];
//            }
//            
//        }else{
//            [self switchCenterToCenter:userInfo];
////            globalvariables.firstredirectscreen=@"6";
//            globalvariables.messagecontactrecord=[[MessageContactRecord alloc]init];
//            globalvariables.messagecontactrecord.messagecontact=userInfo[@"messagecontact"];
//            globalvariables.messagecontactrecord.messagecontacttype=userInfo[@"messagecontacttype"];
//            globalvariables.messagecontactrecord.centerkey=userInfo[@"centerkey"];
//            [mainviewcontroller gotoscreenindex:6 pageindex:-1 keyindex:-1];
//        }
//        completionHandler(UIBackgroundFetchResultNewData);
//    }
//    
//    //completionHandler(UIBackgroundFetchResultNewData);
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    globalvariables = [GlobalVariables singleObj];
    
    // Safely retrieve MainViewController across window scenes
    MainViewController *mainviewcontroller = [self activeMainViewController];
    
    if ([userInfo[@"category"] isEqualToString:@"documenttrigger"]) {
        NSLog(@"Document Triggered");
        if (application.applicationState != UIApplicationStateActive && !globalvariables.documentfolderdict) {
            [mainviewcontroller sendOutboxDocument];
            globalvariables.documentfolderdict = nil;
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    } else if ([userInfo[@"category"] isEqualToString:@"assessmenttrigger"]) {
        NSLog(@"Assessment Triggered");
        if (application.applicationState != UIApplicationStateActive && !globalvariables.documentfolderdict) {
            [mainviewcontroller sendAssessmentReport];
            globalvariables.documentfolderdict = nil;
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    } else if ([userInfo[@"category"] isEqualToString:@"messagepreload"]) {
        NSLog(@"messagepreload Triggered");
        float randomsec = (arc4random() % (100) - 1) / 10.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randomsec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (application.applicationState == UIApplicationStateBackground) {
                if (userInfo[@"centerkey"] && [globalvariables.centerrecord.centerkey isEqualToString:userInfo[@"centerkey"]]) {
                    [mainviewcontroller backgroundretrievemessagecontactlistwithcenterkey:userInfo[@"centerkey"]];
                }
            }
            completionHandler(UIBackgroundFetchResultNewData);
        });
    } else {
        if (application.applicationState == UIApplicationStateActive) {
            if ([globalvariables.centerrecord.centerkey isEqualToString:userInfo[@"centerkey"]]) {
                if ([globalvariables.leftmenuindex intValue] == 6) {
                    globalvariables.appbecomeactiveaction = @"refresh";
                    [mainviewcontroller refreshscreenindex:6];
                }
                [MyClass playBeepSoundWithType:@"newmessage"];
            }
        } else {
            [self switchCenterToCenter:userInfo];
            globalvariables.messagecontactrecord = [[MessageContactRecord alloc] init];
            globalvariables.messagecontactrecord.messagecontact = userInfo[@"messagecontact"];
            globalvariables.messagecontactrecord.messagecontacttype = userInfo[@"messagecontacttype"];
            globalvariables.messagecontactrecord.centerkey = userInfo[@"centerkey"];
            [mainviewcontroller gotoscreenindex:6 pageindex:-1 keyindex:-1];
        }
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

-(void) switchCenterToCenter:(NSDictionary *)userInfo
{
    if (userInfo[@"centerkey"] && ![globalvariables.centerrecord.centerkey isEqualToString:userInfo[@"centerkey"]]) {
        CenterRecord *center=[MyClass returncenterrecordwithcenterkey:userInfo[@"centerkey"]];
        if (center.centerkey) {
            globalvariables.documentfolder.classinvoicearray=[[NSMutableArray alloc]init];
            globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
            globalvariables.documentfolder.salesinvoicearray=[[NSMutableArray alloc]init];
            globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
            
            NSMutableArray *CenterSelectionArray=[[NSMutableArray alloc]initWithObjects:center.centerkey, nil];
            globalvariables.centerrecord=[MyClass returncenterrecordwithcenterselectionarray:CenterSelectionArray];
            [MyClass updatecenterkey];
            [MyClass resetdevicelastupdatetimewithparameters:@"staff,classroom,centersettings,userroleandprivilege,centerrecord,arcode"];
            [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,marketing,centersettings,userroleandprivilege,student,lead,leavenature,arcode,messagecontact" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        }
    }
}

#pragma mark - Root VC Resolver Helper

- (MainViewController *)activeMainViewController {
    UIWindow *keyWindow = nil;
    
    // Primary pass: Locate keyWindow inside active connected window scenes
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }
        }
        if (keyWindow) break;
    }
    
    // Fallback pass: Retrieve first window from any connected UIWindowScene (covers launch/inactive states)
    if (!keyWindow) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                if (windowScene.windows.count > 0) {
                    keyWindow = windowScene.windows.firstObject;
                    break;
                }
            }
        }
    }
    
    UIViewController *rootVC = keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = ((UINavigationController *)rootVC).topViewController;
    } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        rootVC = ((UITabBarController *)rootVC).selectedViewController;
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            rootVC = ((UINavigationController *)rootVC).topViewController;
        }
    }
    
    return [rootVC isKindOfClass:[MainViewController class]] ? (MainViewController *)rootVC : nil;
}

#pragma mark - UISceneSession Lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}





@end
