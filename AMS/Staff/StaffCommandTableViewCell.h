//
//  StaffCommandTableViewCell.h
//  AMS
//
//  Created by SonNguyen on 5/8/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffCommandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCreateBy;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
