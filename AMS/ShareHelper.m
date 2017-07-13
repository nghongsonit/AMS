//
//  ShareHelper.m
//  IQC
//
//  Created by SonTayTo on 9/30/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import "ShareHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES)
- (NSData *)AES256DecryptWithKey:(NSString *)key;
- (NSData *)AES256EncryptWithKey:(NSString *)key;
@end

@implementation ShareHelper

#pragma mark - Image

+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageByOverwriteColor:(UIColor *)color alpha:(float)alpha image:(UIImage*)image {
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, screenScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [image drawInRect:CGRectMake(0,0,newSize.width, newSize.height) blendMode:(kCGBlendModeSourceOut) alpha:1];
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(CGPointZero.x, CGPointZero.y, newSize.width, newSize.height));
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size point:(CGPoint)xy
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(xy.x, xy.y, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (UIImage *)imageWithImageHeight:(UIImage *)image height:(float)height
{
    CGSize itemSize = CGSizeMake( image.size.width*height/image.size.height, height);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width*height/image.size.height, height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    //[destImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark - Color

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark UserDefault

+ (void)saveUserDefaults:(NSDictionary *)dictionary {
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *array = dictionary.allKeys ;
    for(NSString *key in array){
        NSString *value = [dictionary objectForKey:key];
        [defaults setObject:value forKey:key];
    }
    
    [defaults synchronize];
}

+ (id)getUserDefaults:(NSString *)key {
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id value = [defaults objectForKey:key];
    return value;
}

+(void)clearUserDefault:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

#pragma mark - Handle string
+ (NSString*)CheckNULLString:(NSString*)input {
    if(![input isEqualToString:@"<null>" ])
        return input;
    else
        return @"";
}

#pragma mark - Crypto

+ (NSString*)getSHA1:(NSString*)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString*)getSHA1WithData:(NSData*)data {
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSData *)encryptAESString:(NSString*)plaintext withKey:(NSString*)key {
    return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
}

+ (NSString *)decryptAESData:(NSData*)ciphertext withKey:(NSString*)key {
    return [[NSString alloc] initWithData:[ciphertext AES256DecryptWithKey:key]
                                 encoding:NSUTF8StringEncoding];
}

#pragma mark CHECK SPECIAL CHARACTERS (add by tantt)

+ (BOOL) returnSpecialType:(NSString *)stringCheck {
    
    NSString *specialCharacterString = @"~^?!*-[/:<>,@#$%|\"]";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    
    if ([stringCheck.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)checkWhiteSpace:(NSString *)input{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [input stringByTrimmingCharactersInSet:charSet];
    if ([trimmedString isEqualToString:@""]) {
        // it's empty or contains only white spaces
        return YES;
    }
    return NO;
}

#pragma mark Base64

+(NSString *)encodeBase64:(NSString *)input{
    NSData *plainData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}

+(NSString *)decodeBase64:(NSString *)input{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:input options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

+ (NSString *)encodeToBase64Image:(NSData *)image {
    return [image base64EncodedStringWithOptions:0];
}

#pragma mark Convert JSSON String to Dict

+(NSDictionary *)stringToDict:(NSString *)input{
    //NSString *temp = StringFormat(@"%@",input);
    NSError *jsonError;
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&jsonError];
    return jsonResponse;
}

+(NSString *)convertTimestamp:(NSString *)input{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [[NSDate alloc] init];
    // voila!
    date = [dateFormatter dateFromString:StringFormat(@"01/01/%@ 01:01",input)];
    NSLog(@"dateFromString = %@", date);
    //date to timestamp
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *output = StringFormat(@"%.f000",timeInterval);
    
    return output;
}

#pragma mark Date Time

+ (NSString *)getDateTimeByFormatDay:(NSString *) startTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *startDay = [NSDate dateWithTimeIntervalSince1970:[startTime integerValue]];
    NSString *startingDate = [dateFormatter stringFromDate:startDay];
    return startingDate;
}

+ (NSString *)getDateTimeByFormatDay1:(NSString *) startTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY_HH:mm_EEEE"];
    //[dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_VN"];
    
    NSDate *startDay = [NSDate dateWithTimeIntervalSince1970:[startTime integerValue]];
    NSString *startingDate = [dateFormatter stringFromDate:startDay];
    return startingDate;
}

+ (NSString *)getDateTimeByFormatDay2:(NSString *) startTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *startDay = [NSDate dateWithTimeIntervalSince1970:[startTime integerValue]];
    NSString *startingDate = [dateFormatter stringFromDate:startDay];
    return startingDate;
}

