//
//  ViewController.m
//  心灵FM
//
//  Created by qianfeng on 16/2/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"
#import "BroadListViewController.h"
#import "BroadDetailController.h"
#import "DianTaiDetailController.h"
#import "ZhuBoListViewController.h"

#import "SectionHeaderView.h"
#import "SectionFooterView.h"
#import "ZuiXinCell.h"
#import "HotCell.h"
#import "DianTaiCell.h"

#import "HomeModel.h"

#import "RequestManager.h"
#import "MJExtension.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView* homeTableView;//首页的tableView

@property(nonatomic,strong)HomeModel* homeModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //加载UI
    [self initUI];
    
    //请求网络数据
    [self requestNetData];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self setNeedsStatusBarAppearanceUpdate];
}


-(void)initUI
{
    HeaderView* headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, 390)];
    
    //关闭弹簧效果
    _homeTableView.bounces = NO;
    //隐藏右侧滑条
    _homeTableView.showsVerticalScrollIndicator = NO;

    
    //headerView里选择 推荐图片的回调，在回调里执行 selectTuiJian:index 这个方法
    headerView.selectTuiJianBlock = ^(NSInteger index){
        [self selectTuiJian:index];
    };
    headerView.selectCategoryBlock = ^(NSInteger index){
        [self selectCategroy:index];
    };
    
    
    _homeTableView.tableHeaderView = headerView;
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    
    
    //注册 几个自定义的 cell
    [self.homeTableView registerNib:[UINib nibWithNibName:@"ZuiXinCell" bundle:nil] forCellReuseIdentifier:@"zuiXin"];
    [self.homeTableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"hotCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName:@"DianTaiCell" bundle:nil] forCellReuseIdentifier:@"dianTaiCell"];
    
}


-(void)requestNetData
{
    [RequestManager getRequestWithUrl:@"http://yiapi.xinli001.com/fm/home-list.json?key=046b6a2a43dc6ff6e770255f57328f89" dict:nil block:^(BOOL isSuccess, id respondObject) {
        
        if (isSuccess) {
            
//            NSLog(@"%@",respondObject);
            _homeModel = [[HomeModel alloc] mj_setKeyValues:respondObject[@"data"]];
            
            //数据请求完成,更新UI
            [self setUIWithNetData];
        }
    }];
}


-(void)setUIWithNetData
{
    HeaderView* headerView = (HeaderView*)_homeTableView.tableHeaderView;
    [headerView loadTuiJianWithArray:_homeModel.tuijian];
    [headerView loadCategoryWithArray:_homeModel.category];
    
    [self.homeTableView reloadData];
}



