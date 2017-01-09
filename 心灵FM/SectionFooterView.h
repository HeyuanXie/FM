//
//  SectionFooterView.h
//  心灵FM
//
//  Created by qianfeng on 16/2/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionFooterView : UIView
-(id)initWithFrame:(CGRect)frame andSection:(NSInteger)section;

-(void)setLabelInSection:(NSInteger)section;

@property(nonatomic,copy)void(^tapFooterViewBlock)(SectionFooterView* footerView);

@property(nonatomic,copy)NSString* partUrl;

@property(nonatomic,assign)BOOL isBroadListView;

@end
