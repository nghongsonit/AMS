//
//  DetailCommandViewController.h
//  AMS
//
//  Created by SonNguyen on 5/23/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DetailCommandViewController.h"
#import "NotificationRecord.h"

@interface DetailCommandViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *lblCreateBy;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item Type:(NSString *)typeClass;
@property (nonatomic,strong) id data;
@property (nonatomic,strong) NSString *type;

@end
