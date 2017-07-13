//
//  FoodViewController.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "ViewController.h"
#import "FoodViewController1.h"
#import "FoodViewController2.h"

@interface FoodViewController : ViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,strong) FoodViewController1 *food1View;
@property(nonatomic,strong) FoodViewController2 *food2View;

@property (nonatomic,strong) AquacultureRecord *data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Data:(id)item;
@end
