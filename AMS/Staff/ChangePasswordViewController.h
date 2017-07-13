//
//  ChangePasswordViewController.h
//  AMS
//
//  Created by SonNguyen on 5/23/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^CompleteBlock)();
@interface ChangePasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property(nonatomic,copy) CompleteBlock logOutHandler;

@end
