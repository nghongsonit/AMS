//
//  ShowOptionViewController.h
//  AMS
//
//  Created by SonNguyen on 4/27/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ListDataRecord.h"
#import "OptionTableViewCell.h"
#import "Health1Record.h"
#import "MedicineRecord.h"
#import "UserAreaRecord.h"

@protocol ShowOptionViewControllerDelegate <NSObject>

-(void)getData:(id)data Type:(NSString *)type;

@end

@interface ShowOptionViewController : BaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSString *type;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(NSString *)role ;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ListDataRecord *data;
@property (nonatomic,strong) NSArray *arrData;

@property(nonatomic,strong) id<ShowOptionViewControllerDelegate>delegate;
@end
