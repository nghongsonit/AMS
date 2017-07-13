//
//  UploadViewController3.h
//  AMS
//
//  Created by SonNguyen on 4/26/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MedicineTableViewCell.h"
#import "RowRecord.h"
#import "AquacultureRecord.h"

@protocol UploadViewController3Delegate <NSObject>
-(void) showView:(NSString *)type;
-(void) reloadScollView:(NSUInteger)count;
@end
@interface UploadViewController3 : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *viewChonSucKhoe;
@property (weak, nonatomic) IBOutlet UILabel *lblChonSucKhoe;
@property (weak, nonatomic) IBOutlet UITextField *txtGhiChu;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIView *viewChonThuoc;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet UITextField *txtSoluong;
@property (weak, nonatomic) IBOutlet UITextField *txtPPSuDung;
@property (weak, nonatomic) IBOutlet UILabel *lblChonThuoc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) AquacultureRecord *aqua;
@property(nonatomic,strong) NSMutableArray *arrMedicine;

- (IBAction)TouchUpInside:(id)sender;

@property (nonatomic,strong) id<UploadViewController3Delegate>delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item ;
@end
