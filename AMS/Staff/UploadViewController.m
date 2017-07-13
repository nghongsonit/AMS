//
//  UploadViewController.m
//  AMS
//
//  Created by SonNguyen on 4/26/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()
{
    NSMutableArray *arrResult;
    FoodRecord *f_data;
    MedicineRecord *m_data;
}
@end

@implementation UploadViewController
@synthesize aqua,songay,isFinish;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item Days:(NSString *)days Finish:(BOOL)finish{
    self = [super init];
    aqua = item;
    songay = days;
    isFinish = finish;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMenuBarButtonItems];
    [self initScrollView];
    arrResult = [[NSMutableArray alloc] init];
    if (isFinish) {
        [self getData:aqua.a_id];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMenuBarButtonItems{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = StringFormat(@"Ao %@", aqua.a_name);
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    //self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (UIBarButtonItem *) rightMenuBarButtonItem {
    UIImage *image = [ShareHelper imageWithImageHeight:[UIImage imageNamed:@"ic_upload"] height:25];
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(upload:)];
}

- (void)upload:(id)sender {
    
    if ([self checkInput]){
        [SVProgressHUD show];
        [self.upload2.arrImages removeObjectIdenticalTo:[NSNull null]];
        
        if (self.upload2.arrImages.count > 0) {
            if (!self.uploadQueue) {
                self.uploadQueue = [self createUploadQueue];
            }
            self.uploadQueue.uploadQueue = self.upload2.arrImages;
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (id item in self.uploadQueue.uploadQueue) {
                [temp addObject:item];
            }
            [self.uploadQueue startUpload:^(float percent) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.hud.progress = percent;
                });
            } UploadDone:^(UploadResult *item){
                [arrResult addObject:item];
                if (arrResult.count == temp.count) {
                    [self uploadData];
                }
            } error:^(NSError *err) {
                [SVProgressHUD dismiss];
                [self showAlertBox:ERROR message:err.localizedDescription tag:99];
            }];
        }
        else if(self.c_data){
            [self uploadData];
        }
    }
    else{
        [self showAlertBox:ERROR message:@"Vui lòng nhập đầy đủ thông số" tag:99];
    }
}

-(void)initScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height-49-64)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(screenSize.width, (screenSize.height-49-64)*3+80+100-100+80);
    self.scrollView.delegate = (id)self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, screenSize.width, screenSize.height-49-64) animated:NO];
    [self.view addSubview:self.scrollView];
    
    self.upload1 = [[UploadViewController1 alloc] initWithNibName:@"UploadViewController1" bundle:nil Data:aqua];
    self.upload1.delegate = (id)self;
    self.upload1.view.frame = CGRectMake(0,0,screenSize.width,screenSize.height-49-64-100);
    [self.scrollView addSubview:self.upload1.view];
    self.upload1.lblSoNgayNuoi.text = songay;
    
    self.upload2 = [[UploadViewController2 alloc] initWithNibName:@"UploadViewController2" bundle:nil Data:aqua];
    self.upload2.delegate = (id)self;
    self.upload2.view.frame = CGRectMake(0,screenSize.height-49-64-100,screenSize.width,screenSize.height-49-64+80+80);
    [self.scrollView addSubview:self.upload2.view];
    
    self.upload3 = [[UploadViewController3 alloc] initWithNibName:@"UploadViewController3" bundle:nil Data:aqua];
    self.upload3.delegate = (id)self;
    self.upload3.view.frame = CGRectMake(0,(screenSize.height-49-64)*2+80-100+80,screenSize.width,screenSize.height-49-64+100);
    [self.scrollView addSubview:self.upload3.view];
}

-(void)showView:(NSString *)type{
    ShowOptionViewController *showOption = [[ShowOptionViewController alloc] initWithNibName:@"ShowOptionViewController" bundle:nil Type:type];
    showOption.delegate = (id)self;
    [self pushView:showOption];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
-(void)reloadScollView:(NSUInteger)count{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = CGSizeMake(screenSize.width, (screenSize.height-49-64)*3+80+100-100+80 +50*(count-1));
        self.upload3.view.frame = CGRectMake(0,(screenSize.height-49-64)*2+80-100+80,screenSize.width,screenSize.height-49-64+100 +50*(count-1));
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    });
}

#pragma mark ShowOptionViewControllerDelegate

