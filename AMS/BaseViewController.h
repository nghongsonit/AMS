//
//  BaseViewController.h
//  PlusFarm
//
//  Created by SonNguyen on 11/18/16.
//  Copyright © 2016 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareData.h"
#import "ShareHelper.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworkReachabilityManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UploadQueue.h"

@interface BaseViewController : UIViewController
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic,retain) UILabel *lblNetWorkStt;
@property (nonatomic) BOOL isNetWorkAvailble;

- (void)showAlertBox:(NSString *)title
             message:(NSString *)message
                 tag:(NSInteger )tag;
-(void)pushView:(UIViewController *)viewController;

- (UploadQueue *)createUploadQueue;

@end
