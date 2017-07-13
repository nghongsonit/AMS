//
//  MainTabBarController.h
//  AMS
//
//  Created by SonNguyen on 4/11/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffListViewController.h"
#import "StaffCommandViewController.h"
#import "StaffSettingViewController.h"
#import "ManagerListViewController.h"
#import "ManagerCommandViewController.h"

@interface MainTabBarController : UITabBarController

@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) StaffListViewController *staffListViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(NSString *)role;
@end
