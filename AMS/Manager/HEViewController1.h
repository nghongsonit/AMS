//
//  HEViewController1.h
//  AMS
//
//  Created by SonNguyen on 5/19/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PNChart.h"
@protocol HEViewController1Delegate <NSObject>
-(void) showView:(NSString *)type;
@end
@interface HEViewController1 : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property(nonatomic,strong) NSArray *arrData;
@property (nonatomic,strong) AquacultureRecord *data;

@property (nonatomic,strong) PNLineChart *lineChart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;

@property(nonatomic,strong) id<HEViewController1Delegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
-(void)getData;
@end
