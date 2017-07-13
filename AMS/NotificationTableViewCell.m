//
//  NotificationTableViewCell.m
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lblLabel.numberOfLines = 0;
    self.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x += 5;
    frame.size.width -= 2 * 5;
    [super setFrame:frame];
}
@end
