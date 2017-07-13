//
//  StaffDetailViewController.m
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "StaffDetailViewController.h"

@interface StaffDetailViewController ()

@end

@implementation StaffDetailViewController
@synthesize data,temp,isFinish;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item Days:(NSString *)days Finish:(BOOL)finish{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    data = item;
    temp = days;
    isFinish = finish;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMenuBarButtonItems];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    self.containerView.layer.cornerRadius = 5.0;
    
    self.lblImportDate.text = data.a_importDate;
    self.lblTotalFish.text = StringFormat(@"%@", data.a_totalFish);
    self.lblTotalWeightFish.text =StringFormat(@"%@", data.a_totalWeightFish);
    self.lblDensityWeight.text = StringFormat(@"%@",data.a_densityWeight);
    self.lblDensityStretch.text = StringFormat(@"%@",data.a_densityStretch);
    CurrentInfoRecord *info = data.a_currentInfo;
    self.lblAverageWeight.text = StringFormat(@"%@",info.i_averageWeight);
    self.lblDeadFishCount.text = StringFormat(@"%@",info.i_deadFishCount);
    self.lblCurrentFish.text = StringFormat(@"%d",[data.a_totalFish intValue]-[info.i_deadFishCount intValue]);
    self.lblKhuVuc.text = StringFormat(@"%@",data.a_area);
    self.lblDienTich.text = StringFormat(@"%.2f",[data.a_stretch floatValue]);
}

- (void)initMenuBarButtonItems{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = StringFormat(@"Ao %@", data.a_name);
    //self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    
    [self checkFinish];
}

- (UIBarButtonItem *) rightMenuBarButtonItem {
    
    UIImage *image = [ShareHelper imageWithImageHeight:[UIImage imageNamed:@"ic_add_nav"] height:25];
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed:)];
}

- (void)rightButtonPressed:(id)sender {
    UploadViewController *uploadViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil Data:data Days:temp Finish:isFinish];
    [self pushView:uploadViewController];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)checkFinish{
    //NSString *currentDate = [ShareHelper getCurrentDate1];
    //NSString *calculateDate = [ShareHelper getDateTimeByFormatDay:data.a_currentInfo.i_calculatedDate];
    
    int minute = [ShareHelper calculateMinuteFromDate:data.a_currentInfo.i_calculatedDate];
    if ((isFinish && minute <= 15) || !isFinish) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
}

@end
