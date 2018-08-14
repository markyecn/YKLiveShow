//
//  LivePlayerViewController.h
//
#import <UIKit/UIKit.h>
#import "Live.h"

//获取直播流播放直播界面
//使用开源框架 https://github.com/Bilibili/ijkplayer/

@interface LivePlayerViewController : UIViewController

@property (nonatomic, strong) Live * live;

@property (nonatomic, strong) NSString * steamUrl;

@end
