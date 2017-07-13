//
//  StaffListViewController.m
//  AMS
//
//  Created by SonNguyen on 4/12/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "StaffListViewController.h"
#define PER_PAGE @"5"
@interface StaffListViewController ()
{
    int totalPage;
    int currentPage;
    BOOL isFinish;
    BOOL isSearch;
    
    UITextField *txtField_navTitle;
}
@end

@implementation StaffListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMenuBarButtonItems];
    [self initTableView];
    currentPage = 1;
    
    [self setupPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if (!isSearch) {
        currentPage = 1;
        [self getData:StringFormat(@"%d",currentPage) PerPage:PER_PAGE];
    }
    else
        [self searchAqua:txtField_navTitle.text];
    [self getBadge];
}

- (void)initMenuBarButtonItems{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    self.navigationItem.rightBarButtonItem.shouldHideBadgeAtZero = NO;
    self.navigationItem.rightBarButtonItem.shouldAnimateBadge = YES;
    
    txtField_navTitle = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,7,self.view.bounds.size.width,31)];
    txtField_navTitle.delegate = (id)self;
    [txtField_navTitle setBackgroundColor:[UIColor clearColor]];
    txtField_navTitle.textColor = [UIColor grayColor];
    txtField_navTitle.textAlignment = NSTextAlignmentLeft;
    txtField_navTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtField_navTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtField_navTitle.borderStyle = UITextBorderStyleNone;
    txtField_navTitle.font = [UIFont boldSystemFontOfSize:20];
    txtField_navTitle.autocorrectionType = UITextAutocorrectionTypeNo;
    txtField_navTitle.layer.masksToBounds = NO;
    txtField_navTitle.layer.shadowColor = [UIColor whiteColor].CGColor;
    txtField_navTitle.layer.shadowOpacity = 0;
    txtField_navTitle.placeholder = @"Tìm kiếm theo tên ao...";
    txtField_navTitle.tintColor = [UIColor grayColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSString *placeholder = @"Tìm kiếm theo tên ao...";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [placeholder length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, [placeholder length])];
    
    txtField_navTitle.attributedPlaceholder = attributedString;
    
    [txtField_navTitle addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.navigationItem setTitleView:txtField_navTitle];
    self.navigationItem.titleView.hidden = YES;
    isSearch = NO;

}

- (UIBarButtonItem *) rightMenuBarButtonItem {
    
    UIImage *image = [ShareHelper imageWithImageHeight:[UIImage imageNamed:@"ic_notification"] height:25];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed:)];
    return navRightButton;
}

- (UIBarButtonItem *)leftMenuBarButtonItem {

    if (!isSearch) {
        return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPressed:)];
    }
    else{
        UIImage *image = [ShareHelper imageWithImageHeight:[UIImage imageNamed:@"ic_back"] height:20];
        return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    }
}

- (void)rightButtonPressed:(id)sender {
    NotificationViewController *notificationViewController = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    [self pushView:notificationViewController];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
- (void)searchPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        isSearch = YES;
        txtField_navTitle.hidden = NO;
        self.arrData = nil;
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
        if (![ShareHelper checkWhiteSpace:txtField_navTitle.text] && ![ShareHelper returnSpecialType:txtField_navTitle.text]){
            [self searchAqua:txtField_navTitle.text];
        }
        [self.tableView reloadData];
        [self.view endEditing:YES];
    });
}
- (void)backPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        isSearch = NO;
        //self.arrData = tempArrData;
        txtField_navTitle.hidden = YES;
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
        currentPage = 1;
        [self getData:StringFormat(@"%d",currentPage) PerPage:PER_PAGE];
        [self.tableView reloadData];
        [txtField_navTitle resignFirstResponder];
    });
}

#pragma mark GetData
-(void)getData:(NSString *)pageNum PerPage:(NSString *)perPage{
    self.emtyView.hidden = NO;
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getListAquaculture:pageNum PerPage:perPage completionHandler:^(id result, NSString *errorCode, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            self.emtyView.hidden = YES;
            self.data = result;
            totalPage = [self.data.l_pages intValue];
            NSArray *temp = self.data.l_array;
            if(self.data.l_array){
                if ([pageNum intValue] > 1) {
                    NSMutableArray *entriesNextPage = [NSMutableArray new];
                    //entriesNextPage = self.arrData;
                    [entriesNextPage addObjectsFromArray:self.arrData];
                    [entriesNextPage addObjectsFromArray:temp];
                    temp = entriesNextPage;
                }
            }
            self.arrData = temp;
            //tempArrData = temp;
            [self.tableView reloadData];
        }
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertBox:ERROR message:error.localizedDescription tag:99];
    }];
}

#pragma mark UItableView

