//
//  MessageViewController.m
//  AV
//
//  Created by ZZCN77 on 2017/9/21.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "MessageViewController.h"
#import "GFProgressHUD.h"
#import "KeyMd5.h"
#define KMainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tezhengTextFile;
@property (weak, nonatomic) IBOutlet UILabel *zhuceLable;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
  
}

- (IBAction)productBtn:(id)sender {
    if (_tezhengTextFile.text.length == 0) {
        [GFProgressHUD showMessagewithoutView:@"请输入特征码" afterDelay:2];
        return;
    }
    NSString *str =  [KeyMd5 md5HexDigest:[KeyMd5 md5HexDigest:self.tezhengTextFile.text]];
    NSString *zhuceStr =[str substringWithRange:NSMakeRange(str.length - 6, 6)];
    self.zhuceLable.text = zhuceStr;
    NSLog(@"%@", zhuceStr);
}

@end
