//
//  NotificationViewController.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "NotificationTableViewCell.h"
#import "NotificationRecord.h"
#import "NotificationDataRecord.h"
#import "DetailCommandViewController.h"

typedef void (^CompletedBlock)();

@interface NotificationViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) DetailCommandViewController *detailCommandViewController;

@property(nonatomic,strong) ListDataRecord *data;
@property(nonatomic,strong) NSArray *arrData;

@property(nonatomic,copy) CompletedBlock completedHandler;
@end
