//
//  MedicineTableViewCell.m
//  AMS
//
//  Created by SonNguyen on 5/3/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import "MedicineTableViewCell.h"

@implementation MedicineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (IBAction)deleteRow:(id)sender {
}
@end
