//
//  SectionHeaderView.h
//  心灵FM
//
//  Created by qianfeng on 16/2/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIView

-(id)initWithFrame:(CGRect)frame andSection:(NSInteger)section;

-(void)setLabelInSection:(NSInteger)section;

@end
