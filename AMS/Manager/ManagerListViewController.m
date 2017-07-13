//
//  ManagerListViewController.m
//  AMS
//
//  Created by SonNguyen on 4/12/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ManagerListViewController.h"
#define PER_PAGE @"5"

@interface ManagerListViewController ()
{
    int totalPage;
    int currentPage;
    
    BOOL isSearch;
    
    UITextField *txtField_navTitle;
}
@end

@implementation ManagerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
}

- (void)initMenuBarButtonItems{
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    
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
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed:)];
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
    //self.emtyView.hidden = NO;
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getListAquacultureManager:pageNum PerPage:perPage completionHandler:^(id result, NSString *errorCode, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            //self.emtyView.hidden = YES;
            self.data = result;
            totalPage = [self.data.l_pages intValue];
            NSArray *temp = self.data.l_array;
            if(self.data.l_array){
                if ([pageNum intValue] > 1) {
                    NSMutableArray *entriesNextPage = [NSMutableArray new];
                    //entriesNextPage = (id)self.arrData;
                    [entriesNextPage addObjectsFromArray:self.arrData];
                    [entriesNextPage addObjectsFromArray:temp];
                    temp = entriesNextPage;
                }
            }
            self.arrData = temp;
            [self.tableView reloadData];
        }
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertBox:ERROR message:error.localizedDescription tag:99];
    }];
}


#pragma mark UItableView

-(void)initTableView{
    [self.tableView registerNib:[UINib nibWithNibName:HOME_CELL_MANAGER bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HOME_CELL_MANAGER];
    self.tableView.separatorColor = [UIColor clearColor];
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
    return (screenSize.height-49-64-50)/3-10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:colorWithRGB(170, 170, 170, 0)];
    return v;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell_Manager *cell = [tableView dequeueReusableCellWithIdentifier:HOME_CELL_MANAGER];
    AquacultureRecord *item = [self.arrData objectAtIndex:(int)indexPath.section];
    CurrentInfoRecord *info = item.a_currentInfo;
    
    NSString *caculateDate = @"";
    if (info.i_calculatedDate) {
        caculateDate = [ShareHelper getDateTimeByFormatDay:info.i_calculatedDate];
        cell.lblBaoCaoMoiNhat.hidden = NO;
    }
    else
        cell.lblBaoCaoMoiNhat.hidden = YES;
    NSString *currentDate = [ShareHelper getCurrentDate1];
    
    HealthRecord *health = info.i_health;
    cell.lblAo.text = item.a_name;
    cell.lblTinhTrang.text = health.h_status;
    //cell.lblPhanTram.text = ;
    cell.lblLuyKe.text = StringFormat(@"%@",info.i_totalFood);
    
    //float sizeBinhQuan = [item.a_totalWeightFish floatValue]*1000/[item.a_totalFish floatValue];
    float fishDeath = [info.i_deadFishCount floatValue]*3;
    float percentFishDeath = (fishDeath/[item.a_totalFish floatValue])*100;
    cell.lblSizeBQ.text = StringFormat(@"%.2f",[info.i_averageWeight floatValue]);
    cell.lblPhanTram.text = StringFormat(@"%.2f",percentFishDeath);
    cell.lblNgayBaoCao.text = caculateDate;
    
    if ([caculateDate isEqualToString:currentDate]){
        cell.imgStatus.image = [UIImage imageNamed:@"ic_check"];
        cell.lblStatus.text = @"Đã hoàn thành";
    }
    else{
        cell.imgStatus.image = [UIImage imageNamed:@"ic_warning"];
        cell.lblStatus.text = @"Chưa hoàn thành";
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     AquacultureRecord *item = [self.arrData objectAtIndex:(int)indexPath.section];
    [self getAquacultureDetail:item.a_id];
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

#pragma mark get data deatail
-(void)getAquacultureDetail:(NSString *)aquaId{
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getAquacultureDetailManager:aquaId completionHandler:^(id result, NSString *errorCode, NSString *message){
        if (result) {
            [SVProgressHUD dismiss];
            ManagerDetailViewController *managerDetailViewController = [[ManagerDetailViewController alloc] initWithNibName:@"ManagerDetailViewController" bundle:result Data:result];
            [self pushView:managerDetailViewController];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertBox:ERROR message:error.localizedDescription tag:99];
    }];
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


#pragma Search

-(void)searchAqua:(NSString *)key{
    if (![ShareHelper checkWhiteSpace:txtField_navTitle.text] && ![ShareHelper returnSpecialType:txtField_navTitle.text]) {
        [SVProgressHUD show];
        [[ShareData instance].dataProxy searchAquaManager:key completeHandler:^(id result, NSString *errorCode, NSString *message){
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


@end
