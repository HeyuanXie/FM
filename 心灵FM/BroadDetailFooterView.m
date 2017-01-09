//
//  BroadDetailFooterView.m
//  心灵FM
//
//  Created by qianfeng on 16/2/26.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BroadDetailFooterView.h"

#import "BroadDetailModel.h"
#import "HomeModel.h"


#import "UIImageView+WebCache.h"


@implementation BroadDetailFooterView

- (IBAction)changeProgress:(id)sender {
    UISlider* slider = (UISlider*)sender;
    [self.delegate setProgress:slider];
}

- (IBAction)playPrev:(id)sender {
    [self.delegate playPrev];
}
- (IBAction)doPlay:(id)sender {
    [self.delegate doPlay];
}
- (IBAction)playNext:(id)sender {
    [self.delegate playNext];
}


-(void)setUIWithModel:(id)model
{
    BroadDetailModel* broadDetailModel = model;
    NSArray* images = @[@"notice_player_prev_icon",@"notice_player_pause_icon",@"notice_player_next_icon"];
        NSInteger index = 0;
    for (UIButton* button in self.btnArr) {
        UIImage* image = [UIImage imageNamed:images[index]];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.layer.cornerRadius = button.frame.size.width/2;
        index++;
    }
    
    diantaiModel* dianTaiModle = broadDetailModel.diantai;
    [self.imageView setImageWithURL:[NSURL URLWithString:dianTaiModle.cover] placeholderImage:nil];
    self.nameLabel.text = dianTaiModle.title;
    self.desLabel.text = dianTaiModle.content;
    
    //progress、slider

}

@end
