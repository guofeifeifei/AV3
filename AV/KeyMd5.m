//
//  KeyMd5.m
//  1454RedEnvelope
//
//  Created by ZZCN77 on 2016/12/17.
//  Copyright © 2016年 ZZCN77. All rights reserved.
//

#import "KeyMd5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation KeyMd5
+(NSString *)md5HexDigest:(NSString *)input{
    const char *cStr = [input UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
         unsigned int x=(int)strlen(cStr) ;
        CC_MD5( cStr, x, digest );
         // This is the md5 call
         NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
         for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                 [output appendFormat:@"%02x", digest[i]];
    
         return  output;
    
}
@end
