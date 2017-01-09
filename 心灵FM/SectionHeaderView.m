//
//  SectionHeaderView.m
//  心灵FM
//
//  Created by qianfeng on 16/2/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

-(id)initWithFrame:(CGRect)frame andSection:(NSInteger)section
{
    if (self = [super initWithFrame:frame]) {

        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        imageView.image = [UIImage imageNamed:@"music-round.png"];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, frame.size.width-30, frame.size.height)];
        label.tag = 100 + section;
        label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:imageView];
        [self addSubview:label];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setLabelInSection:(NSInteger)section
{
    NSArray* labelTexts = @[@"热门推荐",@"最新心理课",@"最新FM",@"心理电台推荐"];
    UILabel* label = (UILabel*)[self viewWithTag:100 + section];
    label.text = labelTexts[section];
}

@end
