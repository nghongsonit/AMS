//
//  ManagerDetailViewController.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ViewController.h"
#import "HMSegmentedControl.h"
#import "GeneralViewController.h"
#import "FoodViewController.h"
#import "HEViewController.h"
#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "ShowOptionViewController.h"

@interface ManagerDetailViewController : BaseViewController<GeneralViewController2Delegate,ShowOptionViewControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic,strong) GeneralViewController *generalViewController;
@property (nonatomic,strong) FoodViewController *foodViewControlelr;
@property (nonatomic,strong) HEViewController *heViewController;

@property (nonatomic,strong) AquacultureRecord *data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;
@end
