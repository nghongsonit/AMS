//
//  HEViewController.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ViewController.h"
#import "HEViewController1.h"
#import "HEViewController2.h"
#import "HEViewController3.h"

@interface HEViewController : ViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,strong) HEViewController1 *HE1View;
@property(nonatomic,strong) HEViewController2 *HE2View;
@property(nonatomic,strong) HEViewController3 *HE3View;

@property (nonatomic,strong) AquacultureRecord *data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;
@end
