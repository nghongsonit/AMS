//
//  StaffCommandTableViewCell.m
//  AMS
//
//  Created by SonNguyen on 5/8/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "StaffCommandTableViewCell.h"

@implementation StaffCommandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.lblMessage.numberOfLines = 0;
}

@end
