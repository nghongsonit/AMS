//
//  ChangePasswordViewController.m
//  AMS
//
//  Created by SonNguyen on 5/23/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMenuBarButtonItems];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMenuBarButtonItems{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"ĐỔI MẬT KHẨU";
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    
}
- (UIBarButtonItem *) rightMenuBarButtonItem {
    
    UIImage *image = [ShareHelper imageWithImageHeight:[UIImage imageNamed:@"ic_done"] height:25];
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed:)];
}

- (void)rightButtonPressed:(id)sender {
    if (![ShareHelper checkWhiteSpace:self.txtCurrentPassword.text] && ![ShareHelper checkWhiteSpace:self.txtNewPassword.text] && ![ShareHelper checkWhiteSpace:self.txtConfirmPassword.text]) {
        if (![self.txtNewPassword.text isEqualToString:self.txtConfirmPassword.text]){
            [self showAlertBox:ERROR message:@"Mật khẩu mới và xác nhận mật khẩu phải trùng nhau" tag:99];
        }
        else{
            [SVProgressHUD show];
            [[ShareData instance].dataProxy changePassword:self.txtCurrentPassword.text NewPass:self.txtNewPassword.text completeHandler:^(id result, NSString *errorCode, NSString *message) {
                [SVProgressHUD dismiss];
                self.logOutHandler();
            } errorHandler:^(NSError *error) {
                [SVProgressHUD dismiss];
                [self showAlertBox:ERROR message:error.localizedDescription tag:99];
            }];
        }
    }
    else{
        [self showAlertBox:ERROR message:@"Vui lòng nhập đầy đủ các thông tin" tag:99];
    }
}

-(void)initView{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.txtCurrentPassword.leftViewMode = UITextFieldViewModeAlways;
        self.txtNewPassword.leftViewMode = UITextFieldViewModeAlways;
        self.txtConfirmPassword.leftViewMode = UITextFieldViewModeAlways;
        
        UIImageView *imgCurrentPassword = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
        imgCurrentPassword.image = [UIImage imageNamed:@"ic_lock"];
        
        UIImageView *imgNewPassword = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
        imgNewPassword.image = [UIImage imageNamed:@"ic_lock"];
        
        UIImageView *imgConfirmPassword = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
        imgConfirmPassword.image = [UIImage imageNamed:@"ic_lock"];
        
        self.txtCurrentPassword.leftView = imgCurrentPassword;
        self.txtConfirmPassword.leftView = imgConfirmPassword;
        self.txtNewPassword.leftView = imgNewPassword;
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
