//
//  DiscoverViewController.m
//  FM
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 CYH. All rights reserved.
//

#import "DiscoverViewController.h"
#import "BroadDetailController.h"
#import "BroadListViewController.h"

//#import "PlayFMsingleton.h"
#import "RequestManager.h"
#import "DiscoverHeaderModel.h"
#import "MJExtension.h"

#import "DiscoverHeaderView.h"
#import "GoodMoodCell.h"
#import "SceneCell.h"

@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DiscoverViewController


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self initUI];
    
    [self loadNetData];
}

- (void)initUI
{
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FM_SIZE.width, FM_SIZE.height-49) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    
    weakSelf(weakSelf);
    DiscoverHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"DiscoverHeaderView" owner:nil options:nil].firstObject;
    headerView.ResponseBlock = ^(DiscoverHeaderModel *model){
        BroadListViewController* broadListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BroadListViewController"];
        NSString* str1 = [model.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithFormat:@"http://bapi.xinli001.com/fm2/broadcast_list.json/?tag=%@&rows=10&key=046b6a2a43dc6ff6e770255f57328f89&speaker_id=0", str1];
    broadListVC.partUrl = str;
    broadListVC.navBarTitle = model.title;

    //是否有Footer
    broadListVC.haveFooter = YES;
    [weakSelf.navigationController pushViewController:broadListVC animated:YES];
    };
    self.myTableView.tableHeaderView = headerView;
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"GoodMoodCell" bundle:nil] forCellReuseIdentifier:@"GoodMoodCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SceneCell" bundle:nil] forCellReuseIdentifier:@"SceneCell"];
}

- (void)loadNetData
{
    weakSelf(weakSelf);
    [RequestManager getRequestWithUrl:@"http://bapi.xinli001.com/fm2/hot_tag_list.json/?flag=4&key=c0d28ec0954084b4426223366293d190&rows=3&offset=0" dict:nil block:^(BOOL isSuccess, id respondObject) {
        if (isSuccess)
        {
            NSArray* dataArray = respondObject[@"data"];
            NSArray *modelArray = [DiscoverHeaderModel mj_objectArrayWithKeyValuesArray:dataArray];
            [weakSelf.dataArray addObjectsFromArray:modelArray];
            [weakSelf loadUIWithNetData];
            
            [weakSelf.myTableView reloadData];

        }
    }];
    
}

- (void)loadUIWithNetData
{
    DiscoverHeaderView *headerView = (DiscoverHeaderView *)self.myTableView.tableHeaderView;
    headerView.modelArr = self.dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    weakSelf(weakSelf);
    if (indexPath.section==0) {
        GoodMoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodMoodCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ResponseBlock = ^(NSString *title){
            BroadListViewController* broadListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BroadListViewController"];
            NSString* str = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* partUrl = [NSString stringWithFormat:@"http://bapi.xinli001.com/fm2/broadcast_list.json/?tag=%@&rows=10&key=046b6a2a43dc6ff6e770255f57328f89&speaker_id=0",str];
            broadListVC.partUrl = partUrl;
            broadListVC.navBarTitle = title;
            
            //是否有Footer
            broadListVC.haveFooter = YES;
            [weakSelf.navigationController pushViewController:broadListVC animated:YES];
        };
        return cell;
    }
    else
    {
        SceneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ResponseBlock = ^(NSString *title){
            BroadListViewController* broadListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BroadListViewController"];
            NSString* str = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* partUrl = [NSString stringWithFormat:@"http://bapi.xinli001.com/fm2/broadcast_list.json/?tag=%@&rows=10&key=046b6a2a43dc6ff6e770255f57328f89&speaker_id=0",str];
            broadListVC.partUrl = partUrl;
            broadListVC.navBarTitle = title;
            
            //是否有Footer
            broadListVC.haveFooter = YES;
            [weakSelf.navigationController pushViewController:broadListVC animated:YES];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


@end
