//
//  ManagerListViewController.h
//  AMS
//
//  Created by SonNguyen on 4/12/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeTableViewCell_Manager.h"
#import "ManagerDetailViewController.h"
#import "NotificationViewController.h"

@interface ManagerListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) ListAquacultureRecord *data;
@property(nonatomic,strong) NSArray *arrData;
@end
