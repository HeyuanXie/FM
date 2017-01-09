//
//  SectionFooterView.m
//  心灵FM
//
//  Created by qianfeng on 16/2/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "SectionFooterView.h"
#import "BroadListViewController.h"

@implementation SectionFooterView

-(id)initWithFrame:(CGRect)frame andSection:(NSInteger)section
{
    if (self = [super initWithFrame:frame]) {
        
        if (section == 1) {
            self.partUrl = @"http://yiapi.xinli001.com/fm/newlesson-list.json?key=046b6a2a43dc6ff6e770255f57328f89&limit=10";
            self.isBroadListView = YES;
        }else if (section == 2){
            self.partUrl = @"http://yiapi.xinli001.com/fm/newfm-list.json?key=046b6a2a43dc6ff6e770255f57328f89&limit=10";
            self.isBroadListView = YES;
        }else{
            self.isBroadListView = NO;
            //更多电台=======================
            
        }
        
        UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, FM_SIZE.width-20, 1)];
        view1.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view1];
        view1.alpha = 0.5;
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(FM_SIZE.width/2-50, CGRectGetMaxY(view1.frame), frame.size.width, frame.size.height-1-5)];
        label.tag = 100 + section;
        [self addSubview:label];
//        label.backgroundColor = [UIColor greenColor];
//        self.backgroundColor = [UIColor grayColor];
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), FM_SIZE.width, 5)];
        [self addSubview:view];
        view.backgroundColor = [UIColor lightGrayColor];
        view.alpha = 0.5;
        
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFooterView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setLabelInSection:(NSInteger)section
{
    UILabel* label = (UILabel*)[self viewWithTag:100+section];
    NSArray* labelTexts = @[@"更多心理课＞",@"更多FM＞",@"更多电台＞"];
    label.text = labelTexts[section-1];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor redColor];
}



#pragma mark------点击尾部视图，进入更多...
-(void)tapFooterView:(UITapGestureRecognizer*)tap
{
//    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    BroadListViewController* broadListVC = [storyBoard instantiateViewControllerWithIdentifier:@"BroadListViewController"];
    SectionFooterView* footerView = (SectionFooterView*)tap.view;
    self.tapFooterViewBlock(footerView);
}
@end
