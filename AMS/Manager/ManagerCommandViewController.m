//
//  ManagerCommandViewController.m
//  AMS
//
//  Created by SonNguyen on 5/19/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ManagerCommandViewController.h"

@interface ManagerCommandViewController ()

@end

@implementation ManagerCommandViewController

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

- (void)initMenuBarButtonItems{
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    self.navigationItem.title = @"TẠO CHỈ THỊ";

}

- (UIBarButtonItem *)rightMenuBarButtonItem{
    UIImage *image = [ShareHelper imageWithImageHeight:[UIImage imageNamed:@"ic_lichsu"] height:20];
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showCommand:)];
}

- (void)showCommand:(id)sender {
    CommandViewController *commandViewController = [[CommandViewController alloc] initWithNibName:@"CommandViewController" bundle:nil];
    [self pushView:commandViewController];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}


-(void)initView{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = nil;
    self.containerView.layer.cornerRadius = 10.0f;
    self.selectedView.layer.cornerRadius = 5.0f;
    [self.txtNoiDung sizeToFit];
    self.txtNoiDung.text = @"Nội dung chỉ thị";
    self.txtNoiDung.textColor = [UIColor lightGrayColor];
    
    self.btnCommand.layer.cornerRadius = 20.0f;
    self.btnCommand.backgroundColor = colorWithRGB(62, 201, 232, 1);
    self.btnCommand.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btnCommand.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(showOption:)];
    
    [self.selectedView addGestureRecognizer:tap];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.textColor == [UIColor lightGrayColor]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Nội dung chỉ thị";
        textView.textColor =[UIColor lightGrayColor];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)TouchUpInside:(id)sender {
    // Post Command
    
    if (![ShareHelper checkWhiteSpace:self.txtNoiDung.text] && ![self.lblChonNguoi.text isEqualToString:@"Vui lòng chọn người nhận"] && ![self.txtNoiDung.text isEqualToString:@"Nội dung chỉ thị"]){
        [SVProgressHUD show];
        [[ShareData instance].dataProxy postCommand:self.lblChonNguoi.text Message:self.txtNoiDung.text completionHandler:^(id result, NSString *errorCode, NSString *message) {
            [SVProgressHUD dismiss];
            [self showAlertBox:@"Thông báo" message:@"Tạo chỉ thị thành công" tag:100];
        } errorHandler:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self showAlertBox:ERROR message:error.localizedDescription tag:99];
        }];
    }
    else
        [self showAlertBox:ERROR message:@"Vui lòng nhập đầy đủ thông tin" tag:99];
}

-(void)showOption:(UITapGestureRecognizer *)tap{
    ShowOptionViewController *showOption = [[ShowOptionViewController alloc] initWithNibName:@"ShowOptionViewController" bundle:nil Type:@"Chọn người nhận"];
    showOption.delegate = (id)self;
    [self pushView:showOption];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)getData:(id)data Type:(NSString *)type{
    UserAreaRecord *item = data;
    self.lblChonNguoi.text = item.u_username;
}
@end
