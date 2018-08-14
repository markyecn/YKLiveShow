//
//  ShowLiveViewController.m
//  YKLiveShow
//  //我要直播界面
//  Created by markye on 2018/6/7.
//  Copyright © 2018年 markye. All rights reserved.
//

#import "ShowLiveViewController.h"
#import "LFLivePreview.h"

@interface ShowLiveViewController ()

@end

@implementation ShowLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    LFLivePreview * liveView = [[LFLivePreview alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:liveView];
    [liveView startLive];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
