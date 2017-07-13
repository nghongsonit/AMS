//
//  UploadViewController2.h
//  AMS
//
//  Created by SonNguyen on 4/26/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "QBImagePickerController.h"
#import "UploadQueue.h"
#import "AquacultureRecord.h"
#import "PhotoCollectionViewCell.h"

@protocol UploadViewController2Delegate <NSObject>

-(void)changeView;

@end

typedef void (^CallBackBlock)(id data);
@interface UploadViewController2 : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *txtSoLuong;
@property (weak, nonatomic) IBOutlet UITextField *txtSizeBinhQuan;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UITextField *txtTrongLuong;
@property (weak, nonatomic) IBOutlet UITextField *txtThongSoDO;
@property (weak, nonatomic) IBOutlet UITextField *txtThongSoNO2;
@property (weak, nonatomic) IBOutlet UITextField *txtThongSoPH;

@property (nonatomic,strong) NSMutableArray *arrImages;
@property (nonatomic,strong) NSMutableArray *arrImageShow;
@property (nonatomic,strong) NSMutableArray *arrIndex;

@property (nonatomic,strong) AquacultureRecord *aqua;

@property(nonatomic,strong) NSMutableArray *images;

@property(nonatomic,strong) id<UploadViewController2Delegate>delegate;

@property (nonatomic,copy) CallBackBlock completedHandler;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item ;
@end
