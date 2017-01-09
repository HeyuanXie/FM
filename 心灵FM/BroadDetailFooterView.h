//
//  BroadDetailFooterView.h
//  心灵FM
//
//  Created by qianfeng on 16/2/26.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//指定协议
@protocol BroadDetailFooterViewDelegate <NSObject>

-(void)doPlay;
-(void)playNext;
-(void)playPrev;
-(void)setProgress:(UISlider*)slider;

@end

@interface BroadDetailFooterView : UIView

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArr;

@property(nonatomic,weak)IBOutlet UIProgressView* progressView;
@property(nonatomic,weak)IBOutlet UISlider* slider;
@property(nonatomic,weak)IBOutlet UIImageView* imageView;
@property(nonatomic,weak)IBOutlet UILabel* nameLabel;
@property(nonatomic,weak)IBOutlet UILabel* desLabel;


//@property(nonatomic,copy)void(^changeProgressBlock)(float value);

-(void)setUIWithModel:(id)model;

@property(nonatomic,strong)id <BroadDetailFooterViewDelegate>delegate;

@end