-(void)getData:(id)data Type:(NSString *)type{
    if ([type isEqualToString:@"Chọn thức ăn"]){
        f_data = data;
        self.upload1.lblChonThucAn.text = f_data.f_name;
    }
    else if ([type isEqualToString:@"Chọn tình trạng sức khoẻ"]) {
        self.upload3.lblChonSucKhoe.text = data;
    }
    else if([type isEqualToString:@"Chọn thuốc"]){
        m_data = data;
        self.upload3.lblChonThuoc.text = m_data.m_name;
        self.upload3.txtPPSuDung.text = m_data.m_use;
    }
}

#pragma mark UploadView2 Delegate
-(void)changeView{
    self.scrollView.contentOffset = CGPointMake(0, 64);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.upload2.view.frame = CGRectMake(0,screenSize.height-49-64-100,screenSize.width,screenSize.height-49-64+80+80);
    });
}

#pragma mark Check Input
-(BOOL)checkInput{
    
    
    
    if ([ShareHelper checkWhiteSpace:self.upload1.txtSoLuong.text] || [ShareHelper checkWhiteSpace:self.upload1.txtSoLan.text] ||[self.upload1.lblChonThucAn.text isEqualToString:@"Chọn thức ăn"] || self.upload2.arrImageShow.count < 1 || [ShareHelper checkWhiteSpace: self.upload2.txtThongSoDO.text] || [ShareHelper checkWhiteSpace: self.upload2.txtThongSoNO2.text] || [ShareHelper checkWhiteSpace: self.upload2.txtThongSoPH.text] || [self.upload3.lblChonSucKhoe.text isEqualToString:@"Chọn tình trạng sức khoẻ"] || self.upload3.arrMedicine.count < 1) {
        return NO;
    }
    return YES;
}

