//
//  BroadListCell.m
//  心灵FM
//
//  Created by qianfeng on 16/2/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "BroadListCell.h"
#import "HomeModel.h"

#import "UIImageView+WebCache.h"

@implementation BroadListCell

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
    self.title.text = fmModel.title;
    
    //设置属性字符串
    NSString* str = [NSString stringWithFormat:@"作者    %@",fmModel.speak];
    NSString* str2 = [NSString stringWithFormat:@"收听量  %@",fmModel.viewnum];
    
    NSMutableAttributedString* attSpeakStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attSpeakStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"作者"]];
    
    NSMutableAttributedString* attViewStr = [[NSMutableAttributedString alloc] initWithString:str2];
    [attViewStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str2 rangeOfString:@"收听量"]];
    
    self.speaker.attributedText = attSpeakStr;
    self.viewnum.attributedText = attViewStr;

}

+(CGFloat)setCellHeight
{
    return 80;
}
@end
