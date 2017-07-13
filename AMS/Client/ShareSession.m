//
//  ShareSession.m
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import "ShareSession.h"

static NSString * const kBackgroundSessionIdentifier = @"sontayto.backgroundsession";

@implementation ShareSession

+(ShareSession *)instance{
    
    static ShareSession *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ShareSession alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        //manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    });
    return manager;
}

+(ShareSession *)instanceBackgroundSession{
    
    static ShareSession *session = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[ShareSession alloc] initWithSessionConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundSessionIdentifier]];
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"text/plain"];
        jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        
        session.responseSerializer = jsonResponseSerializer;
    });
    return session;
}

@end
