//
//  BroadListCell.h
//  心灵FM
//
//  Created by qianfeng on 16/2/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BroadListCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView* imgView;
@property(nonatomic,weak)IBOutlet UILabel* title;
@property(nonatomic,weak)IBOutlet UILabel* speaker;
@property(nonatomic,weak)IBOutlet UILabel* viewnum;


//更新cell上的数据
-(void)setUIWithModel:(id)model;

//设置cell的高度
+(CGFloat)setCellHeight;
@end
