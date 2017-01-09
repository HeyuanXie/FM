//
//  DiscoverHeaderView.m
//  FM
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 CYH. All rights reserved.
//

#import "DiscoverHeaderView.h"
#import "UIImageView+WebCache.h"

@interface DiscoverHeaderView ()<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DiscoverHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.scrollView.delegate = self;
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
    }
}

- (void)autoMove
{
    if (self.scrollView.contentOffset.x>=FM_SIZE.width*self.modelArr.count) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    [UIView animateWithDuration:1 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x+FM_SIZE.width, 0);
    }];
}

- (void)setModelArr:(NSArray *)modelArr
{
    _modelArr = modelArr;
    
    // 移除上一次加载的图片数据
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.scrollView setContentSize:CGSizeMake(0, 0)];
    
    for (int i=0; i<_modelArr.count+1; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        // 点击响应事件
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectScrollImage:)];
        imageView.tag = 100+i;
        [imageView addGestureRecognizer:tap];
        
        
        if (i==_modelArr.count) {
            DiscoverHeaderModel *model = _modelArr[0];
            [imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
            [self.scrollView addSubview:imageView];
        }
        else
        {
            DiscoverHeaderModel *model = _modelArr[i];
            [imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
            [self.scrollView addSubview:imageView];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(FM_SIZE.width*(_modelArr.count+1), self.scrollView.frame.size.height)];
}

- (void)selectScrollImage:(UITapGestureRecognizer *)tap
{
    UIImageView *image = (UIImageView *)tap.view;
    NSInteger index = image.tag-100;
    if (index==_modelArr.count) {
        index=0;
    }
    DiscoverHeaderModel *model = _modelArr[index];
    if (self.ResponseBlock) {
        self.ResponseBlock(model);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = self.scrollView.contentOffset.x/FM_SIZE.width;
    if (page == self.modelArr.count) {
        page = 0;
    }
    if (self.scrollView.contentOffset.x>FM_SIZE.width*self.modelArr.count) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (self.scrollView.contentOffset.x<0) {
        [self.scrollView setContentOffset:CGPointMake(FM_SIZE.width*self.modelArr.count, 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
    [self performSelector:@selector(restartTimer) withObject:self afterDelay:5];
}

- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)restartTimer
{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
    }
}


@end
