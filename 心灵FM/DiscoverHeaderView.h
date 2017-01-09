//
//  DiscoverHeaderView.h
//  FM
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 CYH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverHeaderModel.h"

@interface DiscoverHeaderView : UIView

@property (nonatomic, strong) NSArray *modelArr;

@property (nonatomic, copy) void (^ResponseBlock)(DiscoverHeaderModel *model);

@end
