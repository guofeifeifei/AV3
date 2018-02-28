//
//  ViewController.m
//  AV
//
//  Created by ZZCN77 on 2017/9/20.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "ViewController.h"
#import <Hyphenate/Hyphenate.h>
#import <Hyphenate/EMClient.h>
#import <Hyphenate/EMCallRemoteView.h>
#import <AVFoundation/AVFoundation.h>
#import <Hyphenate/EMCallSession.h>
@interface ViewController ()<EMCallManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册
 [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] loginWithUsername:@"123"
                                      password:@"123"
                                    completion:^(NSString *aUsername, EMError *aError) {
                                        if (!aError) {
                                            NSLog(@"登录成功");
                                            EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
                                            //当对方不在线时，是否给对方发送离线消息和推送，并等待对方回应
                                            options.isSendPushIfOffline = NO;
                                            [[EMClient sharedClient].callManager setCallOptions:options];
                                            

                                        } else {
                                            NSLog(@"登录失败");
                                        }
                                    }];
  

}

- (IBAction)AV:(id)sender {
    [[EMClient sharedClient].callManager startCall:EMCallTypeVideo remoteName:@"456" ext:nil completion:^(EMCallSession *aCallSession, EMError *aError) {
        EMError *error = nil;
        
        if (!aError) {//创建成功
        }else{
        }
    }];
}
//用户A拨打用户B用户B会收到这个回调、你希望在哪个页面可以监听被呼叫就把这个方法写在里面，记得遵守协议；
- (void)callDidReceive:(EMCallSession *)aSession{
    [[EMClient sharedClient].callManager answerIncomingCall:@"123"];

}
//通话通道完成，可以在这里创建音频输出设备和环境AVAudioSession

- (void)callDidConnect:(EMCallSession *)aSession{
    
}
//用户B同意用户A的通话请求后，用户A会收到这个回调
- (void)callDidAccept:(EMCallSession *)aSession{
    
}
////用户A或用户B挂断后对方会收到这个回调。或者通话出现错误、双方都会收到该回调
- (void)callDidEnd:(EMCallSession *)aSession reason:(EMCallEndReason)aReason error:(EMError *)aError{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
