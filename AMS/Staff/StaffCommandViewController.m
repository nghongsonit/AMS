//
//  StaffCommandViewController.m
//  AMS
//
//  Created by SonNguyen on 4/12/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "StaffCommandViewController.h"
#define PER_PAGE @"4"
@interface StaffCommandViewController ()
{
    int totalPage;
    int currentPage;
}
@end

@implementation StaffCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initTableView];
    self.navigationItem.title = @"DANH SÁCH CHỈ THỊ";
    self.navigationItem.leftBarButtonItem = nil;
    currentPage = 1;
    [self setupPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    currentPage = 1;
    [self getData:StringFormat(@"%d",currentPage) PerPage:PER_PAGE];
}

-(void)initTableView{
    [self.tableView registerNib:[UINib nibWithNibName:COMMAND_CELL bundle:[NSBundle mainBundle]] forCellReuseIdentifier:COMMAND_CELL];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.layer.cornerRadius = 10.0f;
}

#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (self.tableView.frame.size.height-49)/3-20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrData.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StaffCommandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMAND_CELL];
    CommandRecord *item = [self.arrData objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.separatorView.hidden = YES;
    }
    else
        cell.separatorView.hidden = NO;
    cell.lblCreateBy.text = StringFormat(@"Bạn nhận được chỉ thị từ : %@", item.c_createdBy);
    cell.lblMessage.text = StringFormat(@"Nội dung chỉ thị: %@", item.c_message);
    
    NSString *createdDate = [ShareHelper getDateTimeByFormatDay1:item.c_createdDate];
    NSArray *tempArr = [createdDate  componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
    cell.lblDate.text = tempArr[0];
    cell.lblTime.text = tempArr[1];
    NSString *day = tempArr[2];
    
    if ([day isEqualToString:[ShareHelper getCurrentDate3]]) {
        cell.lblDay.text = @"HÔM NAY";
    }
    else
        cell.lblDay.text = day;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommandRecord *item = [self.arrData objectAtIndex:indexPath.row];
    
    DetailCommandViewController *detailCommandViewController = [[DetailCommandViewController alloc] initWithNibName:@"DetailCommandViewController" bundle:nil Data:item Type:@"Staff"];
    [self pushView:detailCommandViewController];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark GetData
-(void)getData:(NSString *)pageNum PerPage:(NSString *)perPage{
    [SVProgressHUD show];
    
    [[ShareData instance].dataProxy getStaffCommand:pageNum PerPage:perPage completeHandler:^(id result, NSString *errorCode, NSString *message) {
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
