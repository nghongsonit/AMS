//
//  StaffCommandViewController.h
//  AMS
//
//  Created by SonNguyen on 4/12/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "BaseViewController.h"
#import "StaffCommandTableViewCell.h"
#import "ListDataRecord.h"
#import "DetailCommandViewController.h"

@interface StaffCommandViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) ListDataRecord *data;
@property(nonatomic,strong) NSArray *arrData;

@end
