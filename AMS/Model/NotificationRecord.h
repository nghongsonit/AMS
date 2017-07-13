//
//  NotificationRecord.h
//  AMS
//
//  Created by SonNguyen on 5/24/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationDataRecord.h"

@interface NotificationRecord : NSObject
@property (nonatomic,strong) NSString *n_id;
@property (nonatomic,strong) NSString *n_username;
@property (nonatomic,strong) NSString *n_message;
@property (nonatomic,strong) NSString *n_type;
@property (nonatomic,strong) NotificationDataRecord *n_data;
@property (nonatomic,strong) NSString *n_toGroup;
@property (nonatomic,strong) NSString *n_except;
@property (nonatomic,strong) NSString *n_read;
@property (nonatomic,strong) NSString *n_createdBy;
@property (nonatomic,strong) NSString *n_createdDate;
@end
