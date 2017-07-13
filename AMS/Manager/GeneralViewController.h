//
//  GeneralViewController.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ViewController.h"
#import "GeneralViewController1.h"
#import "GeneralViewController2.h"
#import "GeneralViewController3.h"
#import "GeneralViewController4.h"

@interface GeneralViewController : ViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) GeneralViewController1 *general1;
@property (nonatomic,strong) GeneralViewController2 *general2;
@property (nonatomic,strong) GeneralViewController3 *general3;
@property (nonatomic,strong) GeneralViewController4 *general4;

@property (nonatomic,strong) AquacultureRecord *data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;
@end
