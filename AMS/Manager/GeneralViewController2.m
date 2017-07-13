//
//  GeneralViewController2.m
//  AMS
//
//  Created by SonNguyen on 5/10/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "GeneralViewController2.h"

@interface GeneralViewController2 ()
{
    int time;
}
@end

@implementation GeneralViewController2
@synthesize data,lineChart;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    data = item;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(showOption:)];
    
    [self.selectedView addGestureRecognizer:tap];
    self.arrData = [[NSArray alloc] init];

}

-(void)initChart:(NSArray *)arrData{
    NSMutableArray *arrDate = [[NSMutableArray alloc] init];
    NSMutableArray *arrFishDead = [[NSMutableArray alloc] init];
    for (FishDeadRecord *item in arrData) {
        DetailFishDeadRecord *fish = item.fD_numberDeadOfFish;
        [arrDate addObject:[ShareHelper getDateTimeByFormatDay2:item.fD_date]];
        [arrFishDead addObject:fish.dF_countDead];
    }
    
    lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(20, 135.0, SCREEN_WIDTH-20, 200.0)];
    lineChart.backgroundColor = [UIColor clearColor];
    lineChart.showCoordinateAxis = YES;
    [lineChart setXLabels:arrDate];
    
    // Line Chart No.1
    NSArray * data01Array = arrFishDead;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.showPointLabel = YES;
    data01.pointLabelColor = [UIColor blackColor];
    data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:9.0];
    data01.itemCount = data01Array.count;
    data01.inflexionPointColor = PNRed;
    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;

    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lineChart.chartData = @[data01];
    lineChart.showSmoothLines = YES;
    lineChart.showYGridLines = YES;
    [lineChart strokeChart];
    
    [self.view addSubview:lineChart];
}

-(void)getData{
    
    if ([self.lblName.text isEqualToString:@"1 tuần"]) {
        time = 7;
    }
    else if([self.lblName.text isEqualToString:@"2 tuần"]){
        time = 14;
    }
    else{
        time = 30;
    }
    NSString *currentDate = [ShareHelper getCurrentDate];
    NSString *fromDate = [ShareHelper calculateFromDate:[ShareHelper getCurrentDate] timeAgo:time];
    
    [[ShareData instance].dataProxy getChartFishDead:data.a_id FromDate:fromDate ToDate:currentDate completionHandler:^(id result, NSString *errorCode, NSString *message) {
        [self initChart:result];
    } errorHandler:^(NSError *error) {
        
    }];

}

-(void)showOption:(UITapGestureRecognizer *)tap{
    if (_delegate) {
        [self.delegate showView:@"T1"];
    }
}

@end
