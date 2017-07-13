//
//  ChartEnvironmentRecord.h
//  AMS
//
//  Created by SonNguyen on 5/14/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnvironmentRecord.h"

@interface ChartEnvironmentRecord : NSObject
@property(nonatomic,strong) EnvironmentRecord *e_environment;
@property(nonatomic,strong) NSString *e_date;
@end
