//
//  ShareHelper.h
//  IQC
//
//  Created by SonTayTo on 9/30/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareHelper : NSObject

#pragma mark - Image
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size point:(CGPoint)xy;
+ (UIImage *)imageWithImageHeight:(UIImage *)image height:(float)height;
+ (UIImage *)imageByOverwriteColor:(UIColor *)color alpha:(float)alpha image:(UIImage*)image;
+ (UIImage *)imageByScalingAndCroppingForSize:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

#pragma mark - Color
+ (UIColor *)colorFromHexString:(NSString *)hexString;

#pragma mark - UserDefaults
+ (void)saveUserDefaults:(NSDictionary *)dictionary;
+ (id)getUserDefaults:(NSString *)key;
+ (void)clearUserDefault:(NSString *)key;

#pragma mark - Handle string
+ (NSString *)CheckNULLString:(NSString*)input;

#pragma mark - Crypto
+ (NSString *)getSHA1:(NSString*)input;
+ (NSString *)getSHA1WithData:(NSData*)data;
+ (NSData *)encryptAESString:(NSString*)plaintext withKey:(NSString*)key;
+ (NSString *)decryptAESData:(NSData*)ciphertext withKey:(NSString*)key;

#pragma mark check special character
+ (BOOL)returnSpecialType:(NSString *)stringCheck;
+ (BOOL)checkWhiteSpace:(NSString *)input;

#pragma mark Base64
+(NSString *)encodeBase64:(NSString *)input;
+(NSString *)decodeBase64:(NSString *)input;
+(NSString *)encodeToBase64Image:(NSData *)image;

+(NSDictionary *)stringToDict:(NSString *)input;

+(NSString *)convertTimestamp:(NSString *)input;
+(NSString *)getDateTimeByFormatDay:(NSString *) startTime;
+ (NSString *)getDateTimeByFormatDay1:(NSString *) startTime;
+(NSString *)getCurrentDate;
+(NSTimeInterval)dateConverter:(NSString *)startDate;
+(NSString *)getCurrentDate1;
+(NSString *)getCurrentDate2;
+(NSString *)getCurrentDate3;
+(NSString *)calculateFromDate:(NSString *)toDate timeAgo:(int)timeAgo;
+(NSString *)getDateTimeByFormatDay2:(NSString *) startTime;

+(int)calculateMinuteFromDate:(NSString *)timeStamp;
+(NSString *)calculateTimeAgo:(NSString *)timeStamp;
@end
