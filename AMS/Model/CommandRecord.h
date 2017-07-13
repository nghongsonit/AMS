//
//  CommandRecord.h
//  AMS
//
//  Created by SonNguyen on 5/8/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandRecord : NSObject
@property(nonatomic,strong) NSString *c_id;
@property(nonatomic,strong) NSString *c_username;
@property(nonatomic,strong) NSString *c_message;
@property(nonatomic,strong) NSString *c_aquaId;
@property(nonatomic,strong) NSString *c_toGroup;
@property(nonatomic,strong) NSString *c_except;
@property(nonatomic,strong) NSString *c_createdBy;
@property(nonatomic,strong) NSString *c_createdDate;
@end