-(void)initTableView{
    [self.tableView registerNib:[UINib nibWithNibName:HOME_CELL bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HOME_CELL];
    self.tableView.separatorColor = [UIColor clearColor];;
//    selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE5)
        return (screenSize.height-49-64-40)/4;
    return (screenSize.height-49-64-50)/5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:colorWithRGB(170, 170, 170, 0)];
    return v;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HOME_CELL];
    AquacultureRecord *item = [self.arrData objectAtIndex:(int)indexPath.section];
    CurrentInfoRecord *info = item.a_currentInfo;
    
    NSString *caculateDate = [ShareHelper getDateTimeByFormatDay:info.i_calculatedDate];
    NSString *currentDate = [ShareHelper getCurrentDate1];
    
    HealthRecord *health = info.i_health;
    cell.lblAo.text = item.a_name;
    cell.lblVuNuoi.text = item.a_season;
    cell.lblTrangThai.text = health.h_status;
    cell.lblSoNgay.text = [self calculateDay:[ShareHelper getCurrentDate] ImportDay:item.a_importDate];
    cell.lblCurrentDate.text = [ShareHelper getCurrentDate1];
    
    if ([caculateDate isEqualToString:currentDate]){
        cell.imgCheck.image = [UIImage imageNamed:@"ic_check"];
            cell.lblFinish.text = @"Đã hoàn thành";
    }
    else{
        cell.imgCheck.image = [UIImage imageNamed:@"ic_warning"];
            cell.lblFinish.text = @"Chưa hoàn thành";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AquacultureRecord *item = [self.arrData objectAtIndex:(int)indexPath.section];
    CurrentInfoRecord *info = item.a_currentInfo;
    NSString *caculateDate = [ShareHelper getDateTimeByFormatDay:info.i_calculatedDate];
    NSString *currentDate = [ShareHelper getCurrentDate1];
    if (![caculateDate isEqualToString:currentDate]){
        isFinish = NO;
    }
    else
        isFinish = YES;
    NSString *days = [self calculateDay:[ShareHelper getCurrentDate] ImportDay:item.a_importDate];
    [self getAquacultureDetail:item.a_id Days:days Finish:isFinish];
}

#pragma mark ScrollView Delegate
//lazy load
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!isSearch) {
        if(!currentPage)
            currentPage = 1;
        if(currentPage >= 1 && currentPage < totalPage){
            currentPage ++;
            [self getData:StringFormat(@"%d",currentPage) PerPage:PER_PAGE];
        }
    }
}

-(NSString *)calculateDay:(NSString *)currentDay ImportDay:(NSString *)importDay{
    NSTimeInterval current = [ShareHelper dateConverter:currentDay];
    NSTimeInterval import = [ShareHelper dateConverter:importDay];
    NSTimeInterval time = current-import;
    
    int days = (int)time/(3600*24);
    return StringFormat(@"%d", days);
}
-(void)getAquacultureDetail:(NSString *)aquaId Days:(NSString *)days Finish:(BOOL)finish{
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getAquacultureDetail:aquaId completionHandler:^(id result, NSString *errorCode, NSString *message){
        if (result) {
            [SVProgressHUD dismiss];
            StaffDetailViewController *staffDetailViewController = [[StaffDetailViewController alloc] initWithNibName:@"StaffDetailViewController" bundle:nil Data:result Days:days Finish:isFinish];
            [self pushView:staffDetailViewController];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertBox:ERROR message:error.localizedDescription tag:99];
    }];
}

#pragma mark Pull to Refresh

- (void)setupPullToRefresh {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pulling to refresh events..." attributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [refreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.tableView.alwaysBounceVertical = YES;
}

- (void)pullToRefresh:(UIRefreshControl *)refreshControl {
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..." attributes:@{ NSForegroundColorAttributeName:[UIColor grayColor]}];
    [refreshControl endRefreshing];
    currentPage = 1;
    if (!isSearch) {
        [self getData:StringFormat(@"%d",currentPage) PerPage:PER_PAGE];
    }
    else
        [self searchAqua:txtField_navTitle.text];
}

#pragma mark Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(id)sender{
    txtField_navTitle.attributedText = [[NSAttributedString alloc] initWithString:txtField_navTitle.text attributes:@{
                                                                                                                      NSFontAttributeName : [UIFont systemFontOfSize:17.0],
                                                                                                                      }];
    [self searchAqua:txtField_navTitle.text];
    
    if (txtField_navTitle.text.length == 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        
        NSString *placeholder = @"Tìm kiếm theo tên ao...";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [placeholder length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, [placeholder length])];
        
        txtField_navTitle.attributedPlaceholder = attributedString;
        txtField_navTitle.placeholder = @"Tìm kiếm theo tên ao...";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSString *placeholder = @"Tìm kiếm theo tên ao...";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [placeholder length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, [placeholder length])];
    
    txtField_navTitle.attributedPlaceholder = attributedString;
    textField.placeholder = @"Tìm kiếm theo tên ao...";
}

#pragma Search

-(void)searchAqua:(NSString *)key{
    if (![ShareHelper checkWhiteSpace:txtField_navTitle.text] && ![ShareHelper returnSpecialType:txtField_navTitle.text]) {
        [SVProgressHUD show];
        [[ShareData instance].dataProxy searchAquaStaff:key completeHandler:^(id result, NSString *errorCode, NSString *message){
            [SVProgressHUD dismiss];
            self.data = result;
            self.arrData = self.data.l_array;
            [self.tableView reloadData];
        } errorHandler:^(NSError *error) {
            [self showAlertBox:ERROR message:error.localizedDescription tag:99];
        }];

    }
    else{
        self.arrData = nil;
        [self.tableView reloadData];
    }
}

#pragma mark Get Badge value

-(void)getBadge{
    [[ShareData instance].dataProxy getBadge:^(id result, NSString *errorCode, NSString *message) {
        self.navigationItem.rightBarButtonItem.badgeValue = result;
        self.navigationItem.rightBarButtonItem.shouldHideBadgeAtZero = NO;
        self.navigationItem.rightBarButtonItem.shouldAnimateBadge = YES;
    } errorHandler:^(NSError *error) {
        
    }];
}
@end
