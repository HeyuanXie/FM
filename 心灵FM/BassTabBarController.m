//
//  BassTabBarController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "BassTabBarController.h"
#import "BroadDetailController.h"

@interface BassTabBarController ()
{
    NSMutableArray* _btnArr;//存放自定义tabBar上的button
}
@end

@implementation BassTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnArr = [NSMutableArray array];
    //自定义tabBar
    NSArray* titles = @[@"首页",@"发现",@"社区",@"设置"];
    NSArray* images = @[@"nav_index",@"nav_find",@"nav_forum",@"nav_setting"];
    
    self.tabBar.hidden = YES;
    CGRect frame = self.tabBar.frame;
    _barImageView = [[UIImageView alloc] initWithFrame:frame];
    _barImageView.backgroundColor = [UIColor darkTextColor];
    _barImageView.userInteractionEnabled = YES;
    CGFloat middle_margin = (FM_SIZE.width-20*2-40*4)/3;
    for (int i=0; i<4; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20+i*(40+middle_margin), 0, 40, 40);
        
        //设置button图片
        UIImage* image = [UIImage imageNamed:images[i]];
        UIImage* selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_act",images[i]]];
        image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        selectedImage = [selectedImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        if (i==0) {
            image = selectedImage;
        }
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        //设置button标题
        [button setTitle:titles[i] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.titleEdgeInsets = UIEdgeInsetsMake(45, -2, 0, 0);
        
        button.tag = 100 + i;
        [button addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_barImageView addSubview:button];
        
        [_btnArr addObject:button];
    }
    [self.view addSubview:_barImageView];
    
    NSInteger index = 0;
    for (UINavigationController* nav in self.viewControllers)
    {
        UIViewController* vc = nav.viewControllers.firstObject;
        
        //设置标题
        if (index == 3 || index == 2)
        {
            if (index == 3) {
                vc.navigationItem.title = @"设置";
            }
            if (index == 2) {
                UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:@[@"精华",@"最新"]];
                segment.frame = CGRectMake(0, 0, 50, 30);
                segment.tintColor = [UIColor orangeColor];
                segment.selectedSegmentIndex = 0;
                vc.navigationItem.titleView = segment;
            }
            
//            //设置右上角动画
//            UIImageView* imageView = [[UIImageView alloc] init];
//            imageView.frame = CGRectMake(0, 0, 20, 20);
//            imageView.image = [UIImage imageNamed:@"y1"];
////            imageView.image = [UIImage animatedImageNamed:@"y" duration:0.7];
//            UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
//            vc.navigationItem.rightBarButtonItem = rightItem;
//            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDongHua)];
//            [imageView addGestureRecognizer:tap];
            
        }
//        else
//        {
//            UIImageView* imageView = [[UIImageView alloc] init];
//            imageView.frame = CGRectMake(0, 0, 20, 20);
//            imageView.image = [UIImage imageNamed:@"y1"];
////            imageView.image = [UIImage animatedImageNamed:@"w" duration:0.7];
//            UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
//            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDongHua)];
//            [imageView addGestureRecognizer:tap];
//            vc.navigationItem.rightBarButtonItem = rightItem;
//        }
        
        //设置导航栏透明
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
        if (index == 0 || index==1) {
            //只有首页的navigationBar没有线
            nav.navigationBar.layer.masksToBounds = YES;
        }
//        vc.tabBarController.tabBar.translucent = NO;
        index++;
    }
}


-(void)tabBarButtonClick:(UIButton*)button
{
    self.selectedIndex = button.tag - 100;

    NSArray* images = @[@"nav_index",@"nav_find",@"nav_forum",@"nav_setting"];
    UIImage* selectedImage;
    for (UIButton* btn in _btnArr)
    {
        if (btn.tag == button.tag)
        {
            selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_act",images[btn.tag-100]]];
        }else{
            selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",images[btn.tag-100]]];
        }
        selectedImage = [selectedImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [btn setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }
}


//-(void)tapDongHua
//{
//    NSLog(@"donghua");
//    BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
////    [self.navigationController pushViewController:broadDetailVC animated:YES];
////    [self presentViewController:broadDetailVC animated:YES completion:nil];
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
