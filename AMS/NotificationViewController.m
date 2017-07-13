//
//  NotificationViewController.m
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "NotificationViewController.h"
#define PER_PAGE @"5"

@interface NotificationViewController ()
{
    int totalPage;
    int currentPage;
    
    BOOL firstLoad;
}
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMenuBarButtonItems];
    [self initTableView];
    currentPage = 1;
    [self setupPullToRefresh];
    
    firstLoad = YES;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMenuBarButtonItems{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"THÔNG BÁO";
}

-(void)viewDidAppear:(BOOL)animated{
    if (firstLoad && self.completedHandler) {
       self.completedHandler();
    }
    firstLoad = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    currentPage = 1;
    [self getData:StringFormat(@"%d",currentPage) PerPage:PER_PAGE];
}

#pragma mark TableView
-(void)initTableView{
    [self.tableView registerNib:[UINib nibWithNibName:NOTIFICATION_CELL bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NOTIFICATION_CELL];
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
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NOTIFICATION_CELL];
    NotificationRecord *item = [self.arrData objectAtIndex:indexPath.section];
    cell.lblLabel.text = StringFormat(@"Bạn nhận được chỉ thị từ: %@",item.n_createdBy);
    cell.lblTime.text = [ShareHelper calculateTimeAgo:item.n_createdDate];
    
    if ([item.n_read isEqualToString:@"0"]) {
        cell.backgroundColor = colorWithRGB(170, 170, 170, 0.2);
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationRecord *item = [self.arrData objectAtIndex:indexPath.section];
    
    [[ShareData instance].dataProxy updateStatusNotify:item.n_id completeHandler:^(id result, NSString *errorCode, NSString *message) {
        
    } errorHandler:^(NSError *error) {
        
    }];
    
    [SVProgressHUD show];
    
    [[ShareData instance].dataProxy getStaffCommandDetail:item.n_data.d_aquaId completionHandler:^(id result, NSString *errorCode, NSString *message) {
        [SVProgressHUD dismiss];
        self.detailCommandViewController = [[DetailCommandViewController alloc] initWithNibName:@"DetailCommandViewController" bundle:nil Data:result Type:item.n_type];
        [self pushView:self.detailCommandViewController];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertBox:ERROR message:error.localizedDescription tag:99];
    }];
}

#pragma mark GetData
-(void)getData:(NSString *)pageNum PerPage:(NSString *)perPage{
    [SVProgressHUD show];
    
    [[ShareData instance].dataProxy getNotify:pageNum PerPage:perPage completeHandler:^(id result, NSString *errorCode, NSString *message) {
        [SVProgressHUD dismiss];
        if (result) {
            self.data = result;
            totalPage = [self.data.l_pages intValue];
            NSArray *temp = self.data.l_docs;
            if(self.data.l_docs){
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

#pragma mark ScrollView Delegate
//lazy load
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(!currentPage)
        currentPage = 1;
    if(currentPage >= 1 && currentPage < totalPage){
        currentPage ++;
        [self getData:StringFormat(@"%d",currentPage) PerPage:PER_PAGE];
    }
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
    [self getData:StringFormat(@"%d",currentPage) PerPage:PER_PAGE];
}

@end
