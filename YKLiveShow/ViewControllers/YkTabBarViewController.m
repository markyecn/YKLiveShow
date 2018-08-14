//
//  YkTabBarViewController.m
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import "YkTabBarViewController.h"
#import "HomeViewController.h"
#import "NearViewController.h"
#import "MeViewController.h"

#import "ShowLiveViewController.h"

#import "InkeTabbar.h"

@interface YkTabBarViewController ()

@property (strong,nonatomic) InkeTabbar *myTabbar;

@end

@implementation YkTabBarViewController

-(InkeTabbar *)myTabbar{
    if (!_myTabbar) {
        _myTabbar = [[InkeTabbar alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width,49)];
        @weakify(self)
        //代码块
        _myTabbar.block = ^(NSInteger index) {
            @strongify(self)
            [self handleTabItemClicked:index];
        };
    }
    return  _myTabbar;
}

//点击tab item
-(void)handleTabItemClicked:(NSInteger) index{
    //~~~~~
    if (index == ItemType_Launch) {
        NSLog(@"我要直播啊~~~~");
        //
        ShowLiveViewController *showLiveVc = [[ShowLiveViewController alloc] init];
        [self presentViewController:showLiveVc animated:YES completion:nil];
        return;
    }
    [self setSelectedIndex:(index-ItemType_Live)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildVc];
    //加载自定义tab
    [self.tabBar addSubview:self.myTabbar];
    self.tabBar.backgroundColor = self.myTabbar.backgroundColor;
    //去除tabbar的线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}

//加载自控制器
-(void)addChildVc{
    //主页
    HomeViewController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    //附近
    NearViewController *nearVc = [self.storyboard instantiateViewControllerWithIdentifier:@"NearViewController"];
    
    //发现
    UIViewController *followVc = [[UIViewController alloc] init];
    followVc.view.backgroundColor = [UIColor whiteColor];
    
    //我的
    MeViewController *meVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MeViewController"];
//    meVc.view.backgroundColor = [UIColor whiteColor];
    
    //设置控制器
    self.viewControllers = @[homeVc,nearVc,followVc,meVc];
}

@end
