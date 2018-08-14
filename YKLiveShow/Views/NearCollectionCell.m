//
//  NearCollectionCell.m
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import "NearCollectionCell.h"

@implementation NearCollectionCell

- (void)setLive:(Live *)live{
    _live = live;
    [self.headImageView downloadImage:live.creator.portrait placeholder:@"default_room"];
    self.distanceLabel.text = [NSString stringWithFormat:@"距离%@",live.distance];
    if (live.city && ![live.city isEqualToString:@""]) {
        self.locationLabel.text = live.city;
    }else{
        self.locationLabel.text = @"未知";
    }
    if (live.creator.nick) {
        self.nickLabel.text = [NSString stringWithFormat:@" %@ ",live.creator.nick];
    }else{
        self.nickLabel.text = @"";
    }
}

-(void)showAnimation{
    if (self.live.animationed) {
        return;
    }
    self.headImageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.3 animations:^{
        self.headImageView.transform = CGAffineTransformIdentity;
    }];
    self.live.animationed = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.cornerRadius = 8;
    self.headImageView.layer.masksToBounds = YES;
    
    self.nickLabel.layer.cornerRadius = 10;
    self.nickLabel.layer.masksToBounds = YES;
}

@end
