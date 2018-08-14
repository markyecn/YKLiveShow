//
//  HomeLiveCell.h
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Live.h"

@interface HomeLiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

@property (strong, nonatomic) Live *live;

@end