//选择 推荐图片
-(void)selectTuiJian:(NSInteger)index
{
    //点击前两个跳转到 BroadListVC
    if (index != 2)
    {
        tuijianModel* model = self.homeModel.tuijian[index];
        BroadListViewController* broadListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BroadListViewController"];
        NSString* str = [model.value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* partUrl = [NSString stringWithFormat:@"http://bapi.xinli001.com/fm2/broadcast_list.json/?tag=%@&rows=10&key=046b6a2a43dc6ff6e770255f57328f89&speaker_id=0",str];
        broadListVC.partUrl = partUrl;
        broadListVC.navBarTitle = model.title;
        broadListVC.haveFooter = NO;
        [self.navigationController pushViewController:broadListVC animated:YES];
    }else{
        //点击第三个 跳转到broadDetailVC
        BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
        tuijianModel* model = _homeModel.tuijian[2];
        broadDetailVC.object_id = model.value;
        ///此处播放的列表只有一个，但也要传一个播放列表过去，否则下一首会崩溃
        broadDetailVC.playList = _homeModel.hotfm;
        [self.navigationController pushViewController:broadDetailVC animated:YES];
    }
}

//选择 Category按钮
-(void)selectCategroy:(NSInteger)index
{
    categoryModel* model = self.homeModel.category[index];
    BroadListViewController* broadListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BroadListViewController"];
    broadListVC.pageMark = 0;
    broadListVC.navBarTitle = model.name;
    broadListVC.haveFooter = YES;
    broadListVC.partUrl = [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/category-jiemu-list.json?category_id=%@&key=046b6a2a43dc6ff6e770255f57328f89&limit=10",model.ID];
    [self.navigationController pushViewController:broadListVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark------homeTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 3) {
        return 1;
    }else{
        return 3;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        HotCell* cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        NSArray* hotArr = _homeModel.hotfm;
        [cell setUIWithArray:hotArr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        weakSelf(weakSelf);
        //hotFM上的响应block
        cell.tapImageBlock = ^(NSInteger index){
            
            [weakSelf selectHotCellWithIndex:index];
        };
        return cell;
        
    }else if (indexPath.section == 1) {
        
        ZuiXinCell* cell = [tableView dequeueReusableCellWithIdentifier:@"zuiXin"];
        fmModel* model = _homeModel.newlesson[indexPath.row];
        [cell setUIWithModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 2) {
        
        ZuiXinCell* cell = [tableView dequeueReusableCellWithIdentifier:@"zuiXin"];
        fmModel* model = _homeModel.newfm[indexPath.row];
        [cell setUIWithModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        DianTaiCell* cell = [tableView dequeueReusableCellWithIdentifier:@"dianTaiCell"];
        NSArray* array = _homeModel.diantai;
        [cell setUIWithArray:array];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //选择diantaiCell的响应block
        weakSelf(weakSelf);
        cell.tapImageBlock = ^(NSInteger index){
            
            [weakSelf selectDianTaiCellWithIndex:index];
        };
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 3){
        return 110;
    }
    return 60;
}


#pragma mark -----选择每个cell响应方法
//选择热门推荐
-(void)selectHotCellWithIndex:(NSInteger) index
{
    fmModel* model = _homeModel.hotfm[index];
    BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
    broadDetailVC.object_id = model.ID;
    broadDetailVC.playList = _homeModel.hotfm;
    broadDetailVC.currentIndex = index;
    [self.navigationController pushViewController:broadDetailVC animated:YES];
}

//选择电台推荐
-(void)selectDianTaiCellWithIndex:(NSInteger)index
{
    diantaiModel* model = _homeModel.diantai[index];
    //跳转到diantai-detail
    DianTaiDetailController* dianTaiDetailVC = [[DianTaiDetailController alloc] init];
    dianTaiDetailVC.model = model;
    [self.navigationController pushViewController:dianTaiDetailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    fmModel* model = [[fmModel alloc] init];
    if (indexPath.section == 1){
        model = _homeModel.newlesson[indexPath.row];
    }else if (indexPath.section == 2){
        model = _homeModel.newfm[indexPath.row];
    }
    
    if (indexPath.section == 1 || indexPath.section ==2) {
        BroadDetailController* broadDetailVC = [BroadDetailController shareBroadDetailController];
        broadDetailVC.object_id = model.ID;
        
        //将播放列表传过去
        if (indexPath.section ==1) {
            broadDetailVC.playList = _homeModel.newlesson;
            broadDetailVC.currentIndex = indexPath.row;
        }else{
            broadDetailVC.playList = _homeModel.newfm;
            broadDetailVC.currentIndex = indexPath.row;
        }
        [self.navigationController pushViewController:broadDetailVC animated:YES];
    }else{
        
    }
}

#pragma mark -----设置分区头部、尾部视图
//分区头部视图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SectionHeaderView* sectionHeaderView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, 30) andSection:section];
    [sectionHeaderView setLabelInSection:section];
    return sectionHeaderView;
}

//分区尾部视图
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, 5)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.alpha = 0.5;
        return view;
    }else{
        //创建尾部视图
        SectionFooterView* sectionFooterView = [[SectionFooterView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, 40) andSection:section];
        [sectionFooterView setLabelInSection:section];

        //点击尾部视图回调的block
        sectionFooterView.tapFooterViewBlock = ^(SectionFooterView* footerView){
            BroadListViewController* broadListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BroadListViewController"];
            broadListVC.haveFooter = YES;
            if (section==1) {
                broadListVC.navBarTitle = @"更多心理课";
            }else if(section ==2){
                broadListVC.navBarTitle = @"更多FM";
            }

            //判断点击尾部视图是否跳转到BroadListViewController
            if (footerView.isBroadListView)
            {
                broadListVC.partUrl = footerView.partUrl;
                [self.navigationController pushViewController:broadListVC animated:YES];
            }else{
                //跳转到更多电台
//                NSLog(@"跳转到更多电台diantailist");
                ZhuBoListViewController* zhuBoListVC = [[ZhuBoListViewController alloc] init];
                [self.navigationController pushViewController:zhuBoListVC animated:YES];
                
            }
        };
        return sectionFooterView;
    }
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 5.0;
    }else{
        
        return 40.0;
    }
}

@end
