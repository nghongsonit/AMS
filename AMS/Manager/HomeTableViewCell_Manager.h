//
//  HomeTableViewCell_Manager.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell_Manager : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblAo;
@property (weak, nonatomic) IBOutlet UILabel *lblTinhTrang;
@property (weak, nonatomic) IBOutlet UILabel *lblPhanTram;
@property (weak, nonatomic) IBOutlet UILabel *lblLuyKe;
@property (weak, nonatomic) IBOutlet UILabel *lblSizeBQ;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblNgayBaoCao;
@property (weak, nonatomic) IBOutlet UILabel *lblBaoCaoMoiNhat;

@end
