//
//  MeViewController.m
//  YKLiveShow
//
//  Created by markye on 2018/6/7.
//  Copyright © 2018年 markye. All rights reserved.
//

#import "MeViewController.h"
#import "LivePlayerViewController.h"

@interface MeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;


@property (weak, nonatomic) IBOutlet UITextField *locationField;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _inputField.text = @"";
    
}

- (IBAction)sureClicked:(id)sender {
    
    [_inputField resignFirstResponder];
    
    NSString *url = _inputField.text;
    LivePlayerViewController *playerVc = [LivePlayerViewController new];
    playerVc.steamUrl = url;
    [self presentViewController:playerVc animated:YES completion:nil];
}

- (IBAction)setClicked:(id)sender {
    [_locationField resignFirstResponder];
    NSString *location = _locationField.text;
    
    NSString *url = [NSString stringWithFormat:API_SearchLatlong,[location stringByURLEncode]];
    @weakify(self)
    [HttpTool getWithPath:url params:nil success:^(id json) {
        @strongify(self)
        NSLog(@"%@",json);
        NSString *status = json[@"status"];
        //判断状态
        if ([status isEqualToString:@"OK"] ) {
            
            NSString *latitude = json[@"result"][@"location"][@"lat"];
            NSString *longitude = json[@"result"][@"location"][@"lng"];
            //存储
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:latitude forKey:latitudeKey];
            [userDefault setObject:longitude forKey:longitudeKey];
            [userDefault synchronize];
            
            NSString *msg = [NSString stringWithFormat:@"地址：%@ \n经纬度：%@，%@ \n保存成功",location,latitude,longitude];
            //发送位置变更通知
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdatedNotification object:nil];
            //弹窗提示
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:action];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
