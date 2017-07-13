//
//  AppDelegate.h
//  AMS
//
//  Created by SonNguyen on 4/11/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "NotificationViewController.h"

typedef void (^DidfinishBlock)(MainTabBarController *maintab);

@interface AppDelegate : UIResponder <UIApplicationDelegate,LogInViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) LoginViewController *loginViewController;
@property (nonatomic,strong) MainTabBarController *mainTabBarController;

@property (nonatomic,copy) DidfinishBlock compliteHandler;
@end

