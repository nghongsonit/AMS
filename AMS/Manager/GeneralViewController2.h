//
//  GeneralViewController2.h
//  AMS
//
//  Created by SonNguyen on 5/10/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PNChart.h";

@protocol GeneralViewController2Delegate <NSObject>
-(void) showView:(NSString *)type;
//-(void) reloadScollView:(NSUInteger)count;
@end
@interface GeneralViewController2 : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (nonatomic,strong) PNLineChart *lineChart;

@property (nonatomic,strong) AquacultureRecord *data;
@property(nonatomic,strong) NSArray *arrData;

@property(nonatomic,strong) id<GeneralViewController2Delegate>delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;
-(void)getData;
@end
