//
//  PhotoCollectionViewCell.h
//  AMS
//
//  Created by SonNguyen on 5/17/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet CustomButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdd;
@end
