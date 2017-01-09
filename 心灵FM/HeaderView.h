//
//  HeaderView.h
//  心灵FM
//
//  Created by qianfeng on 16/2/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

//选择推荐时回调的block
@property(nonatomic,copy)void(^selectTuiJianBlock)(NSInteger index);

//选择category按钮时回调的方法
@property(nonatomic,copy)void(^selectCategoryBlock)(NSInteger index);

//加载TuiJian
-(void)loadTuiJianWithArray:(NSArray*)array;

//加载Category
-(void)loadCategoryWithArray:(NSArray*)array;

@end
