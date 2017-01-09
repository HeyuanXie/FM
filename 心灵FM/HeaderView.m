//
//  HeaderView.m
//  心灵FM
//
//  Created by qianfeng on 16/2/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "HeaderView.h"

#import "HomeModel.h"

#import "UIImageView+WebCache.h"//加载imageView的网络图片
#import "UIButton+WebCache.h"   //加载button的网络图片

@interface HeaderView ()

@property(nonatomic,strong)UIScrollView* scrollView;//headerView上面的scrollView

@end

@implementation HeaderView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, 180)];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_scrollView];
        
        
        //category图片按钮
        CGFloat l_r_margin = 25;
        CGFloat btn_w = 113*0.5;
        CGFloat middle_margin = (FM_SIZE.width - btn_w*4 - l_r_margin*2)/3;
        CGFloat btn_h = btn_w+20;
        
        for (int i=0; i<8; i++)
        {
            UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            NSInteger row = i/4;
            NSInteger line = i%4;
            
            button.frame = CGRectMake(l_r_margin+(btn_w+middle_margin)*line, CGRectGetMaxY(_scrollView.frame)+(btn_h+10)*row+10, btn_w, btn_h);
            button.tag = 100 + i;
            [self addSubview:button];
            
          
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(75, -113, 0, 0);
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            button.titleLabel.font = [UIFont systemFontOfSize:(14)];
            
            
            [button addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIView* weibu = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-10, FM_SIZE.width, 10)];
        weibu.backgroundColor = [UIColor lightGrayColor];
        weibu.alpha = 0.5;
        [self addSubview:weibu];
        
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}



-(void)loadTuiJianWithArray:(NSArray*)array
{
    
    
    NSInteger index = 0;
    for (tuijianModel* model in array) {
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index*FM_SIZE.width, 0, FM_SIZE.width, self.scrollView.frame.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
        [_scrollView addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = 200 + index;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tap];
        
        index++;
    }
    
    self.scrollView.contentSize = CGSizeMake(array.count*FM_SIZE.width, 0);
}


-(void)loadCategoryWithArray:(NSArray *)array{
    
    NSInteger index = 0;
    
    for (categoryModel* model in array) {
        
        if (index<8) {
            
            UIButton* button = (UIButton* )[self viewWithTag:100+index];
            [button setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
            [self reSizeImage:button.imageView.image toSize:CGSizeMake(113/2, 113/2)];
            
            [button setTitle:model.name forState:(UIControlStateNormal)];
            
            index++;
        }
    }
    UIButton* button = (UIButton*)[self viewWithTag:101];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame)-10, CGRectGetWidth(button.frame), 20)];
    [self addSubview:label];
    label.text = @"情绪管理";
    label.font = [UIFont systemFontOfSize:14];
}

//点击Category按钮响应事件
-(void)selectCategory:(UIButton* )button
{
    //点击button，将按钮的ID通过block传到 首页的视图控制器
    NSInteger index = button.tag - 100;
    self.selectCategoryBlock(index);
}

//点击tuijian图片响应事件
-(void)tapImage:(UITapGestureRecognizer*)tap
{
    //点击图片，将图片的value通过block传到 首页的视图控制器
    UIImageView* imageView = (UIImageView*)tap.view;
    NSInteger index = imageView.tag - 200;
    self.selectTuiJianBlock(index);
}


//自定义修改图片的size
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
@end