#pragma mark Upload Data
-(void)uploadData{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *oldData = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *environment = [[NSMutableDictionary alloc] init];
    [environment setObject:self.upload2.txtThongSoDO.text forKey:@"do"];
    [environment setObject:self.upload2.txtThongSoNO2.text forKey:@"no2"];
    [environment setObject:self.upload2.txtThongSoPH.text forKey:@"ph"];
    
    NSMutableDictionary *numberOfDeadFish_new = [[NSMutableDictionary alloc] init];
    [numberOfDeadFish_new setObject:self.upload2.txtSoLuong.text forKey:@"countDead"];
    [numberOfDeadFish_new setObject:self.upload2.txtTrongLuong.text forKey:@"weight"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    if (arrResult.count > 1) {
        for (UploadResult *item in arrResult ) {
            NSString *link = item.imgLink;
            [images addObject:link];
        }
    }
    [numberOfDeadFish_new setObject:images forKey:@"images"];
    
    NSMutableDictionary *health = [[NSMutableDictionary alloc] init];
    [health setObject:self.upload3.lblChonSucKhoe.text forKey:@"status"];
    [health setObject:self.upload3.txtGhiChu.text forKey:@"note"];
    
    NSMutableDictionary *food = [[NSMutableDictionary alloc] init];
    [food setObject:self.upload1.lblChonThucAn.text forKey:@"name"];
    [food setObject:self.upload1.txtSoLuong.text forKey:@"quantity"];
    [food setObject:self.upload1.txtSoLan.text forKey:@"use"];
    [food setObject:f_data.f_unit forKey:@"unit"];
    NSMutableArray *arrFood = [[NSMutableArray alloc] init];
    [arrFood addObject:food];
    
    NSMutableArray *arrMedicine = [[NSMutableArray alloc] init];
    for (MedicineRecord *item in self.upload3.arrMedicine) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              item.m_name,@"name",
                              item.m_quantity,@"quantity",
                              item.m_use,@"use",
                              m_data.m_unit,@"unit",nil];
        [arrMedicine addObject:dict];
    }
    
    NSString *userName = [ShareHelper getUserDefaults:@"username"];
    NSString *accessToken = [ShareHelper getUserDefaults:@"accessToken"];
    
    [newData setObject:aqua.a_id forKey:@"aquaId"];
    [newData setObject:environment forKey:@"environment"];
    [newData setObject:numberOfDeadFish_new forKey:@"numberOfDeadFish"];
    [newData setObject:health forKey:@"health"];
    [newData setObject:self.upload2.txtSizeBinhQuan.text forKey:@"averageWeight"];
    [newData setObject:arrFood forKey:@"food"];
    [newData setObject:arrMedicine forKey:@"medicine"];
    [newData setObject:userName forKey:@"by"];
    [newData setObject:accessToken forKey:@"accessToken"];
    
    if (self.c_data) {
        NSMutableDictionary *environment = [[NSMutableDictionary alloc] init];
        [environment setObject:self.c_data.c_environmentRecord.e_do forKey:@"do"];
        [environment setObject:self.c_data.c_environmentRecord.e_no2 forKey:@"no2"];
        [environment setObject:self.c_data.c_environmentRecord.e_ph forKey:@"ph"];
        
        NSMutableDictionary *numberOfDeadFish = [[NSMutableDictionary alloc] init];
        [numberOfDeadFish setObject:self.c_data.c_detailFishDeadRecord.dF_countDead forKey:@"countDead"];
        [numberOfDeadFish setObject:self.c_data.c_detailFishDeadRecord.dF_weight forKey:@"weight"];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *link in self.c_data.c_detailFishDeadRecord.dF_images ) {
            [images addObject:link];
        }
        [numberOfDeadFish setObject:images forKey:@"images"];
        
        NSMutableDictionary *health = [[NSMutableDictionary alloc] init];
        [health setObject:self.c_data.c_health.h_status forKey:@"status"];
        [health setObject:self.c_data.c_health.h_note forKey:@"note"];
        
        NSMutableDictionary *food = [[NSMutableDictionary alloc] init];
        FoodRecord *foodRecord = [self.c_data.c_food firstObject];
        [food setObject:foodRecord.f_name forKey:@"name"];
        [food setObject:foodRecord.f_quantity forKey:@"quantity"];
        [food setObject:foodRecord.f_use forKey:@"use"];
        [food setObject:f_data.f_unit forKey:@"unit"];
        NSMutableArray *arrFood = [[NSMutableArray alloc] init];
        [arrFood addObject:food];
        
        NSMutableArray *arrMedicine = [[NSMutableArray alloc] init];
        for (MedicineRecord *item in self.c_data.c_medicine) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  item.m_name,@"name",
                                  item.m_quantity,@"quantity",
                                  item.m_use,@"use",
                                  m_data.m_unit,@"unit",nil];
            [arrMedicine addObject:dict];
        }
        
        [oldData setObject:self.c_data.c_id forKey:@"id"];
        [oldData setObject:aqua.a_id forKey:@"aquaId"];
        [oldData setObject:environment forKey:@"environment"];
        [oldData setObject:numberOfDeadFish forKey:@"numberOfDeadFish"];
        [oldData setObject:health forKey:@"health"];
        [oldData setObject:self.upload2.txtSizeBinhQuan.text forKey:@"averageWeight"];
        [oldData setObject:arrFood forKey:@"food"];
        [oldData setObject:arrMedicine forKey:@"medicine"];
        
        [newData setObject:self.c_data.c_id forKey:@"id"];
        
        if (arrResult.count < 1) {
            [numberOfDeadFish_new setObject:images forKey:@"images"];
            [newData setObject:numberOfDeadFish_new forKey:@"numberOfDeadFish"];
        }
        else{
            if (self.c_data.c_detailFishDeadRecord.dF_images.count < 1) {
                NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
                for (UploadResult *item in arrResult ) {
                    NSString *link = item.imgLink;
                    [arrTemp addObject:link];
                }
                [numberOfDeadFish_new setObject:arrTemp forKey:@"images"];
            }
            else{
                for (UploadResult *item in arrResult) {
                    NSString *link = item.imgLink;
                    [self.c_data.c_detailFishDeadRecord.dF_images addObject:link];
                }
                [numberOfDeadFish_new setObject:self.c_data.c_detailFishDeadRecord.dF_images forKey:@"images"];
                [newData setObject:numberOfDeadFish_new forKey:@"numberOfDeadFish"];
            }
        }
        
        [newData removeObjectForKey:@"by"];
        [newData removeObjectForKey:@"accessToken"];
        [data setObject:newData forKey:@"newData"];
        [data setObject:oldData forKey:@"oldData"];
        
        [data setObject:userName forKey:@"by"];
        [data setObject:accessToken forKey:@"accessToken"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        
        NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"------ POST STRING---------: %@",postString);
        
        [[ShareData instance].dataProxy updateData:jsonData completeHandler:^(id result, NSString *errorCode, NSString *message){
            [SVProgressHUD dismiss];
            if ([errorCode isEqualToString:@"0"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [self showAlertBox:ERROR message:@"Lỗi" tag:99];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } errorHandler:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self showAlertBox:ERROR message:error.localizedDescription tag:99];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    else{
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newData
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        
        NSString *postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"------ POST STRING---------: %@",postString);
        
        [[ShareData instance].dataProxy uploadData:jsonData completeHandler:^(id result, NSString *errorCode, NSString *message) {
            [SVProgressHUD dismiss];
            if ([errorCode isEqualToString:@"0"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [self showAlertBox:ERROR message:@"Lỗi" tag:99];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } errorHandler:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self showAlertBox:ERROR message:error.localizedDescription tag:99];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];

    }
}

#pragma mark GetData
-(void)getData:(NSString *)aquaId{
    [SVProgressHUD show];
    [[ShareData instance].dataProxy getCheckListDetail:aquaId completeHandler:^(id result, NSString *errorCode, NSString *message) {
        [SVProgressHUD dismiss];
        self.c_data = result;
        [self setData:self.c_data];
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertBox:ERROR message:error.localizedDescription tag:99];
    }];
}
-(void)setData:(CheckListDetailRecord *)data{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        FoodRecord *food = [data.c_food firstObject];
        MedicineRecord *medicine = [data.c_medicine firstObject];
        f_data = food;
        m_data = medicine;
        self.upload1.lblChonThucAn.text = food.f_name;
        self.upload1.txtSoLuong.text = StringFormat(@"%.2f",[food.f_quantity floatValue]);
        self.upload1.txtSoLan.text = StringFormat(@"%.2f",[food.f_use floatValue]);
        
        self.upload2.txtSoLuong.text = StringFormat(@"%.2f",[data.c_detailFishDeadRecord.dF_countDead floatValue]);
        self.upload2.txtTrongLuong.text = StringFormat(@"%.2f",[data.c_detailFishDeadRecord.dF_weight floatValue]);
        self.upload2.txtSizeBinhQuan.text = StringFormat(@"%.2f",[data.c_averageWeight floatValue]);
        
        [self initArrIndex];
        
        NSMutableArray *images = data.c_detailFishDeadRecord.dF_images;
        for (int i = 0; i < images.count; i++) {
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            
            [manager downloadImageWithURL:[NSURL URLWithString:StringFormat(@"%@/%@",URL_IMAGE_UPLOAD,images[i])]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
                                    if (image){
                                        [self.upload2.arrImageShow replaceObjectAtIndex:[[self.upload2.arrIndex objectAtIndex:i] intValue] withObject:image];
                                        [self.upload2.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[self.upload2.arrIndex objectAtIndex:i] intValue] inSection:0]]];
                                    }
                                }];
        }
