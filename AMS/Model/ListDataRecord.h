//
//  ListFoodRecord.h
//  AMS
//
//  Created by SonNguyen on 4/28/17.
//  Copyright © 2017 SonNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodRecord.h"

@interface ListDataRecord : NSObject
@property(nonatomic,strong) NSString *l_total;
@property(nonatomic,strong) NSString *l_limit;
@property(nonatomic,strong) NSString *l_page;
@property(nonatomic,strong) NSString *l_pages;
@property(nonatomic,strong) NSArray *l_docs;
@end
