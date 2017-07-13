//
//  HomeTableViewCell_Manager.m
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "HomeTableViewCell_Manager.h"

@implementation HomeTableViewCell_Manager

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
