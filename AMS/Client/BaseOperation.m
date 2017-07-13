//
//  BaseOperation.m
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import "BaseOperation.h"

@implementation BaseOperation

@synthesize errorHandler;
@synthesize completionHandler;
@synthesize request;
@synthesize session;

-(void)start{
    
    session = [ShareSession instance];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:self.request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            self.completionHandler(responseObject, response);
        }
        else{
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            self.errorHandler(error);
        }
    }];
    [dataTask resume];
}


@end
