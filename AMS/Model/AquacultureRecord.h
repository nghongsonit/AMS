//
//  AquacultureRecord.h
//  AMS
//
//  Created by SonNguyen on 4/22/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentInfoRecord.h"

@interface AquacultureRecord : NSObject
@property(nonatomic,strong) NSString *a_id;
@property(nonatomic,strong) NSString *a_name;
@property(nonatomic,strong) NSString *a_fishpond;
@property(nonatomic,strong) NSString *a_area;
@property(nonatomic,strong) NSString *a_season;
@property(nonatomic,strong) NSString *a_importDate;
@property(nonatomic,strong) NSString *a_exportDate;
@property(nonatomic,strong) NSString *a_totalFish;
@property(nonatomic,strong) NSString *a_totalWeightFish;
@property(nonatomic,strong) NSString *a_densityWeight;
@property(nonatomic,strong) NSString *a_densityStretch;
@property(nonatomic,strong) NSString *a_createdBy;
@property(nonatomic,strong) NSString *a_createdDate;
@property(nonatomic,strong) NSString *a_stretch;
@property(nonatomic,strong) CurrentInfoRecord *a_currentInfo;

@end
