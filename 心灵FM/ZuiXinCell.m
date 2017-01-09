//
//  ZuiXinCell.m
//  心灵FM
//
//  Created by qianfeng on 16/2/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "ZuiXinCell.h"
#import "HomeModel.h"

#import "UIImageView+WebCache.h"

@interface ZuiXinCell ()

@property(nonatomic,weak)IBOutlet UIImageView* imgView;
@property(nonatomic,weak)IBOutlet UILabel* label1;
@property(nonatomic,weak)IBOutlet UILabel* label2;

@end

@implementation ZuiXinCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUIWithModel:(id)model
{
    fmModel* fmModel = model;
    [self.imgView setImageWithURL:[NSURL URLWithString:fmModel.cover] placeholderImage:nil];
    self.label1.text = fmModel.title;
    self.label2.text = fmModel.speak;
}

-(void)setUIWithModelInZhuBoListTable:(id)model
{
    diantaiModel* dianTaiModel = model;
    [self.imgView setImageWithURL:[NSURL URLWithString:dianTaiModel.cover] placeholderImage:nil];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = self.imgView.frame.size.width/2.0f;
    self.label1.text = dianTaiModel.title;
    self.label2.text = dianTaiModel.content;
}
@end


