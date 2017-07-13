//
//  BaseProxy.h
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseOperation.h"
#import "ShareHelper.h"
//
#define HTTPDOMAIN @"HTTPDOMAIN"
//
typedef void (^DidGetItemsBlock)(NSArray *result, NSString *errorCode, NSString *message);
typedef void (^DidGetResultBlock)(id result, NSString *errorCode, NSString *message);
typedef void (^DidActionBlock)(id obj);

@interface BaseProxy : NSObject

@end
