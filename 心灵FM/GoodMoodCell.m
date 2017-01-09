//
//  GoodMoodCell.m
//  FM
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 CYH. All rights reserved.
//

#import "GoodMoodCell.h"

@interface GoodMoodCell ()

@property (nonatomic, weak) IBOutlet UIView *fanzao;
@property (nonatomic, weak) IBOutlet UIView *beishang;
@property (nonatomic, weak) IBOutlet UIView *gudu;
@property (nonatomic, weak) IBOutlet UIView *yiqiliao;
@property (nonatomic, weak) IBOutlet UIView *jianya;
@property (nonatomic, weak) IBOutlet UIView *wunai;
@property (nonatomic, weak) IBOutlet UIView *kuaile;
@property (nonatomic, weak) IBOutlet UIView *gandong;
@property (nonatomic, weak) IBOutlet UIView *mimang;

@end

@implementation GoodMoodCell

- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click2:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click3:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click4:)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click5:)];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click6:)];
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click7:)];
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click8:)];
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Click9:)];
    
    [self.fanzao addGestureRecognizer:tap1];
    [self.beishang addGestureRecognizer:tap2];
    [self.gudu addGestureRecognizer:tap3];
    [self.yiqiliao addGestureRecognizer:tap4];
    [self.jianya addGestureRecognizer:tap5];
    [self.wunai addGestureRecognizer:tap6];
    [self.kuaile addGestureRecognizer:tap7];
    [self.gandong addGestureRecognizer:tap8];
    [self.mimang addGestureRecognizer:tap9];
}

- (void)Click1:(UITapGestureRecognizer *)tap
{
    // fanzao
    if (self.ResponseBlock) {
        self.ResponseBlock(@"烦躁");
    }
}
- (void)Click2:(UITapGestureRecognizer *)tap
{
    // beishang
    if (self.ResponseBlock) {
        self.ResponseBlock(@"悲伤");
    }
}
- (void)Click3:(UITapGestureRecognizer *)tap
{
    // gudu
    if (self.ResponseBlock) {
        self.ResponseBlock(@"孤独");
    }
}
- (void)Click4:(UITapGestureRecognizer *)tap
{
    // yiqiliao
    if (self.ResponseBlock) {
        self.ResponseBlock(@"已弃疗");
    }
}
- (void)Click5:(UITapGestureRecognizer *)tap
{
    // jianya
    if (self.ResponseBlock) {
        self.ResponseBlock(@"减压");
    }
}
- (void)Click6:(UITapGestureRecognizer *)tap
{
    // wunai
    if (self.ResponseBlock) {
        self.ResponseBlock(@"无奈");
    }
}
- (void)Click7:(UITapGestureRecognizer *)tap
{
    // kuaile
    if (self.ResponseBlock) {
        self.ResponseBlock(@"快乐");
    }
}
- (void)Click8:(UITapGestureRecognizer *)tap
{
    // gandong
    if (self.ResponseBlock) {
        self.ResponseBlock(@"感动");
    }
}
- (void)Click9:(UITapGestureRecognizer *)tap
{
    // mimang
    if (self.ResponseBlock) {
        self.ResponseBlock(@"迷茫");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
