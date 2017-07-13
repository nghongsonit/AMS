//
//  GeneralViewController1.m
//  AMS
//
//  Created by SonNguyen on 5/10/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "GeneralViewController1.h"

@interface GeneralViewController1 ()

@end

@implementation GeneralViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    self.images = [[NSMutableArray alloc] init];
    [self.images addObject:self.img1];
    [self.images addObject:self.img2];
    [self.images addObject:self.img3];

}

@end
