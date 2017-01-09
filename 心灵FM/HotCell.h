//
//  HotCell.h
//  心灵FM
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageArr;


@property(nonatomic,weak)IBOutlet UILabel* label1;
@property(nonatomic,weak)IBOutlet UILabel* label2;
@property(nonatomic,weak)IBOutlet UILabel* label3;


-(void)setUIWithArray:(NSArray*)array;

@property(nonatomic,copy)void(^tapImageBlock)(NSInteger index);

@end
