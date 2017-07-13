//
//  ManagerDetailViewController.m
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ManagerDetailViewController.h"

@interface ManagerDetailViewController ()

@end

@implementation ManagerDetailViewController
@synthesize data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    data = item;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMenuBarButtonItems];
    [self initSegment];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMenuBarButtonItems{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initSegment{
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 44)];
    self.segmentedControl.sectionTitles = @[@"General", @"Food", @"H & E"];
    self.segmentedControl.selectedSegmentIndex = 0;
//    self.segmentedControl.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.segmentedControl.backgroundColor = [UIColor clearColor];

    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor greenColor]};


    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.segmentedControl.verticalDividerEnabled = YES;
    self.segmentedControl.verticalDividerColor = [UIColor whiteColor];
    self.segmentedControl.verticalDividerWidth = 1.0f;
    self.segmentedControl.tag = 1;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(screenSize.width * index, 0, screenSize.width, screenSize.height) animated:YES];
    }];
    
    [self.navigationItem setTitleView:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(screenSize.width * 3, screenSize.height-49-64);
    self.scrollView.delegate = (id)self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, screenSize.width, screenSize.height-49-64) animated:NO];
    [self.view addSubview:self.scrollView];
    
    self.generalViewController = [[GeneralViewController alloc] initWithNibName:@"GeneralViewController" bundle:nil Data:data];
    self.generalViewController.view.frame = CGRectMake(0,0,screenSize.width,screenSize.height-49-64);
    self.generalViewController.general2.delegate = self;
    self.generalViewController.general3.delegate = (id)self;
    [self.scrollView addSubview:self.generalViewController.view];
    
    self.foodViewControlelr = [[FoodViewController alloc] initWithNibName:@"FoodViewController" bundle:nil Data:data];
    self.foodViewControlelr.view.frame = CGRectMake(screenSize.width,0,screenSize.width,screenSize.height-49-64);
    self.foodViewControlelr.food2View.delegate = (id)self;
    [self.scrollView addSubview:self.foodViewControlelr.view];
    
    self.heViewController = [[HEViewController alloc] initWithNibName:@"HEViewController" bundle:nil Data:data];
    self.heViewController.view.frame = CGRectMake(screenSize.width*2,0,screenSize.width,screenSize.height-49-64);
    self.heViewController.HE1View.delegate = (id)self;
    self.heViewController.HE2View.delegate = (id)self;
    self.heViewController.HE3View.delegate = (id)self;
    [self.scrollView addSubview:self.heViewController.view];
}

-(void)setData{
    CurrentInfoRecord *info = data.a_currentInfo;
    float sizeBinhQuan = [data.a_totalWeightFish floatValue]*1000/[data.a_totalFish floatValue];
    float soLuongHienTai = [data.a_totalFish floatValue] - [info.i_deadFishCount floatValue];
    float trongLuongCaHienTai = soLuongHienTai*[info.i_averageWeight floatValue];
    float FCR = [info.i_totalFood floatValue]/trongLuongCaHienTai;
    float fishDeathUocTinh = [info.i_deadFishCountDay floatValue]*3;
    float percentFishDeath = (fishDeathUocTinh/[data.a_totalFish floatValue])*100;
    float soLuongCaHaoTrongNgay = [info.i_deadFishCountDay floatValue];
    float trongLuongCaHaoTrongNgay = [info.i_deadFishWeightDay floatValue];
    
    self.generalViewController.general1.lblSizeBinhQuan.text = StringFormat(@"%.2f",[info.i_averageWeight floatValue]);
    self.generalViewController.general1.lblSoLuongHienTai.text = StringFormat(@"%.2f",soLuongHienTai);
    self.generalViewController.general1.lblFCR.text = StringFormat(@"%.2f",FCR);
    self.generalViewController.general1.lblPhanTramCaHaoHut.text = StringFormat(@"%.2f",percentFishDeath);
    self.generalViewController.general1.lblSoluongCaHaoTrongNgay.text = StringFormat(@"%.2f",soLuongCaHaoTrongNgay);
    self.generalViewController.general1.lblSoLuongCaUocTinh.text = StringFormat(@"%.2f",fishDeathUocTinh);
    self.generalViewController.general1.lblTrongLuongCaHao.text = StringFormat(@"%.2f",trongLuongCaHaoTrongNgay);
    
    NSArray *images = info.i_images;
    for (int i = 0; i < images.count; i++) {
        [(UIImageView *)[self.generalViewController.general1.images objectAtIndex:i] sd_setImageWithURL:[NSURL URLWithString: StringFormat(@"%@/%@",URL_IMAGE_UPLOAD,images[i]) ] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [(UIImageView *)[self.generalViewController.general1.images objectAtIndex:i] setImage:image];
        }];
    }
    
    self.generalViewController.general4.lblNgayThaGiong.text= data.a_importDate;
    self.generalViewController.general4.lblSoLuongCon.text =StringFormat(@"%@", data.a_totalFish);
    self.generalViewController.general4.lblSoLuongKg.text = StringFormat(@"%@", data.a_totalWeightFish);
    self.generalViewController.general4.lblKichCo.text = StringFormat(@"%.2f",sizeBinhQuan);
    self.generalViewController.general4.lblMatDo.text = StringFormat(@"%@",data.a_densityStretch);

    self.foodViewControlelr.food1View.lblFCR.text = StringFormat(@"%.2f",FCR);
    self.foodViewControlelr.food1View.lblTongLuongThucAn.text = StringFormat(@"%.2f(kg)",[info.i_totalFood floatValue]);
    
    self.heViewController.HE1View.lblStatus.text = info.i_health.h_status;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

#pragma mark Show Option
-(void)showView:(NSString *)type{
    ShowOptionViewController *showOption = [[ShowOptionViewController alloc] initWithNibName:@"ShowOptionViewController" bundle:nil Type:type];
    showOption.delegate = (id)self;
    [self pushView:showOption];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark showOption Delegate
-(void)getData:(id)time Type:(NSString *)type{
    if ([type isEqualToString:@"T1"]) {
        self.generalViewController.general2.lblName.text = (NSString *)time;
        [self.generalViewController.general2.lineChart removeFromSuperview];
        [self.generalViewController.general2 getData];
    }
    else if([type isEqualToString:@"T2"]){
        self.generalViewController.general3.lblName.text = (NSString *)time;
        [self.generalViewController.general3.lineChart removeFromSuperview];
        [self.generalViewController.general3 getData];
    }
    else if([type isEqualToString:@"T3"]){
        self.foodViewControlelr.food2View.lblName.text = (NSString *)time;
        [self.foodViewControlelr.food2View.lineChart removeFromSuperview];
        [self.foodViewControlelr.food2View getData];
    }
    else if([type isEqualToString:@"T4"]){
        self.heViewController.HE1View.lblName.text = (NSString *)time;
        [self.heViewController.HE1View.lineChart removeFromSuperview];
        [self.heViewController.HE1View getData];
    }
    else if([type isEqualToString:@"T5"]){
        self.heViewController.HE2View.lblName.text = (NSString *)time;
        [self.heViewController.HE2View.lineChart removeFromSuperview];
        [self.heViewController.HE2View getData];
    }
    else if([type isEqualToString:@"T6"]){
        self.heViewController.HE3View.lblName.text = (NSString *)time;
        [self.heViewController.HE3View.lineChart removeFromSuperview];
        [self.heViewController.HE3View getData];
    }
}
@end
