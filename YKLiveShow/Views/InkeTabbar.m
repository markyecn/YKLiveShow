//
//  InkeTabbar.m
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

//自定义tabbar view

#import "InkeTabbar.h"

@interface InkeTabbar()

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) UIButton *lastBtn;

@end

@implementation InkeTabbar

//懒加载
-(NSArray *)items{
    if (!_items) {
        _items = @[@{@"image":@"tab_live",@"title":@"首页"},
                    @{@"image":@"tab_near",@"title":@"同城"},
                    @{@"image":@"tab_following",@"title":@"发现"},
                    @{@"image":@"tab_me",@"title":@"我的"}];
    }
    return _items;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //加背景图片
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        //加tab按钮
        [self addItems];
    }
    return self;
}

-(void)addItems{
    for (NSInteger i = 0 ; i < self.items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //item样式设置
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor: [UIColor colorWithRed:0.25 green:0.9 blue:0.77 alpha:1] forState:UIControlStateSelected];
        [btn setTitle:_items[i][@"title"] forState:UIControlStateNormal];
        [btn setTitle:_items[i][@"title"] forState:UIControlStateSelected];
        
        [btn setImage:[UIImage imageNamed:_items[i][@"image"]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_p",_items[i][@"image"]]] forState:UIControlStateSelected];
        //添加事件
        [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        //去除高亮反应
        btn.adjustsImageWhenHighlighted = NO;
        //设置Tag
        btn.tag = ItemType_Live + i;
        [self addSubview:btn];
        //设置选中
        if (btn.tag == ItemType_Live) {
            btn.selected = YES;
            self.lastBtn = btn;
        }
    }
    //加我要直播按钮
    UIButton *launchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [launchBtn setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
    launchBtn.adjustsImageWhenHighlighted = NO;
    launchBtn.tag = ItemType_Launch;
    [launchBtn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    launchBtn.frame = CGRectMake(0, 0, 70, 70);
    [self addSubview:launchBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width/(self.items.count+1);//中间凸起也算一个
    
    for (NSInteger i = 0 ; i < self.subviews.count; i++) {
        UIView *v = self.subviews[i];
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            if (btn.tag == ItemType_Launch){
                //
                btn.center = CGPointMake(self.bounds.size.width/2, 10);
            }else{
                //
                if (btn.tag >= ItemType_Following) {
                    btn.frame = CGRectMake((btn.tag - ItemType_Live + 1)*width, 0, width, self.bounds.size.height);
                }else{
                    btn.frame = CGRectMake((btn.tag - ItemType_Live)*width, 0, width, self.bounds.size.height);
                }
                //按钮~图片上文字下-设置
                //使图片和文字水平居中显示
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 5.0,0.0)];
                //图片距离右边框距离减少图片的宽度，其它不边
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,15.0, -btn.titleLabel.bounds.size.width)];
            }
        }
    }
}

-(void)itemClicked:(UIButton *)btn{
   
    if (self.block) {
        self.block(btn.tag);
    }
    if (btn.tag == ItemType_Launch) {
        return;
    }
    if (btn.tag != self.lastBtn.tag) {
        btn.selected = YES;
        self.lastBtn.selected = NO;
        self.lastBtn = btn;
    }
    [UIView animateWithDuration:0.3 animations:^{
        btn.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.imageView.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end
