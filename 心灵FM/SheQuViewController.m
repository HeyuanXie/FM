//
//  SheQuViewController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SheQuViewController.h"
#import "SheQuDetailTableViewController.h"

#import "RequestManager.h"
#import "MJExtension.h"

#import "SheQuModel.h"
#import "SheQuCell.h"

#import <MJRefresh.h>

#define kTextViewPadding 16.0
//#define kLineBreakMode1 UILineBreakModeWordWrap

@interface SheQuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _pageMark;
    NSInteger _type;
    
    NSMutableArray* _dataArray;
}
@property(nonatomic,weak)IBOutlet UITableView* sheQuTableView;

@property(nonatomic,strong)UITableViewCell* propertyCell;

@end

@implementation SheQuViewController

-(void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _pageMark = 0;
    _type = 1;//默认为精华页面，type=1
    _dataArray = [NSMutableArray array];
    
    //加载UI
    [self initUI];
    
    //请求网络数据
    [self requestNetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI
{
    //注册cell
    [self.sheQuTableView registerNib:[UINib nibWithNibName:@"SheQuCell" bundle:nil] forCellReuseIdentifier:@"0"];

    //动态计算cell高度的cell实例，避免每次都重新创建一个cell
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SheQuCell" owner:nil options:nil];
    self.propertyCell = nib[0];
    
    self.sheQuTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.sheQuTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.sheQuTableView.mj_header beginRefreshing];
    
    UISegmentedControl* segment = (UISegmentedControl*)self.navigationItem.titleView;
    [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:(UIControlEventValueChanged)];
}

-(void)requestNetData
{
    NSString* urlStr = [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/forum-thread-list.json?key=046b6a2a43dc6ff6e770255f57328f89&flag=0&offset=%ld&limit=10&type=%ld",_pageMark,_type];
    [RequestManager getRequestWithUrl:urlStr dict:nil block:^(BOOL isSuccess, id respondObject) {
        
        if (isSuccess)
        {
            if (_pageMark == 0)
            {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary* dict in respondObject[@"data"]) {
                SheQuModel* model = [[SheQuModel alloc] mj_setKeyValues:dict];
                [model.user mj_setKeyValues:dict[@"user"]];
                NSArray* images = dict[@"images"];
                if (images.count!=0) {
                    model.images = images[0];
                }else{
                    model.images = nil;
                }
                [_dataArray addObject:model];
            }
            
            [self.sheQuTableView.mj_header endRefreshing];
            [self.sheQuTableView.mj_footer endRefreshing];
            [self.sheQuTableView reloadData];
        }
    }];
    
}


#pragma mark -------segment响应方法
-(void)segmentValueChanged:(UISegmentedControl*)segment
{
    if (segment.selectedSegmentIndex == 0)
    {
//        NSLog(@"精华");
        _type = 1;
        [self.sheQuTableView.mj_header beginRefreshing];
        [self requestNetData];
    }else{
//        NSLog(@"最新");
        _type = 0;
        [self.sheQuTableView.mj_header beginRefreshing];
        [self requestNetData];
    }
}


#pragma mark -------上拉、下拉
-(void)loadNewData
{
    _pageMark = 0;
    [self requestNetData];
}

-(void)loadMoreData
{
    _pageMark+=10;
    [self requestNetData];
}


#pragma mark ------- 社区TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SheQuCell* cell = [[NSBundle mainBundle] loadNibNamed:@"SheQuCell" owner:nil options:nil][0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SheQuModel* model = _dataArray[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
    return [[UITableViewCell alloc] init];
}


//计算行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SheQuModel* model = (SheQuModel*)_dataArray[indexPath.row];
    //通过字符串计算高度
    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    if (model.images) {
        
        return rect.size.height+70+95+30;
        
    }else{
        
        return rect.size.height+95+10;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SheQuDetailTableViewController* sheQuDetailVC = [[SheQuDetailTableViewController alloc] init];
    sheQuDetailVC.post_id = [_dataArray[indexPath.row] ID];
    [self.navigationController pushViewController:sheQuDetailVC animated:YES];
}
@end
