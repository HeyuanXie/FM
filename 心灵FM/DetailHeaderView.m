//
//  DetailHeaderView.m
//  心灵FM
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "DetailHeaderView.h"
#import "SheQuModel.h"

#import "UIImageView+WebCache.h"

@interface DetailHeaderView ()

@property(nonatomic,strong)IBOutlet UIImageView* iconImage;
@property(nonatomic,strong)IBOutlet UILabel* nickName;
@property(nonatomic,strong)IBOutlet UILabel* createdLabel;
@property(nonatomic,strong)IBOutlet UILabel* titleLabel;
@property(nonatomic,strong)IBOutlet UITextView* contentTextView;
@property(nonatomic,weak)IBOutlet UIView* grayView;

@end

@implementation DetailHeaderView

-(void)setHeaderViewWithModel:(id)model
{
    SheQuModel* shequModel = model;
    [_iconImage setImageWithURL:[NSURL URLWithString:shequModel.user.avatar] placeholderImage:nil];
    _nickName.text = shequModel.user.nickname;
    _createdLabel.text = shequModel.created;
    _titleLabel.text = shequModel.title;
    _contentTextView.text = shequModel.content;
    
    CGRect rect =  [shequModel.content  boundingRectWithSize:CGSizeMake(self.contentTextView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];

    self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, rect.size.height+10);
    self.grayView.frame = CGRectMake(0, self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height, FM_SIZE.width, 10);
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.grayView.frame.origin.y+self.grayView.frame.size.height);
}

@end
