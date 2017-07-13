//
//  HomeTableViewCell.h
//  AMS
//
//  Created by SonNguyen on 4/20/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblAo;
@property (weak, nonatomic) IBOutlet UILabel *lblVuNuoi;
@property (weak, nonatomic) IBOutlet UILabel *lblSoNgay;
@property (weak, nonatomic) IBOutlet UILabel *lblTrangThai;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblFinish;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDate;

@end
