//
//  ShareData.m
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import "ShareData.h"

@implementation ShareData

@synthesize dataProxy;

static ShareData *_instance = nil;

- (id)init
{
    self = [super init];
    if (self) {
        dataProxy = [[DataProxy alloc] init];
    }
    
    return self;
}
+ (ShareData *)instance {
    @synchronized(self)
    {
        if(_instance == nil)
        {
            _instance= [ShareData new];
            
        }
    }
    return _instance;
}

@end
