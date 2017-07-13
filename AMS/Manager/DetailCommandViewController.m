//
//  DetailCommandViewController.m
//  AMS
//
//  Created by SonNguyen on 5/23/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "DetailCommandViewController.h"

@interface DetailCommandViewController ()

@end

@implementation DetailCommandViewController
@synthesize data,type;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item Type:(NSString *)typeClass{
    self = [super init];
    data = item;
    type = typeClass;
    return self;
}
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"CHI TIẾT CHỈ THỊ";
}

-(void)initView{
    self.containerView.layer.cornerRadius = 5.0f;
    if ([data isKindOfClass:[CommandRecord class]]) {
        CommandRecord *item = data;
        if ([type isEqualToString:@"Manager"]) {
            self.lblCreateBy.text =StringFormat(@"Bạn gửi chỉ thị tới: %@", item.c_username);
        }
        else{
            self.lblCreateBy.text = StringFormat(@"Bạn nhận được chỉ thị từ : %@", item.c_createdBy);
        }
        self.lblMessage.text = StringFormat(@"Nội dung chỉ thị: %@", item.c_message);
        
        NSString *createdDate = [ShareHelper getDateTimeByFormatDay1:item.c_createdDate];
        NSArray *tempArr = [createdDate  componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
        self.lblDate.text = tempArr[0];
        self.lblTime.text = tempArr[1];
        NSString *day = tempArr[2];
        
        if ([day isEqualToString:[ShareHelper getCurrentDate3]]) {
            self.lblDay.text = @"HÔM NAY";
        }
        else
            self.lblDay.text = day;
    }
    else{
        NotificationRecord *item = data;
        if ([type isEqualToString:@"Staff"]) {
            self.lblCreateBy.text = StringFormat(@"Bạn nhận được chỉ thị từ : %@", item.n_createdBy);
        }
        else{
            self.lblCreateBy.text =StringFormat(@"Bạn gửi chỉ thị tới: %@", item.n_username);
        }
        self.lblMessage.text = StringFormat(@"Nội dung chỉ thị: %@", item.n_message);
        
        NSString *createdDate = [ShareHelper getDateTimeByFormatDay1:item.n_createdDate];
        NSArray *tempArr = [createdDate  componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
        self.lblDate.text = tempArr[0];
        self.lblTime.text = tempArr[1];
        NSString *day = tempArr[2];
        
        if ([day isEqualToString:[ShareHelper getCurrentDate3]]) {
            self.lblDay.text = @"HÔM NAY";
        }
        else
            self.lblDay.text = day;
    }
        
}

@end
