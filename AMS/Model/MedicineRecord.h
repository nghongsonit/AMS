//
//  MedicineRecord.h
//  AMS
//
//  Created by SonNguyen on 5/3/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicineRecord : NSObject
@property(nonatomic,strong) NSString *m_id;
@property(nonatomic,strong) NSString *m_name;
@property(nonatomic,strong) NSString *m_unit;
@property(nonatomic,strong) NSString *m_use;
@property(nonatomic,strong) NSString *m_quantity;
@end
