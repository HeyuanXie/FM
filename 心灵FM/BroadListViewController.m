//
//  BroadListViewController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "BroadListViewController.h"
#import "BroadDetailController.h"
#import "BassTabBarController.h"

#import "BroadListCell.h"
#import "HomeModel.h"

#import "RequestManager.h"
#import "MJExtension.h"

#import <MJRefresh.h>
#import <MJRefreshGifHeader.h>
#import <MJRefreshAutoGifFooter.h>

@interface BroadListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView* broadListTableView;

@property(nonatomic,strong)NSMutableArray* dataArray;//数据源


@end

@implementation BroadListViewController

-(void)viewWillAppear:(BOOL)animated
{
    //从下一个页面回来时不会将导航栏下降64
    self.automaticallyAdjustsScrollViewInsets = NO;
    //从上一个页面进来后导航栏下面加上一条线
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    
    BassTabBarController* tabBarController = (BassTabBarController*)self.tabBarController;
    tabBarController.barImageView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //跳转到下一个页面时，让导航栏下面的线消失
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    BassTabBarController* tabBarController = (BassTabBarController*)self.tabBarController;
    tabBarController.barImageView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageMark = 0;
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    [self initUI];
    [self loadNetData];
}


-(void)initUI
{
    self.navigationItem.title = self.navBarTitle;
    //注册cell
    [self.broadListTableView registerNib:[UINib nibWithNibName:@"BroadListCell" bundle:nil] forCellReuseIdentifier:@"broadList"];
    
    self.broadListTableView.showsVerticalScrollIndicator = NO;
    
    //添加上拉、下拉
    self.broadListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    if (self.haveFooter == YES) {
        self.broadListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    //设置下拉动画图片
    [self setGifImage];
    
}

-(void)loadNetData
{
    self.urlStr = [NSString stringWithFormat:@"%@&offset=%ld",self.partUrl,self.pageMark];
    [RequestManager getRequestWithUrl:self.urlStr dict:nil block:^(BOOL isSuccess, id respondObject) {
        
        if (isSuccess)
        {
            if (_pageMark == 0) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary* dict in respondObject[@"data"])
            {
                fmModel* model = [[fmModel alloc] mj_setKeyValues:dict];
                [_dataArray addObject:model];
            }
            
            [self setUIWithNetData];
            
        }
    }];
}


-(void)setUIWithNetData
{
    [self.broadListTableView reloadData];
    [self.broadListTableView.mj_header endRefreshing];
    [self.broadListTableView.mj_footer endRefreshing];
}

//下拉刷新
-(void)loadNewData
{
    _pageMark = 0;
    [self loadNetData];
}

//上拉加载更多
-(void)loadMoreData
{
    _pageMark += 10;
    [self loadNetData];
}

-(void)setGifImage
{
    //上拉
    MJRefreshGifHeader* header = (MJRefreshGifHeader*)self.broadListTableView.mj_header;
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [self.broadListTableView.mj_header beginRefreshing];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [header setImages:idleImages forState:MJRefreshStateIdle];
    
    //下拉
    MJRefreshAutoGifFooter* footer = (MJRefreshAutoGifFooter*)self.broadListTableView.mj_footer;
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages1 = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages1 addObject:image];
    }
    [footer setImages:refreshingImages1 forState:MJRefreshStateRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ====BoradListTableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BroadListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"broadList"];
    [cell setUIWithModel:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BroadListCell setCellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击进入detail页面
    BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
    fmModel* model = self.dataArray[indexPath.row];
    broadDetailVC.object_id = model.ID;
    
    //传递播放列表，存放的是fmModel
    broadDetailVC.playList = _dataArray;
    
    [self.navigationController pushViewController:broadDetailVC animated:YES];
}
@end
