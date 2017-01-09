//
//  BassViewController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "BassViewController.h"
#import "BassTabBarController.h"
#import "BroadDetailController.h"

@interface BassViewController ()
{
    NSMutableArray* _btnArr;
}
@end

@implementation BassViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.image = [UIImage imageNamed:@"y1"];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = rightItem;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDongHua)];
    [imageView addGestureRecognizer:tap];
    
    //根据是否播放判断动画按钮是否可以点击
    BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
    if (!broadDetailVC.isMoving)
    {
        imageView.userInteractionEnabled = NO;
    }else
    {
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage animatedImageNamed:@"y" duration:0.7];
    }
    
}

-(void)tapDongHua
{
    NSLog(@"donghua");
    BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
    [self.navigationController pushViewController:broadDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
