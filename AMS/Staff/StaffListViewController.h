//
//  StaffListViewController.h
//  AMS
//
//  Created by SonNguyen on 4/12/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeTableViewCell.h"
#import "StaffDetailViewController.h"
#import "NotificationViewController.h"
#import "ListAquacultureRecord.h"
#import "AquacultureRecord.h"
#import "UIBarButtonItem+Badge.h"

@interface StaffListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emtyView;

@property(nonatomic,strong) ListAquacultureRecord *data;
@property(nonatomic,strong) NSArray *arrData;

-(void)getBadge;
@end
