//
//  StaffSettingViewController.m
//  AMS
//
//  Created by SonNguyen on 4/12/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "StaffSettingViewController.h"
#import "AppDelegate.h"

@interface StaffSettingViewController ()

@end

@implementation StaffSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initMenuBarButtonItems];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    self.infoView.layer.cornerRadius = 5.0f;
    self.changePasswordView.layer.cornerRadius = 5.0f;
    self.logoutView.layer.cornerRadius = 5.0f;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width / 2.0;
        self.imgAvatar.layer.masksToBounds = YES;
        self.imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imgAvatar.layer.borderWidth = 1.0;
        
        self.bgView.layer.cornerRadius = 5.0f;
        self.bgView.layer.masksToBounds = YES;
        
    });

    
    self.lblVersion.text = StringFormat(@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]);
    NSString *deviceIMEI = [[OpenUDID value] stringByReplacingCharactersInRange:NSMakeRange(8, 25) withString:@"..."];
    self.lblDeviceIMEI.text = StringFormat(@"%@",deviceIMEI);

}

- (void)initMenuBarButtonItems{
    self.navigationItem.title = @"CÀI ĐẶT";
}

- (IBAction)TouchUpInside:(id)sender {
    if (sender == self.btnLogout) {
        [self logOut];
    }
    else{
        ChangePasswordViewController *changePasswordViewController = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
        [self pushView:changePasswordViewController];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        changePasswordViewController.logOutHandler = ^(){
            [self logOut];
        };
    }
}
-(void)logOut{
    
    NSString *username = [ShareHelper getUserDefaults:@"username"];
    [[ShareData instance].dataProxy removeToken:username completeHandler:^(id result, NSString *errorCode, NSString *message){
        
    } errorHandler:^(NSError *error) {
        [self showAlertBox:ERROR message:error.localizedDescription tag:99];
        
    }];
    
    [ShareHelper clearUserDefault:@"u_a"];
    [ShareHelper clearUserDefault:@"u_p"];
    [ShareHelper clearUserDefault:@"accessToken"];
    [ShareHelper clearUserDefault:@"userId"];
    [ShareHelper clearUserDefault:@"username"];
    [ShareHelper clearUserDefault:@"userArea"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window setRootViewController:appDelegate.loginViewController];

}
@end
