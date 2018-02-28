//
//  ClientViewController.m
//  AV
//
//  Created by ZZCN77 on 2017/9/21.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "ClientViewController.h"
#import "GFProgressHUD.h"
#import <Hyphenate/EMClient.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BDSSpeechSynthesizer.h"
@interface ClientViewController ()<EMClientDelegate, EMChatManagerDelegate, BDSSpeechSynthesizerDelegate>


@end

@implementation ClientViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
       [[EMClient sharedClient].chatManager removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TTS version info: %@", [BDSSpeechSynthesizer version]);
    [BDSSpeechSynthesizer setLogLevel:BDS_PUBLIC_LOG_VERBOSE];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:self];

    [self configureOnlineTTS];
    //离线
    [self configureOfflineTTS];

    self.view.backgroundColor = [UIColor blackColor];
    //是否注册
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    if ([user objectForKey:@"username"] == nil) {
        EMError *error = [[EMClient sharedClient] registerWithUsername:self.acountStr password:self.acountStr];
        if (error == nil) {
            NSLog(@"注册成功");
            [user setValue:self.acountStr forKey:@"username"];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"注册失败成功， 请重新登录" afterDelay:2];
                
            });
        }
    }
    //登录
    EMError *error = [[EMClient sharedClient] loginWithUsername:[user objectForKey:@"username"] password:[user objectForKey:@"username"]];
    if (!error) {
        NSLog(@"登录成功");
        NSLog(@"%@",self.acountStr );

        //注册消息回调
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [GFProgressHUD showMessagewithoutView:@"登录成功" afterDelay:2];
            
        });
        //自动登录
       // [[EMClient sharedClient].options setIsAutoLogin:YES];
    }
    else {
       
        if (error.code != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"登录失败" afterDelay:2];
                
            });
            NSLog(@"登录失败，请重新登录:%@", error.errorDescription);
        }
        NSLog(@"登录失败，请重新登录:%@", error.errorDescription);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
            //播放震动完事调用的块
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

        });
    }
}
// 配置在线
-(void)configureOnlineTTS{
    //#error "Set api key and secret key"
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:@"4qU1Z3PPqAak3wSnLEy6GfcY" withSecretKey:@"249133f83c14ec6e49e4e6d4decb50de"];
    
    // 合成参数设置
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:BDS_SYNTHESIZER_SPEAKER_FEMALE]
                                                  forKey:BDS_SYNTHESIZER_PARAM_SPEAKER ];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:5]
                                                  forKey:BDS_SYNTHESIZER_PARAM_VOLUME];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:7]
                                                  forKey:BDS_SYNTHESIZER_PARAM_SPEED];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:5]
                                                  forKey:BDS_SYNTHESIZER_PARAM_PITCH];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt: BDS_SYNTHESIZER_AUDIO_ENCODE_MP3_16K]
                                                  forKey:BDS_SYNTHESIZER_PARAM_AUDIO_ENCODING ];
    
    
}
// 配置离线
-(void)configureOfflineTTS{
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:@"4qU1Z3PPqAak3wSnLEy6GfcY" withSecretKey:@"249133f83c14ec6e49e4e6d4decb50de"];
    NSString* offlineEngineSpeechData = [[NSBundle mainBundle] pathForResource:@"Chinese_Speech_Female" ofType:@"dat"];
    NSString* offlineEngineTextData = [[NSBundle mainBundle] pathForResource:@"Chinese_Text" ofType:@"dat"];
    NSString* offlineEngineEnglishSpeechData = [[NSBundle mainBundle] pathForResource:@"English_Speech_Female" ofType:@"dat"];
    NSString* offlineEngineEnglishTextData = [[NSBundle mainBundle] pathForResource:@"English_Text" ofType:@"dat"];
    NSString* offlineEngineLicenseFile = [[NSBundle mainBundle] pathForResource:@"offline_engine_tmp_license" ofType:@"dat"];
    //#error "set offline engine license"
    NSError* err = [[BDSSpeechSynthesizer sharedInstance] loadOfflineEngine:offlineEngineTextData speechDataPath:offlineEngineSpeechData licenseFilePath:offlineEngineLicenseFile withAppCode:@"10185721"]; //
    if (err) {
        NSLog(@"运行出错%@", err);
        return;
    }
    err = [[BDSSpeechSynthesizer sharedInstance] loadEnglishDataForOfflineEngine:offlineEngineEnglishTextData speechData:offlineEngineEnglishSpeechData];
    if (err) {
        NSLog(@"运行出错%@", err);
        return;
    }
    
    // 合成参数设置
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:BDS_SYNTHESIZER_SPEAKER_FEMALE]
                                                        forKey:BDS_SYNTHESIZER_PARAM_SPEAKER ];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:5]
                                                        forKey:BDS_SYNTHESIZER_PARAM_VOLUME];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:7]
                                                        forKey:BDS_SYNTHESIZER_PARAM_SPEED];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:5]
                                                        forKey:BDS_SYNTHESIZER_PARAM_PITCH];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt: BDS_SYNTHESIZER_AUDIO_ENCODE_MP3_16K]
                                                        forKey:BDS_SYNTHESIZER_PARAM_AUDIO_ENCODING ];
    [self speakSentence:@""];
}
- (void)speakSentence:(NSString *)message
{
    if ([message isEqualToString:@"cmd_1"]||
             [message isEqualToString:@"cmd_2"]||
             [message isEqualToString:@"cmd_3"]||
             [message isEqualToString:@"cmd_4"]||
             [message isEqualToString:@"cmd_5"]||
             [message isEqualToString:@"cmd_6"] ||
             [message isEqualToString:@"cmd_7"]||
             [message isEqualToString:@"cmd_8"]||
             [message isEqualToString:@"cmd_9"]){
        //震动
        [self playSystemSound:[message intValue]];
        return;

    }else{

      [[BDSSpeechSynthesizer sharedInstance] speakSentence:message withError:nil];
    }
}

