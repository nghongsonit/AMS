//
//  UploadViewController1.m
//  AMS
//
//  Created by SonNguyen on 4/26/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "UploadViewController1.h"

@interface UploadViewController1 ()

@end

@implementation UploadViewController1
@synthesize aqua;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item{
    self = [super init];
    aqua = item;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    self.lbl1.layer.cornerRadius = self.lbl1.frame.size.width/2.0;
    self.lbl2.layer.cornerRadius = self.lbl1.frame.size.width/2.0;
    self.lbl1.layer.masksToBounds = YES;
    self.lbl2.layer.masksToBounds = YES;
    self.viewChonThucAn.layer.cornerRadius = 5.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                   action:@selector(showOption:)];
    
    [self.viewChonThucAn addGestureRecognizer:tap];
    
    self.txtSoLuong.keyboardType = UIKeyboardTypeDecimalPad;
    self.txtSoLan.keyboardType = UIKeyboardTypeNumberPad;
    
    self.lblNgayKiemTra.text = [ShareHelper getCurrentDate1];
}

-(void)showOption:(UITapGestureRecognizer *)tap{
    if (_delegate) {
        [self.delegate showView:@"Chọn thức ăn"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
