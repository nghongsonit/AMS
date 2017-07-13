//
//  ShareSession.h
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLSessionManager.h"

@interface ShareSession : AFURLSessionManager

@property (nonatomic, copy) void (^savedCompletionHandler)(void);

+(ShareSession *)instance;
+(ShareSession *)instanceBackgroundSession;
@end
