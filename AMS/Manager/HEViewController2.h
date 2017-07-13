//
//  HEViewController2.h
//  AMS
//
//  Created by SonNguyen on 5/19/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PNChart.h"
@protocol HEViewController2Delegate <NSObject>
-(void) showView:(NSString *)type;
@end
@interface HEViewController2 : BaseViewController
@property(nonatomic,strong) NSArray *arrData;
@property (nonatomic,strong) AquacultureRecord *data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;

@property(nonatomic,strong) id<HEViewController2Delegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (nonatomic,strong) PNLineChart *lineChart;

-(void)getData;
@end
