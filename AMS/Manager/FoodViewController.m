//
//  FoodViewController.m
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "FoodViewController.h"
#define d_food1 350
#define d_food2 200
@interface FoodViewController ()

@end

@implementation FoodViewController
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
    self.scrollView.contentSize = CGSizeMake(screenSize.width, (screenSize.height-dx)*2-d_food1-d_food2);
    self.scrollView.delegate = (id)self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, screenSize.width, screenSize.height-dx) animated:NO];
    [self.view addSubview:self.scrollView];
    
    self.food1View = [[FoodViewController1 alloc] initWithNibName:@"FoodViewController1" bundle:nil Data:data];
    self.food1View.view.frame = CGRectMake(0,0,screenSize.width,screenSize.height-dx-d_food1);
    [self.scrollView addSubview:self.food1View.view];
    
    self.food2View = [[FoodViewController2 alloc] initWithNibName:@"FoodViewController2" bundle:nil Data:data];
    self.food2View.view.frame = CGRectMake(0,screenSize.height-dx-d_food1,screenSize.width,screenSize.height-dx-d_food2);
    [self.scrollView addSubview:self.food2View.view];
}


@end
