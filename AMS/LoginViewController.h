//
//  LoginViewController.h
//  AMS
//
//  Created by SonNguyen on 4/11/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "BaseViewController.h"
#import "UserRecord.h"
#import "CustomAlertView.h"

@protocol LogInViewControllerDelegate
- (void)initTabBarViewcontroller:(NSString *)role;
@end

@interface LoginViewController : BaseViewController

@property(nonatomic,retain) id<LogInViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)TouchUpInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong,nonatomic) CustomAlertView *alertViewGetVersion;

@property (strong,nonatomic) NSString *link;

@end