//        for (int i = 0; i < images.count; i++) {
//            [self.upload2.arrImages replaceObjectAtIndex:i withObject:images[i]];
//        }
        self.upload2.txtThongSoDO.text = StringFormat(@"%.2f",[data.c_environmentRecord.e_do floatValue]);
        self.upload2.txtThongSoNO2.text = StringFormat(@"%.2f",[data.c_environmentRecord.e_no2 floatValue]);
        self.upload2.txtThongSoPH.text = StringFormat(@"%.2f",[data.c_environmentRecord.e_ph floatValue]);
        
        self.upload3.lblChonSucKhoe.text = data.c_health.h_status;
        self.upload3.txtGhiChu.text = data.c_health.h_note;
        
        self.upload3.arrMedicine = [data.c_medicine mutableCopy];
        [self.upload3.tableView reloadData];
        [self reloadScollView:self.upload3.arrMedicine.count];
        
        self.upload2.completedHandler(self.c_data);
    });
}

#pragma mark array index
-(void)initArrIndex{
    for (int i = 0; i < self.c_data.c_detailFishDeadRecord.dF_images.count; i++) {
        [self.upload2.arrIndex addObject:StringFormat(@"%d",i)];
    }
    NSLog(@"-----Arr Index---------:%@",self.upload2.arrIndex);
}
@end
