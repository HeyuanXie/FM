//
//  ZuiXinCell.h
//  心灵FM
//
//  Created by qianfeng on 16/2/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZuiXinCell : UITableViewCell

-(void)setUIWithModel:(id)model;

//发现主播页面的cell的赋值
-(void)setUIWithModelInZhuBoListTable:(id)model;
@end
