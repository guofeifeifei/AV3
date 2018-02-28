//
//  GFProgressHUD.h
//  DaGuanYun
//
//  Created by ZZCN77 on 16/10/21.
//  Copyright © 2016年 ZZCN77. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
/******* 屏幕尺寸 *******/
#define KMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define GFMainScreenBounds [UIScreen mainScreen].bounds

#define widthScale KMainScreenWidth / 375.0
#define heightScale KMainScreenHeight / 667.0

/******* 屏幕尺寸 *******/
@interface GFProgressHUD : NSObject
@property (nonatomic,strong) MBProgressHUD  *hud;


+ (instancetype)sharedinstance;
+(void)showMessagewithoutView:(NSString *)msg afterDelay:(NSTimeInterval)time;
+(void)showMessagewithoutView:(NSString *)msg;

//显示
+(void)show:(NSString *)msg inView:(UIView *)view;
+ (void)showChrysanthemumView;
+ (void)hideChrysanthemumView;
@end
