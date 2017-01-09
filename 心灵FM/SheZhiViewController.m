//
//  SheZhiViewController.m
//  心灵FM
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SheZhiViewController.h"

#import "SDImageCache.h"

#import "UMSocial.h"

@interface SheZhiViewController ()

@property(nonatomic,weak)IBOutlet UIView* backView;
@property(nonatomic,weak)IBOutlet UIImageView* imageView1;
@property(nonatomic,weak)IBOutlet UIImageView* imageView2;
@property(nonatomic,weak)IBOutlet UIImageView* imageView3;

@property(nonatomic,weak)IBOutlet UILabel* label1;
@property(nonatomic,weak)IBOutlet UILabel* label2;
@property(nonatomic,weak)IBOutlet UILabel* label3;

@property(nonatomic,weak)IBOutlet UIView* qinchuView;
@property(nonatomic,weak)IBOutlet UILabel* qinchuLabel;

@property(nonatomic,weak)IBOutlet UIView* guanyuView;
@property(nonatomic,weak)IBOutlet UILabel* guanyuLabel;



@end

@implementation SheZhiViewController
- (IBAction)btnClick:(id)sender {
    
    self.qinchuLabel.text = @"清除成功";
    [UIView animateWithDuration:2 animations:^{
        self.qinchuView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView.alpha = 1;
    }];
}
- (IBAction)btnClick2:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        self.guanyuView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView.alpha = 1;
    }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.backView.alpha = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:1.5 animations:^{
        self.backView.alpha = 1;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIView animateWithDuration:1.5 animations:^{
        self.backView.alpha = 1;
    }];
    
    self.imageView1.tag = 100;
    self.imageView2.tag = 101;
    self.imageView3.tag = 102;
    self.imageView1.userInteractionEnabled = YES;
    self.imageView2.userInteractionEnabled = YES;
    self.imageView3.userInteractionEnabled = YES;

    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [self.imageView1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [self.imageView2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [self.imageView3 addGestureRecognizer:tap3];
    
    
    self.qinchuView.layer.cornerRadius = 10;
}


-(void)tapImage:(UITapGestureRecognizer*)tap
{
    UIImageView* imageView = (UIImageView*)tap.view;
    NSInteger tag = imageView.tag;
    if (tag == 100) {
        //清理缓存
        [UIView animateWithDuration:1.5 animations:^{
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
            self.qinchuView.alpha = 1;
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] cleanDisk];
            NSInteger cache = arc4random()%12;
            NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/ImageCaches"];
            NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            NSLog(@"%@",[dict objectForKey:NSFileSize]);
        self.qinchuLabel.text = [NSString stringWithFormat:@"有缓存%ldM,确定清除?",cache];
        }];
    }else if (tag == 101){
        //关于
        [UIView animateWithDuration:1.5 animations:^{
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
            self.guanyuView.alpha = 1;
        }];
        
    }else{
        //分享
        [self share];
    }
}


-(void)share
{
    // 定义要分享到哪些平台
    NSArray *list=@[UMShareToSina,UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatSession];
    
    UIImage *img=[UIImage imageNamed:@"123"];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56a0fb0767e58eb9ae0031a0" shareText:SHARE shareImage:img shareToSnsNames:list delegate:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
