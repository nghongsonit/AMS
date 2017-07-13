//
//  ShareData.h
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ShareSession.h"
#import "DataProxy.h"

@interface ShareData : NSObject

@property(nonatomic,retain) NSArray *cookies;
@property(nonatomic,retain) DataProxy *dataProxy;
@property(nonatomic,retain) ShareSession *session;

+ (ShareData *)instance;

@end
