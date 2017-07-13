//
//  UploadViewController.h
//  AMS
//
//  Created by SonNguyen on 4/26/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UploadViewController1.h"
#import "UploadViewController2.h"
#import "UploadViewController3.h"
#import "AquacultureRecord.h"
#import "RowRecord.h"
#import "CheckListDetailRecord.h"

@interface UploadViewController : BaseViewController<UploadViewController1Delegate,ShowOptionViewControllerDelegate,UploadViewController2Delegate,UploadViewController3Delegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UploadViewController1 *upload1;
@property (nonatomic,strong) UploadViewController2 *upload2;
@property (nonatomic,strong) UploadViewController3 *upload3;
@property (nonatomic,strong) AquacultureRecord *aqua;
@property (nonatomic,strong) NSString *songay;
@property (nonatomic) BOOL isFinish;

@property (nonatomic,strong) CheckListDetailRecord *c_data;

@property (nonatomic, retain) UploadQueue *uploadQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item Days:(NSString *)days Finish:(BOOL)finish ;
@end
