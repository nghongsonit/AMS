//
//  UserRecord.h
//  AMS
//
//  Created by SonNguyen on 4/19/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRecord : NSObject

@property(nonatomic,strong) NSString *u_id;
@property(nonatomic,strong) NSString *u_name;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *u_email;
@property(nonatomic,strong) NSString *u_mobile;
@property(nonatomic,strong) NSString *u_birthday;
@property(nonatomic,strong) NSString *u_inJob;
@property(nonatomic,strong) NSString *u_status;
@property(nonatomic,strong) NSString *u_appType;
@property(nonatomic,strong) NSString *u_role;
@property(nonatomic,strong) NSString *u_area;
@property(nonatomic,strong) NSArray *u_aquaculture;
@property(nonatomic,strong) NSString *accessToken;

@end
