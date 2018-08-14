//
//  InkeTabbar.h
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ItemType) {
    ItemType_Live = 100,
    ItemType_Near,
    ItemType_Following,
    ItemType_Me,
    ItemType_Launch
};

typedef void(^InkeTabBlock)(NSInteger index);

@interface InkeTabbar : UIView

@property (copy,nonatomic) InkeTabBlock block;

@end
