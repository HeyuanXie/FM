//
//  BroadDetailController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "UMSocial.h"

#import "BroadDetailController.h"
#import "DianTaiDetailController.h"
#import "BassTabBarController.h"

#import "BroadDetailFooterView.h"

#import "RequestManager.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

#import "BroadDetailModel.h"

@interface BroadDetailController ()<BroadDetailFooterViewDelegate>
{
    UIImageView* _imageView;
    UILabel* _label1;
    UILabel* _label2;
    
    //播放队列
    NSMutableArray* _arrayPlayList;
    //播放器
    AVPlayer* _player;
    //当前播放的url
    NSString* _currentUrl;
    //当前播放的是第几个
    int _currentPlayIndex;

    //用于分享的url
    NSString* _shareUrl;
    
}

@property(nonatomic,strong)BroadDetailModel* model;

@property(nonatomic,strong)BroadDetailFooterView* footerView;
@end

@implementation BroadDetailController


-(void)viewWillAppear:(BOOL)animated
{
    BassTabBarController* tabBarController = (BassTabBarController*)self.tabBarController;
    tabBarController.barImageView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self requestNetData];

    //后台播放
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [_imageView setImage:nil];
    _label1.text = nil;
    _label2.text = nil;
    
    BassTabBarController* tabBarController = (BassTabBarController*)self.tabBarController;
    tabBarController.barImageView.hidden = NO;
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];


}

+(BroadDetailController*)shareBroadDetailController
{
    static BroadDetailController* broadDetailVC = nil;
    if (broadDetailVC == nil) {
        broadDetailVC = [[BroadDetailController alloc] init];
    }
    return broadDetailVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _arrayPlayList = [NSMutableArray array];
    
    
    //创建UI
    [self initUI];
}


