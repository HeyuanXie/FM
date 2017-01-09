//
//  SceneCell.m
//  FM
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 CYH. All rights reserved.
//

#import "SceneCell.h"

@interface SceneCell ()

@property (nonatomic, weak) IBOutlet UIView *shuiqian;
@property (nonatomic, weak) IBOutlet UIView *lvxing;
@property (nonatomic, weak) IBOutlet UIView *sanbu;
@property (nonatomic, weak) IBOutlet UIView *zuoche;
@property (nonatomic, weak) IBOutlet UIView *duchu;
@property (nonatomic, weak) IBOutlet UIView *shilian;
@property (nonatomic, weak) IBOutlet UIView *shimian;
@property (nonatomic, weak) IBOutlet UIView *suibian;
@property (nonatomic, weak) IBOutlet UIView *wuliao;

@end

@implementation SceneCell

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
    
    [self.shuiqian addGestureRecognizer:tap1];
    [self.lvxing addGestureRecognizer:tap2];
    [self.sanbu addGestureRecognizer:tap3];
    [self.zuoche addGestureRecognizer:tap4];
    [self.duchu addGestureRecognizer:tap5];
    [self.shilian addGestureRecognizer:tap6];
    [self.shimian addGestureRecognizer:tap7];
    [self.suibian addGestureRecognizer:tap8];
    [self.wuliao addGestureRecognizer:tap9];
}

- (void)Click1:(UITapGestureRecognizer *)tap
{
    // shuiqian
    if (self.ResponseBlock) {
        self.ResponseBlock(@"睡前");
    }
}
- (void)Click2:(UITapGestureRecognizer *)tap
{
    // lvxing
    if (self.ResponseBlock) {
        self.ResponseBlock(@"旅行");
    }
}
- (void)Click3:(UITapGestureRecognizer *)tap
{
    // sanbu
    if (self.ResponseBlock) {
        self.ResponseBlock(@"散步");
    }
}
- (void)Click4:(UITapGestureRecognizer *)tap
{
    // zuoche
    if (self.ResponseBlock) {
        self.ResponseBlock(@"坐车");
    }
}
- (void)Click5:(UITapGestureRecognizer *)tap
{
    // duchu
    if (self.ResponseBlock) {
        self.ResponseBlock(@"独处");
    }
}
- (void)Click6:(UITapGestureRecognizer *)tap
{
    // shilian
    if (self.ResponseBlock) {
        self.ResponseBlock(@"失恋");
    }
}
- (void)Click7:(UITapGestureRecognizer *)tap
{
    // shimian
    if (self.ResponseBlock) {
        self.ResponseBlock(@"失眠");
    }
}
- (void)Click8:(UITapGestureRecognizer *)tap
{
    // suibian
    if (self.ResponseBlock) {
        self.ResponseBlock(@"随便");
    }
}
- (void)Click9:(UITapGestureRecognizer *)tap
{
    // wuliao
    if (self.ResponseBlock) {
        self.ResponseBlock(@"无聊");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
