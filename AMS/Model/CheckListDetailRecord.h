//
//  CheckListDetailRecord.h
//  AMS
//
//  Created by SonNguyen on 5/15/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailFishDeadRecord.h"
#import "HealthRecord.h"
#import "EnvironmentRecord.h"

@interface CheckListDetailRecord : NSObject
@property(nonatomic,strong) NSString *c_id;
@property(nonatomic,strong) NSString *c_aquaId;
@property(nonatomic,strong) NSString *c_averageWeight;
@property(nonatomic,strong) EnvironmentRecord *c_environmentRecord;
@property(nonatomic,strong) DetailFishDeadRecord *c_detailFishDeadRecord;
@property(nonatomic,strong) HealthRecord *c_health;
@property(nonatomic,strong) NSArray *c_food;
@property(nonatomic,strong) NSArray *c_medicine;
@end
