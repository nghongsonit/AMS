//
//  FoodViewController1.h
//  AMS
//
//  Created by SonNguyen on 5/19/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FoodViewController1 : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTongLuongThucAn;
@property (weak, nonatomic) IBOutlet UILabel *lblFCR;

@property (nonatomic,strong) AquacultureRecord *data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;

@end
