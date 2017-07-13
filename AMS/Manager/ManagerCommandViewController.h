//
//  ManagerCommandViewController.h
//  AMS
//
//  Created by SonNguyen on 5/19/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ShowOptionViewController.h"
#import "CommandViewController.h"

@interface ManagerCommandViewController : BaseViewController<UITextViewDelegate,ShowOptionViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UITextView *txtNoiDung;
@property (weak, nonatomic) IBOutlet UILabel *lblChonNguoi;
@property (weak, nonatomic) IBOutlet UIButton *btnCommand;
- (IBAction)TouchUpInside:(id)sender;
@end