+ (NSString *)getCurrentDate{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *date = [NSDate date];
    NSString * currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}

+ (NSString *)getCurrentDate1{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *date = [NSDate date];
    NSString * currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}

+ (NSString *)getCurrentDate2{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *date = [NSDate date];
    NSString * currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}

+ (NSString *)getCurrentDate3{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_VN"];
    
    NSDate *date = [NSDate date];
    NSString * currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}

+ (NSTimeInterval)dateConverter:(NSString *)startDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
//    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [[NSDate alloc] init];
    // voila!
    date = [dateFormatter dateFromString:startDate];
    NSLog(@"dateFromString = %@", date);
    
    //date to timestamp
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}

+ (NSTimeInterval)dateConverter1:(NSString *)startDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_VN"];
    
    NSDate *date = [[NSDate alloc] init];
    // voila!
    date = [dateFormatter dateFromString:startDate];
    NSLog(@"dateFromString = %@", date);
    
    //date to timestamp
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}

+(NSString *)calculateFromDate:(NSString *)toDate timeAgo:(int)timeAgo{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *dateFromString = [dateFormatter dateFromString:toDate];
    NSTimeInterval timeInterval = [dateFromString timeIntervalSince1970];
    NSTimeInterval ago = timeAgo*3600*24;
    
    NSTimeInterval fromDateInterval = timeInterval - ago;
    
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:fromDateInterval];
    NSString *resultDate = [dateFormatter stringFromDate:fromDate];
    
    return resultDate;
}

+(int)calculateMinuteFromDate:(NSString *)timeStamp{
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
    NSTimeInterval temp = [now timeIntervalSinceReferenceDate]-[date timeIntervalSinceReferenceDate];
    
    NSString *time;
    int time_int = temp;
    int days = time_int/(3600 * 24);
    int hours = time_int / 3600;
    int minutes = time_int/60;
    
//    if(days == 0){
//        if (hours == 0){
//            if (minutes == 0) {
//                time = StringFormat(@"%d giây trước",time_int);
//            } else {
//                time = StringFormat(@"%d phút trước", minutes);
//            }
//        } else {
//            time = StringFormat(@"%d giờ trước", hours);
//        }
//    } else if (days > 30) {
//        //time =[self getDateTimeByFormatTimeDay:date];
//    } else {
//        time = StringFormat(@"%d ngày trước", days);
//    }
    return minutes;

}

+(NSString *)calculateTimeAgo:(NSString *)timeStamp{
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
    NSTimeInterval temp = [now timeIntervalSinceReferenceDate]-[date timeIntervalSinceReferenceDate];
    
    NSString *time;
    int time_int = temp;
    int days = time_int/(3600 * 24);
    int hours = time_int / 3600;
    int minutes = time_int/60;
    
    if(days == 0){
        if (hours == 0){
            if (minutes == 0) {
                time = StringFormat(@"%d giây trước",time_int);
            } else {
                time = StringFormat(@"%d phút trước", minutes);
            }
        } else {
            time = StringFormat(@"%d giờ trước", hours);
        }
    } else if (days > 30) {
        time =[self getDateTimeByFormatDay:timeStamp];
    } else {
        time = StringFormat(@"%d ngày trước", days);
    }

    
    return time;
}

@end

@implementation NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

#pragma mark Get current Date

+(NSString *)getCurrentDate{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *date = [NSDate date];
    NSString * currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}
@end
