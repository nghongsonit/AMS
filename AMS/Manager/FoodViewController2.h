//
//  FoodViewController2.h
//  AMS
//
//  Created by SonNguyen on 5/19/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PNChart.h"
@protocol FoodViewController2Delegate <NSObject>
-(void) showView:(NSString *)type;
@end
@interface FoodViewController2 : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (nonatomic,strong) PNLineChart *lineChart;

@property(nonatomic,strong) NSArray *arrData;
@property (nonatomic,strong) AquacultureRecord *data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;

@property(nonatomic,strong) id<FoodViewController2Delegate>delegate;

- (void)getData;
@end
