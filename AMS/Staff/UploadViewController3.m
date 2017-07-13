//
//  UploadViewController3.m
//  AMS
//
//  Created by SonNguyen on 4/26/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "UploadViewController3.h"

@interface UploadViewController3 ()
@end

@implementation UploadViewController3
@synthesize aqua,arrMedicine;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item{
    self = [super init];
    aqua = item;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    self.btnAdd.layer.cornerRadius = 20.0f;
    self.btnAdd.backgroundColor = colorWithRGB(62, 201, 232, 1);
    self.btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btnAdd.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.lbl5.layer.cornerRadius = self.lbl5.frame.size.width/2.0;
    self.lbl6.layer.cornerRadius = self.lbl6.frame.size.width/2.0;
    self.lbl5.layer.masksToBounds = YES;
    self.lbl6.layer.masksToBounds = YES;
    self.viewChonSucKhoe.layer.cornerRadius = 5.0;
    self.viewChonThuoc.layer.cornerRadius = 5.0;
    
    self.txtSoluong.keyboardType = UIKeyboardTypeDecimalPad;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(showOption:)];
    
    [self.viewChonSucKhoe addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(showOption:)];
    
    [self.viewChonThuoc addGestureRecognizer:tap1];
    
    arrMedicine = [[NSMutableArray alloc] init];
}

-(void)showOption:(UITapGestureRecognizer *)tap{
    if (_delegate) {
        if (tap.view == self.viewChonSucKhoe) {
            [self.delegate showView:@"Chọn tình trạng sức khoẻ"];
        }
        else
            [self.delegate showView:@"Chọn thuốc"];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)TouchUpInside:(id)sender {
    //RowRecord *item = [RowRecord new];
    MedicineRecord *item = [MedicineRecord new];
    if (![ShareHelper checkWhiteSpace:self.txtSoluong.text] && ![ShareHelper checkWhiteSpace:self.txtPPSuDung.text] && ![self.lblChonThuoc.text isEqualToString:@"Chọn thuốc"]) {
        item.m_quantity = self.txtSoluong.text;
        item.m_use = self.txtPPSuDung.text;
        item.m_name = self.lblChonThuoc.text;
        [arrMedicine addObject:item];
        [self.tableView reloadData];
        if (_delegate) {
            [self.delegate reloadScollView:arrMedicine.count];
        }
    }
    else
        [self showAlertBox:ERROR message:MISSING_INPUT tag:99];
}

#pragma mark TableView
-(void)initTableView{
    [self.tableView registerNib:[UINib nibWithNibName:MEDICINE_CELL bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MEDICINE_CELL];
        self.tableView.separatorColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMedicine.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MedicineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MEDICINE_CELL];
    MedicineRecord *item = [arrMedicine objectAtIndex:indexPath.row];
    cell.lblTenThuoc.text = item.m_name;
    cell.lblSoLuong.text =StringFormat(@"%.2f",[item.m_quantity floatValue]);
    cell.lblPP.text = item.m_use;
    
    cell.btnDelete.index = indexPath;
    [cell.btnDelete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)delete:(id)sender {
    CustomButton *currentButton = sender;
    dispatch_async(dispatch_get_main_queue(), ^{
        [arrMedicine removeObjectAtIndex:currentButton.index.row];
        [self.tableView reloadData];
        if (_delegate) {
            if (arrMedicine.count == 0) {
                [self.delegate reloadScollView:1];
                return ;
            }
            [self.delegate reloadScollView:arrMedicine.count];
        }
    });
}



@end
