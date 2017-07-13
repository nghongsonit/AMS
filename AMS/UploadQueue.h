//
//  UploadQueue.h
//  IQC
//
//  Created by SonTayTo on 10/6/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseProxy.h"
#import "PhotoUpload.h"
#import "UploadResult.h"

typedef void(^UpdateProgress)(float percent);
typedef void(^UploadDone)(UploadResult *item);
typedef void(^UploadError)(NSError * err);

@interface UploadQueue : BaseProxy

@property (nonatomic, copy) UpdateProgress progressHandler;
@property (nonatomic, copy) UploadDone uploadFinishHandler;
@property (nonatomic, copy) UploadError errHandler;

@property (nonatomic, retain) ShareSession *session;
@property (nonatomic,retain) NSURLSessionUploadTask *uploadTask;

@property (nonatomic,retain) NSMutableArray *uploadQueue;

@property (nonatomic) NSUInteger totalDataLength;
@property (nonatomic) NSUInteger currentLength;
@property (nonatomic) NSUInteger offset;

@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *imgName;

@property (nonatomic) int currentIndex;

- (void) startUpload:(UpdateProgress) progressHandler UploadDone:(UploadDone) uploadDoneHandler error:(UploadError) error;
- (void)cancelUpload;
@end
