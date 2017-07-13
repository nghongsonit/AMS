//
//  UploadQueue.m
//  IQC
//
//  Created by SonTayTo on 10/6/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import "UploadQueue.h"

#define UPLOAD @"upload"

static const NSUInteger BufferSize = 1024*1024;
static const int MAX_LENGTH = 6;
int chunkIndex;
int totalChunk;
@implementation UploadQueue

- (id) init{
    
    self = [super init];
    if (self) {
        self.uploadQueue = [[NSMutableArray alloc] init];
        self.session = [ShareSession instanceBackgroundSession];
        
        [self configureBackgroundSessionFinished];
        [self configureUploading];
        [self configureUploadFinish];
        
        //chunkIndex = 1;
    }
    return self;
}

- (void)configureBackgroundSessionFinished
{
    typeof(ShareSession) __weak *weakSelf = self.session ;
    
    [self.session setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        if (weakSelf.savedCompletionHandler) {
            weakSelf.savedCompletionHandler();
            weakSelf.savedCompletionHandler = nil;
        }
    }];
}

-(void)configureUploading{
    typeof(self) __weak weakSelf = self ;
    [self.session setTaskDidSendBodyDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        float progress = (float)(self.offset+totalBytesSent)/self.totalDataLength;
        weakSelf.progressHandler((float)progress);
        
        
        NSLog(@"-----------Offset %ld",weakSelf.offset);
        NSLog(@"-----------totalBytesSent %lld",totalBytesSent);
        NSLog(@"-----------totalDataLength %ld",weakSelf.totalDataLength);
        
        NSLog(@"%f",progress);
    }];
}

-(void)configureUploadFinish{
    typeof(self) __weak weakSelf = self ;
    [self.session setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        if (self.uploadTask.taskIdentifier == task.taskIdentifier) {
            weakSelf.uploadTask = nil;
            if (!error){
                //if ((weakSelf.offset + weakSelf.currentLength) >= weakSelf.totalDataLength){
                    
                    weakSelf.totalDataLength = 0;
                    weakSelf.currentLength = 0;
                    weakSelf.offset = 0;
                    
                    //chunkIndex = 1;
                    
                    if (weakSelf.uploadQueue.count > 0) {
                        [weakSelf.uploadQueue removeObjectAtIndex:0];
                        weakSelf.currentIndex = (int)(MAX_LENGTH-self.uploadQueue.count-1);
                        [weakSelf start];
                    }
                //}
//                else{
//                    NSLog(@"continue...");
//                    weakSelf.offset += weakSelf.currentLength;
//                    chunkIndex++;
//                    [weakSelf startUploadChunk];
//                }
            }
            else{
                NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
                weakSelf.errHandler(error);
            }
        }
    }];
}

- (void)startUpload:(UpdateProgress) progressHandler UploadDone:(UploadDone) uploadDoneHandler error:(UploadError) error
{
    [self start];
    progressHandler(0);
    self.progressHandler = progressHandler;
    self.uploadFinishHandler = uploadDoneHandler;
    self.errHandler = error;
}

- (void)start{
    
    if (self.uploadQueue.count > 0) {
        [self startUploadChunk];
    }
    
    //self.progressHandler(0);
}

- (void)startUploadChunk{
    
    PhotoUpload *photo = [self.uploadQueue firstObject];
    self.totalDataLength = (int)photo.size;
    
//    totalChunk = (int)((self.totalDataLength + BufferSize-1)/(int)BufferSize);
//    
//    NSLog(@" ---------------------------Image size%ld",self.totalDataLength);
//    NSLog(@" ---------------------------Data Upload %@",photo.dataImage);
//    
//    NSUInteger remaining = self.totalDataLength - self.offset;
//    NSUInteger length = BufferSize < remaining ? BufferSize : remaining;
//    NSData *dataUpload = [photo.dataImage subdataWithRange:NSMakeRange(self.offset,length)];
//    
//    NSLog(@"DataUpload Length : %ld",dataUpload.length);
    
    //[self runChunkUpload:self.offset toOffset:(self.offset + length) dataUpload:dataUpload];
    [self runChunkUpload:0 toOffset:photo.size dataUpload:photo.dataImage];
     //self.currentLength = length;
}

