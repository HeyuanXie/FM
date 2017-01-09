//
//  BroadListViewController.h
//  心灵FM
//
//  Created by qianfeng on 16/2/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "BassViewController.h"

@interface BroadListViewController : BassViewController

//根据跳转,从上一个页面传过来BroadListVC请求数据的 URLStr
@property(nonatomic,copy)NSString* urlStr;
@property(nonatomic,copy)NSString* partUrl;
//接收跳转传过来的title
@property(nonatomic,copy)NSString* navBarTitle;

@property(nonatomic,assign)NSInteger pageMark;

@property(nonatomic,assign)BOOL haveFooter;

@end
