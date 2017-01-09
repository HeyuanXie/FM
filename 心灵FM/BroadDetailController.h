//
//  BroadDetailController.h
//  心灵FM
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "BassViewController.h"

@interface BroadDetailController : BassViewController

//是否播放（无论暂停还是播放）,用于判断右上角是否动画
@property(nonatomic,assign)BOOL isMoving;

//播放状态
@property(nonatomic,assign)BOOL isPlaying;

@property(nonatomic,copy)NSString* object_id;

@property(nonatomic,strong)NSArray* playList;//播放列表用于切歌
@property(nonatomic,assign)NSInteger currentIndex;

+(BroadDetailController*)shareBroadDetailController;

@end