- (void)runChunkUpload:(NSUInteger)fromOffset toOffset:(NSUInteger)toOffset dataUpload:(NSData *)dataUpload{
    PhotoUpload *photo = [self.uploadQueue firstObject];
    
    NSString *url = StringFormat(@"%@/%@/%@",BaseURL,UPLOAD,photo.name);
    
//    NSString *contractNumber = [ShareHelper getUserDefaults:@"contract_number"];
//    NSString *mobileAccount = [ShareHelper getUserDefaults:@"u_a"];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    
//    toOffset = toOffset - 1;
//    NSString *rangesValue = [NSString stringWithFormat:@"bytes %li-%li/%lu",(long)(fromOffset ),(long)toOffset,(unsigned long)self.totalDataLength];
//    NSString *contentLenght = [NSString stringWithFormat:@"%li",(unsigned long)[dataUpload length]];
//    NSString *sessionID = [ShareHelper getSHA1:photo.name];
//    NSString *contentDisposition = StringFormat(@"attachment; filename=\"%@\"",photo.name);
//    
//    [urlRequest addValue:@"Connection" forHTTPHeaderField:@"Keep-Alive"];
//    [urlRequest addValue:rangesValue forHTTPHeaderField: @"Content-Range"];
//    [urlRequest addValue:contentLenght forHTTPHeaderField: @"Content-Length"];
//    [urlRequest addValue:sessionID forHTTPHeaderField:@"Session-ID"];
//    [urlRequest addValue:contentDisposition forHTTPHeaderField:@"Content-Disposition"];
//    [urlRequest addValue:contractNumber forHTTPHeaderField:@"iqc-contract-name"];
//    [urlRequest addValue:mobileAccount forHTTPHeaderField:@"iqc-mobi-account"];
    [urlRequest addValue:@"application/octet-stream" forHTTPHeaderField: @"Content-Type"];
//    [urlRequest addValue:StringFormat(@"%d ",chunkIndex) forHTTPHeaderField:@"X-Chunk-Index"];
//    [urlRequest addValue:StringFormat(@"%d ",totalChunk) forHTTPHeaderField:@"X-Chunks-Number"];
    
    [urlRequest setHTTPBody:dataUpload];
    
    self.uploadTask = [self.session uploadTaskWithStreamedRequest:urlRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            //[progressView setProgress:uploadProgress.fractionCompleted];
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSInteger httpCode = [(NSHTTPURLResponse*)response statusCode];
        
        if((httpCode != 200)){
            //NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
            self.errHandler(error);
            return;
        }
        NSString *errorCode = StringFormat(@"%@",[responseObject objectForKey:@"code"]);
        if (![errorCode isEqualToString:@"0"]){
            NSError *err = [[NSError alloc] initWithDomain:HTTPDOMAIN code:httpCode userInfo:nil];
            self.errHandler(err);
            return;
        }
        UploadResult *item = [UploadResult new];
        
        //NSString *formatLink = StringFormat(@"%@/%@",URL_IMAGE_UPLOAD,[responseObject objectForKey:@"link"]);
        item.imgLink = [responseObject objectForKey:@"link"];
        item.imgCode = [responseObject objectForKey:@"code"];
        self.uploadFinishHandler(item);
        
        //NSLog(@"Upload Done Image at %@",item.imgIndex);
        NSLog(@"Remain Item %ld",self.uploadQueue.count);
        
        if (self.uploadQueue.count == 0) {
            // NSLog(@"Image Index: %ld",item.imgIndex);
            NSLog(@"Total Complete");
        }
        
    }];
    [self.uploadTask resume];

}

- (void)cancelUpload{
    [self.uploadTask cancel];
    self.totalDataLength = 0;
    self.currentLength = 0;
    self.offset = 0;
    chunkIndex = 1;
    [self.uploadQueue removeAllObjects];
}
@end