-(void)initUI
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, FM_SIZE.height/2)];
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)-20, FM_SIZE.width-80, 20)];
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(FM_SIZE.width-80, CGRectGetMinY(_label1.frame), 80, 20)];
    
    UIView* blackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)-20, FM_SIZE.width, 20)];
    blackView.backgroundColor = [UIColor darkGrayColor];
    blackView.alpha = 0.7;
    
    [self.view addSubview:_imageView];
    [self.view addSubview:blackView];

    [self.view addSubview:_label1];
    [self.view addSubview:_label2];
    
    _label1.font = [UIFont boldSystemFontOfSize:17];
    _label1.textColor = [UIColor whiteColor];
    _label2.font = [UIFont systemFontOfSize:10];
    _label2.textColor = [UIColor whiteColor];
    
    
    _footerView = [[[NSBundle mainBundle] loadNibNamed:@"BroadDetailFooterView" owner:nil options:nil] firstObject];
    _footerView.delegate = self;
    
    
    _footerView.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame), FM_SIZE.width, 200);
    _footerView.imageView.layer.masksToBounds = YES;
    _footerView.imageView.layer.cornerRadius = _footerView.imageView.frame.size.width/2.0f;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    _footerView.imageView.userInteractionEnabled = YES;
    [_footerView.imageView addGestureRecognizer:tap];
    
    
    //设置slider样式,透明
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_footerView.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [_footerView.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
    [_footerView.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:(UIControlStateNormal)];
    
    [self.view addSubview:_footerView];
    
    
    //创建分享按钮
    UIView* shareView = [[UIView alloc] initWithFrame:CGRectMake(0, FM_SIZE.height-40, FM_SIZE.width, 50)];
    shareView.backgroundColor = [UIColor grayColor];
    UIButton* shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, FM_SIZE.width, 50);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:shareView];
    [shareView addSubview:shareBtn];
    shareBtn.center = shareBtn.center;
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)requestNetData
{
    NSString* urlStr = [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/broadcast-detail.json?key=046b6a2a43dc6ff6e770255f57328f89&id=%@",self.object_id];
    [RequestManager getRequestWithUrl:urlStr dict:nil block:^(BOOL isSuccess, id respondObject) {
       
        if (isSuccess) {
            
            BroadDetailModel* model = [[BroadDetailModel alloc] mj_setKeyValues:respondObject[@"data"]];
            _model = model;
            
            _shareUrl = model.absolute_url;
            [self setUIWithModel:model];
            [self playWithUrlStr:model.url];
        }
    }];
}

-(void)setUIWithModel:(BroadDetailModel*)model
{
    [_imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    _label1.text = model.title;
    _label2.text = [NSString stringWithFormat:@"收听量:%@",model.viewnum];
    
    [_footerView setUIWithModel:model];
}

-(void)tapImage
{
    DianTaiDetailController* dianTaiDetailVC = [[DianTaiDetailController alloc] init];
    dianTaiDetailVC.model = self.model.diantai;
    [self.navigationController pushViewController:dianTaiDetailVC animated:YES];
}

#pragma mark -------AVPlayer相关
-(void)playWithUrlStr:(NSString*) url
{
    AVPlayerItem* playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    if (_player.currentItem)
    {
        if (![url isEqualToString:_currentUrl]) {
            [_player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
            [_player replaceCurrentItemWithPlayerItem:playerItem];
            _currentUrl = url;
        }
    }else{
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        _currentUrl = url;
        _currentPlayIndex = 0;
        self.isMoving = YES;
    }
    
    __weak BroadDetailController* weakVC = self;
    __weak AVPlayer *weakPlayer = _player;
    //添加观察者，监控播放状况，实时更新slider和progressView
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //更新缓冲进度
        float currentTime = CMTimeGetSeconds(weakPlayer.currentItem.currentTime)/CMTimeGetSeconds(weakPlayer.currentItem.duration);
        weakVC.footerView.slider.value = currentTime;
        //获取当前播放时间
        NSTimeInterval timeInterval = [weakVC availableDuration];
        CMTime duration = weakPlayer.currentItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [weakVC.footerView.progressView setProgress:timeInterval/totalDuration animated:YES];
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem* playerItem = (AVPlayerItem *)object;
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            [_player play];
            _isPlaying = YES;
            [_arrayPlayList addObject:playerItem];
        }
    }
}

//计算缓冲长度
-(NSTimeInterval)availableDuration {
    NSArray* loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    //获取缓冲区域
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}


#pragma mark -------- BroadDetailFooterView代理
-(void)doPlay
{
    UIButton* playButton = _footerView.btnArr[1];
    if (_isPlaying) {
        [_player pause];
        _isPlaying = NO;
        [playButton setImage:[UIImage imageNamed:@"Play_32"] forState:UIControlStateNormal];
    }else{
        [_player play];
        _isPlaying = YES;
        [playButton setImage:[UIImage imageNamed:@"Pause_32"] forState:UIControlStateNormal];
    }
}

-(void)playNext
{
    [_player pause];
    _currentPlayIndex++;
    NSInteger index = _currentPlayIndex%self.playList.count;
    fmModel* model = self.playList[index];
    self.object_id = model.ID;
    [self requestNetData];
}

-(void)playPrev
{
    [_player pause];
    _currentPlayIndex--;
    NSInteger index = _currentPlayIndex%self.playList.count;
    fmModel* model = self.playList[index];
    self.object_id = model.ID;
    [self requestNetData];
}


-(void)setProgress:(UISlider*)slider
{
    [_player pause];
    [_player seekToTime:CMTimeMake(slider.value*CMTimeGetSeconds(_player.currentItem.duration),1) completionHandler:^(BOOL finished) {
        if (finished)
        {
            [_player play];
        }
    }];
}


//一首播放结束，播放下一首
-(void)playDidEnd
{
    [self playNext];
}


//分享
-(void)share
{
    // 定义要分享到哪些平台
    NSArray *list=@[UMShareToSina,UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatSession];
    
    // 调用友盟接口分享信息
    //    [UMSocialSnsService presentSnsController:self appKey:@"56a0fb0767e58eb9ae0031a0" shareText:@"1510" shareImage:nil shareToSnsNames:list delegate:self];
    
    UIImage *img=[UIImage imageNamed:@"IMG_1177"];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56a0fb0767e58eb9ae0031a0" shareText:_shareUrl shareImage:img shareToSnsNames:list delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//后台播放
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type==UIEventTypeRemoteControl)
    {
        if (event.type == UIEventTypeRemoteControl) {
            
            switch (event.subtype) {
                    
                case UIEventSubtypeRemoteControlPlay:
                    [self doPlay];
                    break;
                    
                case UIEventSubtypeRemoteControlPreviousTrack:
                    [self playPrev];
                    break;
                    
                case UIEventSubtypeRemoteControlNextTrack:
                    [self playNext];
                    break;
                    
                case UIEventSubtypeRemoteControlPause:
                    [self doPlay];
                    break;
                    
                default:
                    break;
            }
        }
    }
}

@end
