//
//  GeneralViewController.m
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "GeneralViewController.h"
#define d_general1 180
#define d_general2 200
#define d_general3 220
#define d_general4 250

@interface GeneralViewController ()

@end

@implementation GeneralViewController
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
    self.scrollView.contentSize = CGSizeMake(screenSize.width, (screenSize.height-dx)*4-d_general1-d_general2-d_general3-d_general4);
    self.scrollView.delegate = (id)self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, screenSize.width, screenSize.height-dx) animated:NO];
    [self.view addSubview:self.scrollView];
    
    self.general1 = [[GeneralViewController1 alloc] initWithNibName:@"GeneralViewController1" bundle:nil];
    self.general1.view.frame = CGRectMake(0,0,screenSize.width,screenSize.height-dx-d_general1);
    [self.scrollView addSubview:self.general1.view];
    
    self.general2 = [[GeneralViewController2 alloc] initWithNibName:@"GeneralViewController2" bundle:nil Data:data];
    self.general2.view.frame = CGRectMake(0,screenSize.height-dx-d_general1,screenSize.width,screenSize.height-dx-d_general2);
    [self.scrollView addSubview:self.general2.view];
    
    self.general3 = [[GeneralViewController3 alloc] initWithNibName:@"GeneralViewController3" bundle:nil Data:data];
    self.general3.view.frame = CGRectMake(0,(screenSize.height-dx)*2-d_general1-d_general2,screenSize.width,screenSize.height-dx-d_general3);
    [self.scrollView addSubview:self.general3.view];
    
    self.general4 = [[GeneralViewController4 alloc] initWithNibName:@"GeneralViewController4" bundle:nil];
    self.general4.view.frame = CGRectMake(0,(screenSize.height-dx)*3-d_general1-d_general2-d_general3,screenSize.width,screenSize.height-dx-d_general4);
    [self.scrollView addSubview:self.general4.view];
}


@end
