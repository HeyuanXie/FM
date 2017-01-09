//
//  SheQuCell.m
//  心灵FM
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SheQuCell.h"
#import "SheQuModel.h"

#import "UIImageView+WebCache.h"

@interface SheQuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentnumLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,weak)IBOutlet UIImageView* images;

@end

@implementation SheQuCell

-(void)setUIWithModel:(id)model
{
    SheQuModel* shequModel = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:shequModel.user.avatar] placeholderImage:nil];
    self.nicknameLabel.text = shequModel.user.nickname;
    self.commentnumLabel.text = [NSString stringWithFormat:@"评论量:%@",shequModel.commentnum];
    self.updatedLabel.text = shequModel.updated;
    self.titleLabel.text = shequModel.title;
    self.contentTextView.text = shequModel.content;
    
    CGRect rect =  [shequModel.content  boundingRectWithSize:CGSizeMake(self.contentTextView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    
    self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, rect.size.height+10);

    if (shequModel.images) {
        self.images.hidden = NO;
        [self.images setImageWithURL:[NSURL URLWithString:shequModel.images] placeholderImage:nil];
        
        self.images.frame = CGRectMake(10, CGRectGetMaxY(self.contentTextView.frame), 70, 70);
    }else{
        self.images.frame = CGRectMake(10, CGRectGetMaxY(self.contentTextView.frame), 0, 0);
        self.images.hidden = YES;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
