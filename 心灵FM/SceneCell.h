//
//  SceneCell.h
//  FM
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 CYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneCell : UITableViewCell

@property (nonatomic, copy) void (^ResponseBlock)(NSString *title);

@end
