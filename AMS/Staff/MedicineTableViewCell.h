//
//  MedicineTableViewCell.h
//  AMS
//
//  Created by SonNguyen on 5/3/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface MedicineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTenThuoc;
@property (weak, nonatomic) IBOutlet UILabel *lblPP;
@property (weak, nonatomic) IBOutlet UILabel *lblSoLuong;
@property (weak, nonatomic) IBOutlet CustomButton *btnDelete;
- (IBAction)deleteRow:(id)sender;


@end
