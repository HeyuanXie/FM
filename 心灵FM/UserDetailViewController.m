//
//  UserDetailViewController.m
//  心灵FM
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "UserDetailViewController.h"
#import "BroadDetailController.h"
#import "BroadListCell.h"

#import "MJExtension.h"
#import "RequestManager.h"

#import "HomeModel.h"
#import "SheQuModel.h"

#import "UIImageView+WebCache.h"

#import <MJRefresh.h>

@interface UserDetailViewController ()
{
    NSInteger _pageMark;
    NSInteger _number;//收藏节目数量
}
@property(nonatomic,strong)UIView* headerView;
@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation UserDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
//    self.navigationController.navigationBar.layer.masksToBounds = YES;
//    self.navigationController.navigationBar.translucent = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageMark = 0;
    _dataArray = [NSMutableArray array];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initUI];
    
    [self requestNetData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"BroadListCell" bundle:nil] forCellReuseIdentifier:@"userDetailCell"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self createHeaderView];
}

-(void)requestNetData
{
    NSString* urlStr1 = [NSString stringWithFormat:@"http://bapi.xinli001.com/users/user_detail.json/?pk=%@&key=046b6a2a43dc6ff6e770255f57328f89",self.user_id];
    [RequestManager getRequestWithUrl:urlStr1 dict:nil block:^(BOOL isSuccess, id respondObject) {
        if (isSuccess)
        {
            UserModel* model = [[UserModel alloc] mj_setKeyValues:respondObject[@"data"]];
            if (_pageMark == 0) {
                [self setHeaderWithModel:model];
            }
        }
    }];
    
    
    NSString* urlStr2 = [NSString stringWithFormat:@"http://bapi.xinli001.com/fm2/favorite_list.json/?rows=10&key=046b6a2a43dc6ff6e770255f57328f89&offset=%ld&user_id=%@",_pageMark,self.user_id];
    [RequestManager getRequestWithUrl:urlStr2 dict:nil block:^(BOOL isSuccess, id respondObject) {
        if (isSuccess)
        {
            _number = [respondObject[@"count"] integerValue];
            
            NSArray* data = respondObject[@"data"];
            NSArray* fmArr = [fmModel mj_objectArrayWithKeyValuesArray:data];
            [_dataArray addObjectsFromArray:fmArr];

            //更新头部视图中收藏数量
            UILabel* numberLabel = [_headerView viewWithTag:103];
            numberLabel.text = [NSString stringWithFormat:@"他的收藏 %ld",_number];
            [self.tableView reloadData];
        }
        
    }];
}

-(void)createHeaderView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, 220)];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, view.frame.size.height*2/3)];
    imageView.image = [UIImage imageNamed:@"123"];
    [view addSubview:imageView];
    
    UIImageView* iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imageView.frame)-20, 50, 50)];
    iconImage.tag = 100;
    iconImage.layer.masksToBounds = YES;
    iconImage.layer.cornerRadius = iconImage.frame.size.width/2.0f;
    [view addSubview:iconImage];
    
    UILabel* nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+10, CGRectGetMaxY(imageView.frame), 200, 20)];
    nicknameLabel.tag = 101;
    nicknameLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:nicknameLabel];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nicknameLabel.frame), CGRectGetMaxY(nicknameLabel.frame)+5, FM_SIZE.width-80, 20)];
    titleLabel.tag = 102;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:titleLabel];
    
    UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+10, FM_SIZE.width/2, 20)];
    numberLabel.tag = 103;
    numberLabel.textColor = [UIColor orangeColor];
    [view addSubview:numberLabel];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(numberLabel.frame)+2, FM_SIZE.width, 3)];
    lineView.backgroundColor = [UIColor orangeColor];
    [view addSubview:lineView];
    
    _headerView = view;
    self.tableView.tableHeaderView = _headerView;
}


//更新头部视图
-(void)setHeaderWithModel:(UserModel*)model
{
    UIImageView* iconImage = [_headerView viewWithTag:100];
    UILabel* nicknameLabel = [_headerView viewWithTag:101];
    UILabel* titleLabel = [_headerView viewWithTag:102];
    [iconImage setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];

    nicknameLabel.text = model.nickname;
    titleLabel.text = model.introduce;
}


//MJRefresh
-(void)loadMoreData
{
    _pageMark+=10;
    [self requestNetData];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BroadListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"userDetailCell"];
    fmModel* model = _dataArray[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
    fmModel* model = _dataArray[indexPath.row];
    broadDetailVC.object_id = model.ID;
    broadDetailVC.playList = _dataArray;
    [self.navigationController pushViewController:broadDetailVC animated:YES];
}
@end