// 播放失败
- (void)synthesizerErrorOccurred:(NSError *)error
                        speaking:(NSInteger)SpeakSentence
                    synthesizing:(NSInteger)SynthesizeSentence{
    
    [[BDSSpeechSynthesizer sharedInstance] cancel];
}

- (void)synthesizerStartWorkingSentence:(NSInteger)SynthesizeSentence
{
    NSLog(@"Began synthesizing sentence %ld", (long)SynthesizeSentence);
}

- (void)synthesizerFinishWorkingSentence:(NSInteger)SynthesizeSentence
{
    NSLog(@"Finished synthesizing sentence %ld", (long)SynthesizeSentence);
}

- (void)synthesizerSpeechStartSentence:(NSInteger)SpeakSentence
{
    NSLog(@"Began playing sentence %ld", (long)SpeakSentence);
}

- (void)synthesizerSpeechEndSentence:(NSInteger)SpeakSentence
{
    NSLog(@"Finished playing sentence %ld", (long)SpeakSentence);
}
- (void)actionAction:(NSString *)message{
    
   SystemSoundID soundID;
    if ([message isEqualToString:@"cd_shang"]) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"shan" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });

        }
        AudioServicesPlaySystemSound(soundID);

        return;
    }else if ([message isEqualToString:@"cd_zhong"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"zhong" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
         return;
        
    }else if ([message isEqualToString:@"cd_xia"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"xia" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
        
    }else if ([message isEqualToString:@"nill_nill"]){
        
    }else if ([message isEqualToString:@"cd_1"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"b" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;

        
    }else if ([message isEqualToString:@"cd_2"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"c" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        
    }else if ([message isEqualToString:@"cd_3"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"d" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
        
    }else if ([message isEqualToString:@"cd_zhong"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"zhong" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;

    }else if ([message isEqualToString:@"cd_4"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"e" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
    }else if ([message isEqualToString:@"cd_5"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"f" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
    }else if ([message isEqualToString:@"cd_6"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"g" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
        
    }else if ([message isEqualToString:@"cd_fa"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"fa" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;

        
    }else if ([message isEqualToString:@"cd_7"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"h" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
    }else if ([message isEqualToString:@"cd_8"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"i" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
    }else if ([message isEqualToString:@"cd_9"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"j" ofType:@"WAV"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
    }else if ([message isEqualToString:@"cd_bai"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"bai" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;

        
    }else if ([message isEqualToString:@"cd_dong"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"dong" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
        

    }else if ([message isEqualToString:@"cd_nan"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"nan" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
        

    }else if ([message isEqualToString:@"cd_xi"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"xi" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
        

        
    }else if ([message isEqualToString:@"cd_bei"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"bei" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;
        

        
    }else if ([message isEqualToString:@"cd_tiao"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"tiao" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;

    }else if ([message isEqualToString:@"cd_tong"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"tong" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;

    }else if ([message isEqualToString:@"cd_wan"]){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"wan" ofType:@"mp3"];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            NSLog(@"静音");
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"🙂失败" afterDelay:2];
                
            });
            
        }
        AudioServicesPlaySystemSound(soundID);
        return;

    }else if ([message isEqualToString:@"1"]||
              [message isEqualToString:@"2"]||
              [message isEqualToString:@"3"]||
              [message isEqualToString:@"4"]||
              [message isEqualToString:@"5"]||
              [message isEqualToString:@"6"] ||
              [message isEqualToString:@"7"]||
               [message isEqualToString:@"8"]||
              [message isEqualToString:@"9"]){
        //震动
        [self playSystemSound:[message intValue]];
        return;
        
    }




}
- (void)playSystemSound:(int)count{
    
    
    /**
     初始化计时器  每一秒振动一次
     
     @param playkSystemSound 振动方法
     @return
     */
    // _vibrationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playkSystemSound:) userInfo:nil repeats:YES];
    //震动几下
    __block int timeout=count; //倒计时时间
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //关闭震动
        if(timeout<=0){ //倒计时结束，关闭
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
            AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
            
            dispatch_source_cancel(_timer);
            
        }else{
            //在这里执行事件
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)messagesDidReceive:(NSArray *)aMessages{
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"收到的文字是 txt -- %@",txt);
                //                [self actionAction:txt];
                
                
                //语音合成
                [self speakSentence:txt];
            }
                break;
            default:
                break;
        }
    }
}

//重连
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState{
    
}
/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice{
    dispatch_async(dispatch_get_main_queue(), ^{
        [GFProgressHUD showMessagewithoutView:@"当前登录账号在其它设备登录" afterDelay:2];
        
    });
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer{
    dispatch_async(dispatch_get_main_queue(), ^{
        [GFProgressHUD showMessagewithoutView:@"当前登录账号已经被从服务器端删除" afterDelay:2];
        
    });
}



@end
