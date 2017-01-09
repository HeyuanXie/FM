//
//  ZhuBoListViewController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/25.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "ZhuBoListViewController.h"
#import "DianTaiDetailController.h"
#import "BassTabBarController.h"

#import "RequestManager.h"
#import "MJExtension.h"

#import "ZhuBoListModel.h"
#import "HomeModel.h"
#import "DianTaiCell.h"
#import "ZuiXinCell.h"

#import "UIImageView+WebCache.h"

#import <MJRefresh.h>

@interface ZhuBoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* zhuBoListTableView;
@property(nonatomic,strong)UIScrollView* headerView;


//数据层：zhuBoListModle + hotList
@property(nonatomic,strong)NSMutableArray* hotList;
@property(nonatomic,strong)ZhuBoListModel* zhuBoListModel;

@property(nonatomic,assign)NSInteger pageMark;

@end

@implementation ZhuBoListViewController

-(void)viewWillAppear:(BOOL)animated
{
    BassTabBarController* tabBarController = (BassTabBarController*)self.tabBarController;
    tabBarController.barImageView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    BassTabBarController* tabBarController = (BassTabBarController*)self.tabBarController;
    tabBarController.barImageView.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    _hotList = [NSMutableArray array];
    
    //创建UI
    [self initUI];
    
    //请求网络数据
    [self requestNetData];
}


-(void)initUI
{
    self.navigationItem.title = @"发现主播";
    _pageMark = 0;
    
    _zhuBoListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FM_SIZE.width, FM_SIZE.height-64) style:(UITableViewStyleGrouped)];
    _zhuBoListTableView.dataSource = self;
    _zhuBoListTableView.delegate = self;
    [self.view addSubview:_zhuBoListTableView];
    
    self.zhuBoListTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    [self createHeaderView];
    
    //注册cell
    [self.zhuBoListTableView registerNib:[UINib nibWithNibName:@"DianTaiCell" bundle:nil] forCellReuseIdentifier:@"newCell"];
    [self.zhuBoListTableView registerNib:[UINib nibWithNibName:@"ZuiXinCell" bundle:nil] forCellReuseIdentifier:@"hotCell"];
}


-(void)requestNetData
{
    NSString* urlStr1 = @"http://yiapi.xinli001.com/fm/diantai-page.json?key=046b6a2a43dc6ff6e770255f57328f89";
    NSString* urlStr2 = [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/diantai-hot-list.json?key=046b6a2a43dc6ff6e770255f57328f89&offset=%ld&limit=10",_pageMark];

    
    [RequestManager getRequestWithUrl:urlStr1 dict:nil block:^(BOOL isSuccess, id respondObject) {
        
        if (isSuccess) {
            
            _zhuBoListModel = [[ZhuBoListModel alloc] mj_setKeyValues:respondObject[@"data"]];
            
            [RequestManager getRequestWithUrl:urlStr2 dict:nil block:^(BOOL isSuccess, id respondObject) {
                
                if (isSuccess) {
                    
                    NSArray* data = respondObject[@"data"];
                    NSArray* array = [diantaiModel mj_objectArrayWithKeyValuesArray:data];
                    for (diantaiModel* model  in array) {
                        [_hotList addObject:model];
                    }
                    
                    [self setUIWithNetData];
                    [self.zhuBoListTableView reloadData];

                }
            }];


        }
    }];
    
//    [RequestManager getRequestWithUrl:urlStr2 dict:nil block:^(BOOL isSuccess, id respondObject) {
//        
//        if (isSuccess) {
//            
//            NSArray* data = respondObject[@"data"];
//            _hotList = [diantaiModel mj_objectArrayWithKeyValuesArray:data];
//        }
//    }];
    
}


-(void)createHeaderView
{
    _headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, 160)];
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:_headerView.frame];
    [_headerView addSubview:scrollView];
    scrollView.tag = 400;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, scrollView.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"default_3_2"];
    [scrollView addSubview:imageView];
    _zhuBoListTableView.tableHeaderView = _headerView;
}


-(void)setUIWithNetData
{
    NSArray* tuijian = _zhuBoListModel.tuijian;
    UIScrollView* scrollView = (UIScrollView*)[self.headerView viewWithTag:400];
    scrollView.contentSize = CGSizeMake(FM_SIZE.width*tuijian.count, 0);
    
    for (int i=0; i<tuijian.count; i++)
    {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(FM_SIZE.width*i, 0, FM_SIZE.width, scrollView.frame.size.height)];
        diantaiModel* model = tuijian[i];
        [imageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
        [scrollView addSubview:imageView];
        
        //给imageView添加响应事件
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTuiJianImage:)];
        [imageView addGestureRecognizer:tap];
    }
    
    [self.zhuBoListTableView.mj_footer endRefreshing];
    
}


-(void)loadMoreData
{
    _pageMark+=10;
    [self requestNetData];
}

-(void)tapTuiJianImage:(UITapGestureRecognizer*)tap
{
    UIImageView* imageView = (UIImageView*)tap.view;
    diantaiModel* model = _zhuBoListModel.tuijian[imageView.tag - 100];
    DianTaiDetailController* dianTaiDetailVC = [[DianTaiDetailController alloc] init];
    dianTaiDetailVC.model = model;
    [self.navigationController pushViewController:dianTaiDetailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------- tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return _hotList.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        DianTaiCell* cell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];

        //点击cell上的按钮响应block
        cell.tapImageBlock = ^(NSInteger index){
            
            diantaiModel* model = _zhuBoListModel.newlist[index];
            DianTaiDetailController* dianTaiDetailVC = [[DianTaiDetailController alloc] init];
            dianTaiDetailVC.model = model;
            [self.navigationController pushViewController:dianTaiDetailVC animated:YES];
        };
        
        NSArray* array = _zhuBoListModel.newlist;
        [cell setUIWithArray:array];
        return cell;
    }else{
        
        ZuiXinCell* cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        diantaiModel* model = _hotList[indexPath.row];
        [cell setUIWithModelInZhuBoListTable:model];
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }else{
        return 60;
    }
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        diantaiModel* model = _hotList[indexPath.row];
        DianTaiDetailController* dianTaiDetailVC = [[DianTaiDetailController alloc] init];
        dianTaiDetailVC.model = model;
        [self.navigationController pushViewController:dianTaiDetailVC animated:YES];
    }
}

@end
