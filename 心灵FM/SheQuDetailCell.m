//
//  SheQuDetailCell.m
//  心灵FM
//
//  Created by qianfeng on 16/2/29.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SheQuDetailCell.h"

#import "SheQuModel.h"

#import "UIImageView+WebCache.h"

@interface SheQuDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;

@end

@implementation SheQuDetailCell

-(void)setUIWithModel:(id)model
{
    SheQuModel* sheQuModel = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:sheQuModel.user.avatar] placeholderImage:nil];
    self.nicknameLabel.text = [NSString stringWithFormat:@"%ld楼 %@",sheQuModel.theFloor,sheQuModel.user.nickname];
    self.createdLabel.text = sheQuModel.created;
    self.contentTextView.text = sheQuModel.content;
    self.createdLabel.lineBreakMode = NSLineBreakByClipping;
    
    CGRect rect =  [sheQuModel.content  boundingRectWithSize:CGSizeMake(self.contentTextView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
//    self.contentTextView.contentInset = UIEdgeInsetsMake(8, -8, 0, 0);
    self.contentTextView.frame = CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, rect.size.height+10);
    
    self.createdLabel.frame = CGRectMake(40, self.contentTextView.frame.origin.y+rect.size.height-10,self.createdLabel.frame.size.width, self.createdLabel.frame.size.width);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
