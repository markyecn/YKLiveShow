//
//  Live.h
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Creator.h"

@interface Live : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) NSInteger online_users;
@property (nonatomic, strong) NSString *stream_addr;
@property (nonatomic, strong) NSString *distance;

@property (nonatomic, assign) BOOL animationed;

@property (nonatomic, strong) Creator  *creator;

-(void)test;

@end
