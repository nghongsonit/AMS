//
//  MainTabBarController.m
//  AMS
//
//  Created by SonNguyen on 4/11/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController
@synthesize type;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(NSString *)role{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    type = role;
    
    [self initTabBar];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self initTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBar{
    
    [[UINavigationBar appearance] setBarTintColor:colorWithRGB(251, 135, 42, 1.0)];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    if ([type isEqualToString:@"3"]) {
        [self initStaffView];
    }
    else{
        [self initManagerView];
    }
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setTintColor:colorWithRGB(253, 114, 1, 1.0)];
    [self setSelectedIndex:0];
    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : colorWithRGB(62, 201, 232, 1)} forState:UIControlStateSelected];
}

-(void)initStaffView{
    self.staffListViewController = [[StaffListViewController alloc] initWithNibName:@"StaffListViewController" bundle:nil];
    UINavigationController *staffListNavigation = [[UINavigationController alloc] initWithRootViewController:self.staffListViewController];
    staffListNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Danh Sách"
                                                                       image:[UIImage imageNamed:@"ic_list"]
                                                               selectedImage:[UIImage imageNamed:@"ic_list_selected"]];
    
    StaffCommandViewController *staffCommandViewController = [[StaffCommandViewController alloc] initWithNibName:@"StaffCommandViewController" bundle:nil];
    UINavigationController *staffCommandNavigation = [[UINavigationController alloc] initWithRootViewController:staffCommandViewController];
    staffCommandNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chỉ Thị"
                                                                      image:[UIImage imageNamed:@"ic_command"]
                                                              selectedImage:[UIImage imageNamed:@"ic_command_selected"]];
    
    StaffSettingViewController *staffSettingViewController = [[StaffSettingViewController alloc] initWithNibName:@"StaffSettingViewController" bundle:nil];
    //keypadView.isMainKeyPad = YES;
    UINavigationController *staffSettingNavigation = [[UINavigationController alloc] initWithRootViewController:staffSettingViewController];
    staffSettingNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cài Đặt"
                                                                      image:[UIImage imageNamed:@"ic_setting"]
                                                              selectedImage:[UIImage imageNamed:@"ic_setting_selected"]];
    
    [self setViewControllers:@[staffListNavigation, staffCommandNavigation, staffSettingNavigation]
                    animated:YES];
}

-(void)initManagerView{
    ManagerListViewController *managerListViewController = [[ManagerListViewController alloc] initWithNibName:@"ManagerListViewController" bundle:nil];
    UINavigationController *managerListNavigation = [[UINavigationController alloc] initWithRootViewController:managerListViewController];
    managerListNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Danh Sách"
                                                                       image:[UIImage imageNamed:@"ic_list"]
                                                               selectedImage:[UIImage imageNamed:@"ic_list_selected"]];
    
    ManagerCommandViewController *managerCommandViewController = [[ManagerCommandViewController alloc] initWithNibName:@"ManagerCommandViewController" bundle:nil];
    UINavigationController *managerCommandNavigation = [[UINavigationController alloc] initWithRootViewController:managerCommandViewController];
    managerCommandNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chỉ Thị"
                                                                      image:[UIImage imageNamed:@"ic_command"]
                                                              selectedImage:[UIImage imageNamed:@"ic_command_selected"]];
    
    StaffSettingViewController *managerSettingViewController = [[StaffSettingViewController alloc] initWithNibName:@"StaffSettingViewController" bundle:nil];
    //keypadView.isMainKeyPad = YES;
    UINavigationController *managerSettingNavigation = [[UINavigationController alloc] initWithRootViewController:managerSettingViewController];
    managerSettingNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cài Đặt"
                                                                      image:[UIImage imageNamed:@"ic_setting"]
                                                              selectedImage:[UIImage imageNamed:@"ic_setting_selected"]];
    
    [self setViewControllers:@[managerListNavigation, managerCommandNavigation, managerSettingNavigation]
                    animated:YES];
}
@end
