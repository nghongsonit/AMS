//
//  StaffSettingViewController.h
//  AMS
//
//  Created by SonNguyen on 4/12/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "BaseViewController.h"
#import "OpenUDID.h"
#import "ChangePasswordViewController.h"

@interface StaffSettingViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceIMEI;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *changePasswordView;
@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

- (IBAction)TouchUpInside:(id)sender;
@end
