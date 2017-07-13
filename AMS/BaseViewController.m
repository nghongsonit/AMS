//
//  BaseViewController.m
//  PlusFarm
//
//  Created by SonNguyen on 11/18/16.
//  Copyright © 2016 SonNguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize isNetWorkAvailble;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.barTintColor = colorWithRGB(62, 201, 232, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self initMenuBarButtonItems];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (!(status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown)) {
            isNetWorkAvailble = YES;
        }
        else{
            isNetWorkAvailble = NO;
            [self showAlertBox:TITLE_ALERT message:NETWORK_ERROR tag:99];
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertBox:(NSString *)title
             message:(NSString *)message
                 tag:(NSInteger )tag {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    [alert addAction:yesButton];
    alert.view.tag = tag;
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)pushView:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)initMenuBarButtonItems{
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
}

- (UIBarButtonItem *) leftMenuBarButtonItem {
    
    UIImage *image = [ShareHelper imageWithImageHeight:[UIImage imageNamed:@"ic_back"] height:30];
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UploadQueue *)createUploadQueue {
    static UploadQueue *uploadQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadQueue = [UploadQueue new];
    });
    return uploadQueue;
}

@end
