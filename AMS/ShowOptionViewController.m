//
//  ShowOptionViewController.m
//  AMS
//
//  Created by SonNguyen on 4/27/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ShowOptionViewController.h"
#define PER_PAGE @"10"

@interface ShowOptionViewController ()
{
    int totalPage;
    int currentPage;

}
@end

@implementation ShowOptionViewController
@synthesize type;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(NSString *)role{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    type = role;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTableView];
    currentPage = 1;
    [self getData:StringFormat(@"%d",currentPage) Perpage:PER_PAGE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMenuBarButtonItems{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([type isEqualToString:@"T1"] || [type isEqualToString:@"T2"] || [type isEqualToString:@"T3"] || [type isEqualToString:@"T4"] || [type isEqualToString:@"T5"] || [type isEqualToString:@"T6"]) {
        self.navigationItem.title = @"Chọn thời gian";
    }
    else
        self.navigationItem.title = type;
}

#pragma mark getData
-(void)getData:(NSString *)pageNum Perpage:(NSString *)perPage{
    if ([type isEqualToString:@"Chọn thức ăn"]) {
        [self getFood:pageNum PerPage:perPage];
    }
    else if([type isEqualToString:@"Chọn tình trạng sức khoẻ"])
        [self getHealth:pageNum PerPage:perPage];
    else if([type isEqualToString:@"Chọn thuốc"])
        [self getMedicine:pageNum PerPage:perPage];
    else if ([type isEqualToString:@"Chọn người nhận"])
        [self getUserByArea:pageNum PerPage:perPage];
    else
        [self getTime];
}

-(void)getTime{
    totalPage = 1;
    self.arrData = [[NSArray alloc] initWithObjects:@"1 tuần",@"2 tuần",@"1 tháng", nil];
    [self.tableView reloadData];
}

-(void)getFood:(NSString *)pageNum PerPage:(NSString *)perPage{
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getListFood:pageNum PerPage:perPage completeHandler:^(id result, NSString *errorCode, NSString *message) {
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
-(void)getHealth:(NSString *)pageNum PerPage:(NSString *)perPage{
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getListHealth:pageNum PerPage:perPage completeHandler:^(id result, NSString *errorCode, NSString *message) {
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
-(void)getMedicine:(NSString *)pageNum PerPage:(NSString *)perPage{
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getListMedicine:pageNum PerPage:perPage completeHandler:^(id result, NSString *errorCode, NSString *message) {
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

-(void)getUserByArea:(NSString *)pageNum PerPage:(NSString *)perPage{
    [SVProgressHUD show];
    
    [[ShareData instance].dataProxy getListUserByArea:pageNum PerPage:perPage completionHandler:^(id result, NSString *errorCode, NSString *message) {
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


#pragma mark TableView
-(void)initTableView{
    [self.tableView registerNib:[UINib nibWithNibName:OPTION_CELL bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OPTION_CELL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE5)
        return (screenSize.height-49-64-40)/9;
    return (screenSize.height-49-64-50)/10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:colorWithRGB(170, 170, 170, 0)];
    return v;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OptionTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OPTION_CELL];
    if ([type isEqualToString:@"Chọn thức ăn"]) {
        FoodRecord *item = [self.arrData objectAtIndex:indexPath.row];
        cell.lblName.text = item.f_name;
    }
    else if ([type isEqualToString:@"Chọn tình trạng sức khoẻ"]) {
        Health1Record *item = [self.arrData objectAtIndex:indexPath.row];
        cell.lblName.text = item.h_name;
    }
    else if([type isEqualToString:@"Chọn thuốc"]){
        MedicineRecord *item = [self.arrData objectAtIndex:indexPath.row];
        cell.lblName.text = item.m_name;
    }
    else if([type isEqualToString:@"Chọn người nhận"]){
        UserAreaRecord *item = [self.arrData objectAtIndex:indexPath.row];
        cell.lblName.text = item.u_username;
    }
    else
        cell.lblName.text = [self.arrData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate) {
        if ([type isEqualToString:@"Chọn thức ăn"]) {
            FoodRecord *item = [self.arrData objectAtIndex:indexPath.row];
            [self.delegate getData:item Type:type];
        }
        else if ([type isEqualToString:@"Chọn tình trạng sức khoẻ"]) {
            Health1Record *item = [self.arrData objectAtIndex:indexPath.row];
            [self.delegate getData:item.h_name Type:type];
        }
        else if([type isEqualToString:@"Chọn thuốc"]){
            MedicineRecord *item = [self.arrData objectAtIndex:indexPath.row];
            [self.delegate getData:item Type:type];
        }
        else if([type isEqualToString:@"Chọn người nhận"]){
            UserAreaRecord *item = [self.arrData objectAtIndex:indexPath.row];
            [self.delegate getData:item Type:type];
        }
        else{
            NSString *time = [self.arrData objectAtIndex:indexPath.row];
            [self.delegate getData:time Type:type];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ScrollView Delegate
//lazy load
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(!currentPage)
        currentPage = 1;
    if(currentPage >= 1 && currentPage < totalPage){
        currentPage ++;
        [self getData:StringFormat(@"%d",currentPage) Perpage:PER_PAGE];
    }
}
@end
