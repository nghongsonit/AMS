//
//  PhotoUpload.h
//  IQC
//
//  Created by SonTayTo on 10/3/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QBImagePickerController/QBImagePickerController.h>

@interface PhotoUpload : NSObject

@property(nonatomic,retain) NSString *path;
@property(nonatomic,retain) NSURL *url;
@property(nonatomic,retain) NSString *name;
@property(nonatomic) NSUInteger size;
@property(nonatomic,retain) NSData *dataImage;
@property(nonatomic,retain) UIImage *image;

@end
