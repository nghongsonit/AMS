//
//  CurrentInfoRecord.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthRecord.h"

@interface CurrentInfoRecord : NSObject
@property(nonatomic,strong) NSString *i_calculatedDate;
@property(nonatomic,strong) NSString *i_averageWeight;
@property(nonatomic,strong) HealthRecord *i_health;
@property(nonatomic,strong) NSString *i_totalFood;
@property(nonatomic,strong) NSString *i_deadFishWeight;
@property(nonatomic,strong) NSString *i_deadFishCount;
@property(nonatomic,strong) NSString *i_deadFishCountDay;
@property(nonatomic,strong) NSString *i_deadFishWeightDay;
@property(nonatomic,strong) NSArray *i_images;
@end
