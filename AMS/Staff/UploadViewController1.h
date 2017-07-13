//
//  UploadViewController1.h
//  AMS
//
//  Created by SonNguyen on 4/26/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ShowOptionViewController.h"
#import "NotificationViewController.h"
#import "AquacultureRecord.h"

@protocol UploadViewController1Delegate <NSObject>

-(void) showView:(NSString *)type;

@end

@interface UploadViewController1 :BaseViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lblNgayKiemTra;
@property (weak, nonatomic) IBOutlet UILabel *lblSoNgayNuoi;
@property (weak, nonatomic) IBOutlet UIView *viewChonThucAn;
@property (weak, nonatomic) IBOutlet UILabel *lblChonThucAn;
@property (weak, nonatomic) IBOutlet UITextField *txtSoLuong;
@property (weak, nonatomic) IBOutlet UITextField *txtSoLan;

@property (nonatomic,strong) AquacultureRecord *aqua;

@property(nonatomic,strong)id<UploadViewController1Delegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item ;
@end
