//
//  StaffDetailViewController.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "AquacultureRecord.h"
#import "CurrentInfoRecord.h"
#import "UploadViewController.h"

@interface StaffDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,strong) AquacultureRecord *data;
@property (nonatomic,strong) NSString *temp;
@property (nonatomic) BOOL isFinish;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item Days:(NSString *)days Finish:(BOOL)finish;
@property (weak, nonatomic) IBOutlet UILabel *lblImportDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalFish;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalWeightFish;
@property (weak, nonatomic) IBOutlet UILabel *lblDensityWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblDensityStretch;
@property (weak, nonatomic) IBOutlet UILabel *lblDeadFishCount;
@property (weak, nonatomic) IBOutlet UILabel *lblAverageWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentFish;
@property (weak, nonatomic) IBOutlet UILabel *lblDienTich;
@property (weak, nonatomic) IBOutlet UILabel *lblKhuVuc;
@end
