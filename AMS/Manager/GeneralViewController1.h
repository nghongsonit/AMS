//
//  GeneralViewController1.h
//  AMS
//
//  Created by SonNguyen on 5/10/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GeneralViewController1 : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *lblSizeBinhQuan;
@property (weak, nonatomic) IBOutlet UILabel *lblSoLuongHienTai;
@property (weak, nonatomic) IBOutlet UILabel *lblFCR;
@property (weak, nonatomic) IBOutlet UILabel *lblPhanTramCaHaoHut;
@property (weak, nonatomic) IBOutlet UILabel *lblSoLuongCaUocTinh;
@property (weak, nonatomic) IBOutlet UILabel *lblSoluongCaHaoTrongNgay;
@property (weak, nonatomic) IBOutlet UILabel *lblTrongLuongCaHao;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property(nonatomic,strong) NSMutableArray *images;
@end
