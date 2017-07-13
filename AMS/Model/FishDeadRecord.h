//
//  FishDeadRecord.h
//  AMS
//
//  Created by SonNguyen on 5/14/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailFishDeadRecord.h"

@interface FishDeadRecord : NSObject
@property(nonatomic,strong) DetailFishDeadRecord *fD_numberDeadOfFish;
@property(nonatomic,strong) NSString *fD_date;
@end
