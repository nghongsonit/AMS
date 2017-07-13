//
//  BaseOperation.h
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareSession.h"

#define BaseURL  @"http://api.amsapp.xyz/api"


typedef void (^ErrorBlock)(NSError *error);
typedef void (^FinishBlock)(NSDictionary *result, NSURLResponse *response);

@interface BaseOperation : NSObject<NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
{
    ShareSession *session;
    NSURLRequest *request;
    ErrorBlock errorHandler;
    FinishBlock completionHandler;
}

@property (nonatomic, retain) NSURLRequest *request;

@property (nonatomic, retain) ShareSession *session;

@property (nonatomic, copy) ErrorBlock errorHandler;
@property (nonatomic, copy) FinishBlock completionHandler;

@property (nonatomic, retain) NSMutableDictionary *result;

- (void)start;
@end
