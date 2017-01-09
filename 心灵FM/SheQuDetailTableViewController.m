//
//  SheQuDetailTableViewController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SheQuDetailTableViewController.h"
#import "SheQuDetailCell.h"
#import "DetailHeaderView.h"
#import "UserDetailViewController.h"

#import "SheQuModel.h"

#import "RequestManager.h"
#import "MJExtension.h"

#import <MJRefresh.h>

@interface SheQuDetailTableViewController ()
{
    NSInteger _pageMark;
}

@property(nonatomic,strong)SheQuModel* headerViewModel;//头部视图的数据
@property(nonatomic,strong)NSMutableArray* dataArray;

@property(nonatomic,strong)DetailHeaderView* headerView;
@property(nonatomic,strong)SheQuDetailCell* propertyCell;

@end

@implementation SheQuDetailTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
     self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageMark = 0;
    _dataArray = [NSMutableArray array];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"详情";
    
    [self initUI];

    [self requestNetData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SheQuCell" bundle:nil] forCellReuseIdentifier:@"1"];
    
    _propertyCell = [[NSBundle mainBundle] loadNibNamed:@"SheQuCell" owner:nil options:nil][1];
    
    _headerView = [[NSBundle mainBundle] loadNibNamed:@"SheQuCell" owner:nil options:nil][2];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FM_SIZE.width, FM_SIZE.height-64-49) style:(UITableViewStylePlain)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //当table没有内容时，显示为空白
    self.tableView.tableFooterView = [[UIView alloc] init];
}

//请求网路数据
-(void)requestNetData
{
    NSString* urlStr = [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/forum-comment-list.json?key=046b6a2a43dc6ff6e770255f57328f89&post_id=%@&offset=%ld&limit=10",self.post_id,_pageMark];
    [RequestManager getRequestWithUrl:urlStr dict:nil block:^(BOOL isSuccess, id respondObject) {
        
        if (isSuccess)
        {
            
            _headerViewModel = [[SheQuModel alloc] mj_setKeyValues:respondObject[@"post"]];
            
            for (NSDictionary* dict in respondObject[@"data"])
            {
                SheQuModel* model = [[SheQuModel alloc] mj_setKeyValues:dict];
                [_dataArray addObject:model];
            }
            [self loadUIWithNetData];
        }
    }];
}


-(void)loadUIWithNetData
{
    //第一次加载数据时，给头部视图赋值，之后上拉调用此方法时不执行
    if (_pageMark==0) {
        [_headerView setHeaderViewWithModel:self.headerViewModel];
        //_headerView setUI中给他调整高度后再赋值给self.tableView.tableHeaderView
        self.tableView.tableHeaderView = _headerView;
    }
    
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}


//上拉加载更多
-(void)loadMoreData
{
    _pageMark+=10;
    [self requestNetData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SheQuDetailCell* detailCell = [[NSBundle mainBundle] loadNibNamed:@"SheQuCell" owner:self options:nil][1];
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    SheQuModel* model = _dataArray[indexPath.row];
    [detailCell setUIWithModel:model];
    return detailCell;
}

//计算行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SheQuModel* model = (SheQuModel*)_dataArray[indexPath.row];
    //通过字符串计算高度
    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height + 90;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserDetailViewController* userDetailVC = [[UserDetailViewController alloc] init];
    SheQuModel* model = _dataArray[indexPath.row];
    userDetailVC.user_id = model.user.ID;
    [self.navigationController pushViewController:userDetailVC animated:YES];
}

@end
