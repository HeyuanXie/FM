//
//  DianTaiDetailController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/24.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "DianTaiDetailController.h"
#import "DTDetailHeaderView.h"
#import "BroadDetailController.h"
#import "ZuiXinCell.h"

#import "DTJieMuModel.h"
#import "RequestManager.h"
#import "MJExtension.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import <MJRefresh.h>
@interface DianTaiDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* _dataArray;
}

@property(nonatomic,strong)UITableView* diantaiDetailTable;
@property(nonatomic,strong)DTDetailHeaderView* headerView;//头部视图
@property(nonatomic,strong)DTJieMuModel* jiemuModel;
@property(nonatomic,copy)NSString* gcover;

@property(nonatomic,assign)NSInteger pageMark;

@end

@implementation DianTaiDetailController

-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageMark = 0;
    _dataArray = [NSMutableArray array];
    
    [self initUI];
    
    [self requestNetData];
}


-(void)initUI
{
    self.diantaiDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, FM_SIZE.height-49) style:(UITableViewStylePlain)];
    self.diantaiDetailTable.dataSource = self;
    self.diantaiDetailTable.delegate = self;
    [self.view addSubview:self.diantaiDetailTable];
    self.diantaiDetailTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self createHeaderView];
    
    [self.diantaiDetailTable registerNib:[UINib nibWithNibName:@"ZuiXinCell" bundle:nil] forCellReuseIdentifier:@"dianTaiDetailCell"];
}


-(void)requestNetData
{
    NSString* urlStr = [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/diantai-detai.json?key=046b6a2a43dc6ff6e770255f57328f89&id=%@",self.model.ID];
    [RequestManager getRequestWithUrl:urlStr dict:nil block:^(BOOL isSuccess, id respondObject) {
        
        if (isSuccess)
        {
            self.gcover = respondObject[@"data"][@"gcover"];
        }
    }];
    
//    http://yiapi.xinli001.com/fm/diantai-jiemu-list.json?key=046b6a2a43dc6ff6e770255f57328f89&offset=0&diantai_id=905&limit=10
    NSString* urlStr1 = [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/diantai-jiemu-list.json?key=046b6a2a43dc6ff6e770255f57328f89&offset=%ld&diantai_id=%@&limit=10",_pageMark,self.model.ID];
    weakSelf(weakSelf);
    [RequestManager getRequestWithUrl:urlStr1 dict:nil block:^(BOOL isSuccess, id respondObject) {
        
        if (isSuccess)
        {
            self.jiemuModel = [[DTJieMuModel alloc] mj_setKeyValues:respondObject];
            
            for (fmModel* model  in self.jiemuModel.data) {
                [_dataArray addObject:model];
            }
            [weakSelf setUIWithNetData];
        }
    }];
}

-(void)createHeaderView
{
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"DTDetailHeaderView" owner:nil options:nil] firstObject];
    //设置关注按钮初始的图片
    UIImage* image = [UIImage imageNamed:@"guanzhu"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_headerView.guanzhuButton setImage:image forState:(UIControlStateNormal)];
    _headerView.iconImage.layer.masksToBounds = YES;
    _headerView.iconImage.layer.cornerRadius = _headerView.iconImage.frame.size.width/2;
    
    [_headerView.guanzhuButton addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.diantaiDetailTable.tableHeaderView = _headerView;
}

-(void)setUIWithNetData
{
    [_headerView.backImage setImageWithURL:[NSURL URLWithString:self.gcover] placeholderImage:nil];
    [_headerView.iconImage setImageWithURL:[NSURL URLWithString:self.model.cover] placeholderImage:nil];
    _headerView.speakLabel.text = self.model.title;
    _headerView.numLabel.text = [NSString stringWithFormat:@"收听 %@ | 关注 %@",self.model.viewnum,self.model.favnum];
    _headerView.contentLabel.text = self.model.content;
    
    [self.diantaiDetailTable reloadData];
    [self.diantaiDetailTable.mj_footer endRefreshing];
}


///点击关注
-(void)btnClick:(UIButton*)button
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    _appDelegate = (AppDelegate*)appDelegate;
    _appDelegate.isGuanZhu *= -1;

    if (_appDelegate.isGuanZhu==1) {
        UIImage* selectImage = [UIImage imageNamed:@"guanzhu_act"];
            selectImage = [selectImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [button setImage:selectImage forState:(UIControlStateNormal)];
    }
    if (_appDelegate.isGuanZhu == -1) {
        UIImage* image = [UIImage imageNamed:@"guanzhu"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:image forState:UIControlStateNormal];
    }

}



//上拉加载更多
-(void)loadMoreData
{
    _pageMark+=10;
    [self requestNetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ------ tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZuiXinCell* cell = [tableView dequeueReusableCellWithIdentifier:@"dianTaiDetailCell"];
    
    fmModel* fmModel = _dataArray[indexPath.row];
    //因为ZuiXinCell的setUI方法中label2.text=fmModel.speak，所以这里要将 FMModel.speak换成viewnum
    fmModel.speak = [NSString stringWithFormat:@"收听 %@",fmModel.viewnum];
    
    //ZuiXinCell的更新cell数据的方法
    [cell setUIWithModel:fmModel];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}



//选择节目cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
    fmModel* model = _dataArray[indexPath.row];
    broadDetailVC.object_id = model.ID;
    [self.navigationController pushViewController:broadDetailVC animated:YES];
}


//电台Detailtable的section头部视图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, 20)];

    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    leftView.backgroundColor = [UIColor redColor];
    [sectionHeaderView addSubview:leftView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, FM_SIZE.width-10, 20)];
    [sectionHeaderView addSubview:label];
    NSString* str = [NSString stringWithFormat:@"全部节目 (%@)",self.model.fmnum];
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[str rangeOfString:[NSString stringWithFormat:@"(%@)",self.model.fmnum]]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[str rangeOfString:[NSString stringWithFormat:@"(%@)",self.model.fmnum]]];

    label.attributedText = attStr;
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
@end
