//
//  HEViewController.m
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "HEViewController.h"
#define d_HE1 100
#define d_HE2 150
#define d_HE3 200
@interface HEViewController ()

@end

@implementation HEViewController
@synthesize data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    data = item;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height-49-64)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(screenSize.width, (screenSize.height-dx)*3-d_HE1-d_HE2-d_HE3);
    self.scrollView.delegate = (id)self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, screenSize.width, screenSize.height-dx) animated:NO];
    [self.view addSubview:self.scrollView];
    
    self.HE1View = [[HEViewController1 alloc] initWithNibName:@"HEViewController1" bundle:nil Data:data];
    self.HE1View.view.frame = CGRectMake(0,0,screenSize.width,screenSize.height-dx-d_HE1);
    [self.scrollView addSubview:self.HE1View.view];
    
    self.HE2View = [[HEViewController2 alloc] initWithNibName:@"HEViewController2" bundle:nil Data:data];
    self.HE2View.view.frame = CGRectMake(0,screenSize.height-dx-d_HE1,screenSize.width,screenSize.height-dx-d_HE2);
    [self.scrollView addSubview:self.HE2View.view];
    
    self.HE3View = [[HEViewController3 alloc] initWithNibName:@"HEViewController3" bundle:nil Data:data];
    self.HE3View.view.frame = CGRectMake(0,(screenSize.height-dx)*2-d_HE1-d_HE2,screenSize.width,screenSize.height-dx-d_HE3);
    [self.scrollView addSubview:self.HE3View.view];
}

@end
