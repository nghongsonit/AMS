//
//  LoginViewController.m
//  AMS
//
//  Created by SonNguyen on 4/11/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    BOOL isKeyboardShow;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    //[self LogIn];
    [self checkVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)initView{
    [self.btnLogin.layer setCornerRadius: 10.0];
    self.txtPassword.secureTextEntry = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)TouchUpInside:(id)sender {
    if (self.btnLogin == sender) {
        NSString *username = self.txtUsername.text;
        NSString *password = self.txtPassword.text;
        if ([ShareHelper checkWhiteSpace:username] || [ShareHelper checkWhiteSpace:password]) {
            [self showAlertBox:TITLE_ALERT message:@"Tên đăng nhập và mật khẩu không được để trống hoặc là khoảng trắng " tag:1];
            return;
        }
        [self doLogin];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Check Version

-(void)checkVersion{
    [[ShareData instance].dataProxy checkVersion:^(id result, NSString *errorCode, NSString *message) {
        if([errorCode isEqualToString:@"0"])
            [self LogIn];
        else
        {
            if(result!=[NSNull null])
                self.link  = result;
            [self showAlertGetVersion];
        }
        
    } errorHandler:^(NSError *error) {
        [self showAlertBox:TITLE_ALERT message:error.localizedDescription tag:1];
    }];
}

- (void)showAlertGetVersion{
    
    self.alertViewGetVersion = [CustomAlertView
                                 alertControllerWithTitle:@"Đã có phiên bản mới"
                                 message:@"Xin vui lòng cập nhật ngay"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.link] options:@{} completionHandler:nil];
                                }];
    
    [self.alertViewGetVersion addAction:yesButton];
    self.alertViewGetVersion.view.tag = 77;
    
    [self presentViewController:self.alertViewGetVersion animated:YES completion:nil];
}


#pragma mark Login

-(void)LogIn{
    
    NSString *username = [ShareHelper getUserDefaults:@"u_a"];
    NSString *password = [ShareHelper getUserDefaults:@"u_p"];
    
    if(username  && password ){
        self.txtUsername.text = username;
        self.txtPassword.text = password;
        [self doLogin];
    }
    else{
        [self.txtUsername becomeFirstResponder];
    }
}

-(void)doLogin{
    [SVProgressHUD show];
    
    [[ShareData instance].dataProxy login:self.txtUsername.text password:self.txtPassword.text completeHandler:^(id result, NSString *errorCode, NSString *message){
        [SVProgressHUD dismiss];
        
        UserRecord *user = result;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.txtUsername.text forKeyPath:@"u_a"];
        [dict setValue:self.txtPassword.text forKeyPath:@"u_p"];
        [ShareHelper saveUserDefaults:dict];
        self.txtUsername.text = @"";
        self.txtPassword.text = @"";
        [self.delegate initTabBarViewcontroller:user.u_role];
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertBox:ERROR message:error.localizedDescription tag:2];
    }];
}

#pragma mark Keyboard
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
        isKeyboardShow = YES;
    }
    else if (self.view.frame.origin.y < 0)
    {
        if (isKeyboardShow) {
            return;
        }
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
@end
