//
//  HomeLiveCell.m
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import "HomeLiveCell.h"

@implementation HomeLiveCell

-(void)setLive:(Live *)live{
    _live = live;
    [self.headImageView downloadImage:live.creator.portrait placeholder:@"default_room"];
    self.nameLabel.text = live.creator.nick;
    
    if (live.city && ![live.city isEqualToString:@""]) {
        self.locationLabel.text = live.city;
    }else{
        self.locationLabel.text = @"未知";
    }
    [self.liveImageView downloadImage:live.creator.portrait placeholder: @"default_room"];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld在线",live.online_users];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.cornerRadius = 45/2;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
