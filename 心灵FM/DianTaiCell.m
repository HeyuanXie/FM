//
//  DianTaiCell.m
//  心灵FM
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "DianTaiCell.h"
#import "HomeModel.h"

#import "UIImageView+WebCache.h"

@implementation DianTaiCell

- (void)awakeFromNib {
    // Initialization code
    NSInteger index = 0;
    for (UIImageView* imgView in self.imgArr) {
        
        imgView.userInteractionEnabled = YES;
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = imgView.frame.size.width/2.0f;
        imgView.layer.borderWidth = 2.0;
        imgView.layer.borderColor = [UIColor greenColor].CGColor;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imgView addGestureRecognizer:tap];
        imgView.tag = 100 + index;
        
        index++;
    }
    
    NSInteger index1 = 0;
    for (UILabel* label  in self.labelArr) {
        
        label.tag = 200 + index1;
        index1++;
    }
}


-(void)tapImage:(UITapGestureRecognizer*)tap
{
    UIImageView* imgView = (UIImageView*)tap.view;
    NSLog(@"%ld,跳转到主播个人简介页面",imgView.tag);
    NSInteger index = imgView.tag - 100;
    self.tapImageBlock(index);
}


-(void)setUIWithArray:(NSArray *)array
{
//    NSInteger index = 0;
    for (UIImageView* imgView in self.imgArr) {
        
        diantaiModel* model = array[imgView.tag-100];
        [imgView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    }
    
    for (UILabel* label  in self.labelArr) {
        
        diantaiModel* model = array[label.tag - 200];
        label.text = model.title;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
