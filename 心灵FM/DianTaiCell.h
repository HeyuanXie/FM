//
//  DianTaiCell.h
//  心灵FM
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DianTaiCell : UITableViewCell

@property(nonatomic,strong)IBOutletCollection(UIImageView)NSArray* imgArr;
@property(nonatomic,strong)IBOutletCollection(UILabel)NSArray* labelArr;


-(void)setUIWithArray:(NSArray*)array;

@property(nonatomic,copy)void(^tapImageBlock)(NSInteger index);

@end
