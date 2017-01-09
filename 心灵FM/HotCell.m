//
//  HotCell.m
//  心灵FM
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "HotCell.h"
#import "HomeModel.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@implementation HotCell

-(void)setUIWithArray:(NSArray *)array
{
    NSInteger index = 0;
    for (UIImageView* imgView in self.imageArr) {

        fmModel* model = array[imgView.tag-100];
        [imgView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
        
        UILabel* label = (UILabel*)[self.contentView viewWithTag:200 + index];
        label.text = model.title;
        index++;
    }
    
}

-(void)tapImage:(UITapGestureRecognizer*)tap
{
    UIImageView* imgView = (UIImageView*)tap.view;
    NSInteger index = imgView.tag - 100;
    self.tapImageBlock(index);
}

- (void)awakeFromNib {
    // Initialization code
    
    NSInteger index = 0;
    for (UIImageView* imgView in self.imageArr)
    {
        imgView.tag = 100 + index;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imgView addGestureRecognizer:tap];
        imgView.userInteractionEnabled = YES;
        index++;
    }
    
    self.label1.tag = 200;
    self.label2.tag = 201;
    self.label3.tag = 202;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
