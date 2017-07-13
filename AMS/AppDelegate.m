//
//  AppDelegate.m
//  AMS
//
//  Created by SonNguyen on 4/11/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "AppDelegate.h"
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate ()<UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation AppDelegate
@synthesize loginViewController;
@synthesize mainTabBarController;
NSString *const kGCMMessageIDKey = @"gcm.message_id";
NSString *c_Id,*n_Type,*n_Id;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerPushNotification:application];
    [self initLogInViewController];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initLogInViewController {
    
    //tabBarController = nil;
    
    if (!loginViewController) {
        loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginViewController.delegate = (id)self;
    }
    
    loginViewController.view.alpha = 0;
    [self.window setRootViewController:loginViewController];
    [UIView animateWithDuration:0.6 animations:^{
        loginViewController.view.alpha = 1;
    }];
}

-(void)initTabBarViewcontroller:(NSString *)u_role{
    mainTabBarController = [[MainTabBarController alloc] initWithNibName:@"MainTabBarController" bundle:nil Type:u_role];
    [self.window setRootViewController:mainTabBarController];
    
    if (self.compliteHandler) {
        self.compliteHandler(mainTabBarController);
    }

    
    if ([[FIRInstanceID instanceID] token]) {
        NSString *refreshedToken = [[FIRInstanceID instanceID] token];
        NSString *username = [ShareHelper getUserDefaults:@"username"];
        NSLog(@"InstanceID token: %@", refreshedToken);
        
        [[ShareData instance].dataProxy updateToken:username token:refreshedToken completeHandler:^(id result, NSString *errorCode, NSString *message) {
            
        } errorHandler:^(NSError *error) {
            [self showAlertBox:ERROR message:error.localizedDescription tag:99];
        }];
    }

}

#pragma mark FireBase Push Notification

#pragma mark Firebase Push Notification
-(void)registerPushNotification:(UIApplication *)application{
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            // For iOS 10 data message (sent via FCM)
            [FIRMessaging messaging].remoteMessageDelegate = self;
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
}

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    // Print full message.
    //NSLog(@"%@", userInfo);
    // Change this to your preferred presentation option
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self showAlertBox:@"ThÔng báo2" message:@"App not running" tag:999];
    });
    [mainTabBarController.staffListViewController getBadge];
    completionHandler(UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    __weak AppDelegate *weakSelf = self;
    __weak MainTabBarController *weakTabBar = mainTabBarController;
    if (userInfo) {// app in foreground
        NSString *id_notification = [userInfo objectForKey:@"notifyId"];
        NSString *type = [userInfo objectForKey:@"type"];
        
        NSString *data = [userInfo objectForKey:@"data"];
        NSDictionary *dict = [ShareHelper stringToDict:data];
        NSString *commandId = [dict objectForKey:@"_id"];
        
        c_Id = commandId;
        n_Type = type;
        n_Id = id_notification;
        
        if (mainTabBarController) {
            [self updateNotification:id_notification];
    
            if ([type isEqualToString:@"command"]){
                mainTabBarController.selectedIndex = 0;
                if ([mainTabBarController.staffListViewController.navigationController.visibleViewController isKindOfClass:[NotificationViewController class]]) {
                    NotificationViewController *notificationViewController = (NotificationViewController *)mainTabBarController.staffListViewController.navigationController.visibleViewController;
                    [self showNotfificationDetailView:notificationViewController commandId:commandId Type:type];
                }
                else{
                    NotificationViewController *notificationViewController = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
                    
                    __weak NotificationViewController *weakNoti = notificationViewController;
                    notificationViewController.completedHandler = ^{
                        [self showNotfificationDetailView:weakNoti commandId:commandId Type:type];
                    };
                    
                    [mainTabBarController.staffListViewController pushView:notificationViewController];
                    mainTabBarController.staffListViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                }
            }
        }
        else{
            // App not start
            self.compliteHandler = ^(MainTabBarController *mainTabBar){
                if ([type isEqualToString:@"command"]){
                    
                    mainTabBar.selectedIndex = 0;
                    //[weakSelf performSelector:@selector(showView) withObject:weakSelf afterDelay:5.0f];
                    [weakSelf.window setRootViewController:mainTabBar];
                    
                    NotificationViewController *notificationViewController = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
                    
                    __weak NotificationViewController *weakNoti = notificationViewController;
                    notificationViewController.completedHandler = ^{
                        [weakSelf updateNotification:n_Id];
                        [weakSelf showNotfificationDetailView:weakNoti commandId:c_Id Type:n_Type];
                    };
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mainTabBar.staffListViewController pushView:notificationViewController];
                        mainTabBar.staffListViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                    });
                }
            };
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self showAlertBox:@"ThÔng báo3" message:@"App not running" tag:999];
    });
    completionHandler();
}
#endif
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", remoteMessage.appData);
}
#endif
// [END ios_10_data_message_handling]
// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs token retrieved: %@", deviceToken);
    
    // With swizzling disabled you must set the APNs token here.
    // [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}


- (void)showAlertBox:(NSString *)title
             message:(NSString *)message
                 tag:(NSInteger )tag {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    [alert addAction:yesButton];
    alert.view.tag = tag;
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

-(void)updateNotification:(NSString *)notiId{
    [[ShareData instance].dataProxy updateStatusNotify:notiId completeHandler:^(id result, NSString *errorCode, NSString *message) {
        [mainTabBarController.staffListViewController getBadge];
    } errorHandler:^(NSError *error) {
        
    }];
}

-(void)showNotfificationDetailView:(NotificationViewController *)notificationViewController commandId:(NSString *)commandId Type:(NSString *)type{
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getStaffCommandDetail:commandId completionHandler:^(id result, NSString *errorCode, NSString *message) {
        
        [SVProgressHUD dismiss];
        
        notificationViewController.detailCommandViewController = [[DetailCommandViewController alloc] initWithNibName:@"DetailCommandViewController" bundle:nil Data:result Type:type];
        [notificationViewController pushView:notificationViewController.detailCommandViewController];
        notificationViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertBox:ERROR message:error.localizedDescription tag:99];
    }];
}

-(void)showView{
    [self.window setRootViewController:mainTabBarController];
    
    NotificationViewController *notificationViewController = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    
    __weak NotificationViewController *weakNoti = notificationViewController;
    notificationViewController.completedHandler = ^{
        [self showNotfificationDetailView:weakNoti commandId:c_Id Type:n_Type];
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        [mainTabBarController.staffListViewController pushView:notificationViewController];
        mainTabBarController.staffListViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    });
}

@end
