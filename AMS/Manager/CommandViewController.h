//
//  CommandViewController.h
//  AMS
//
//  Created by SonNguyen on 5/23/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StaffCommandTableViewCell.h"
#import "DetailCommandViewController.h"

@interface CommandViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) ListDataRecord *data;
@property(nonatomic,strong) NSArray *arrData;
@end
