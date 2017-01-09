//
//  DTDetailHeaderView.h
//  心灵FM
//
//  Created by qianfeng on 16/2/24.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDetailHeaderView : UIView

@property(nonatomic,weak)IBOutlet UIImageView* backImage;
@property(nonatomic,weak)IBOutlet UIImageView* iconImage;
@property(nonatomic,weak)IBOutlet UILabel* speakLabel;
@property(nonatomic,weak)IBOutlet UILabel* numLabel;
@property(nonatomic,weak)IBOutlet UIButton* guanzhuButton;
@property(nonatomic,weak)IBOutlet UILabel* contentLabel;

@end
