//
//  HomeViewController.m
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeLiveCell.h"
#import "LivePlayerViewController.h"

#define ReuseCell @"HomeLiveCell"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation HomeViewController

-(NSMutableArray *)dataList{
    if(!_dataList){
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.tableHeaderView = [UIView new];
    self.homeTableView.tableFooterView = [UIView new];
    [self.homeTableView registerNib:[UINib nibWithNibName:@"HomeLiveCell" bundle:nil] forCellReuseIdentifier:ReuseCell];
    //添加刷新控件
    [self setupRefresh];
    
    [[[Live alloc] init] test];
    
    [self loadData];
}

-(void)setupRefresh{
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.homeTableView.mj_header = header;
}

-(void)loadData{
    @weakify(self)
    [HttpTool getWithPath:API_LiveGetTop params:nil success:^(id json) {
        NSLog(@"%@",json);
        @strongify(self)
        //结束刷新
        [self.homeTableView.mj_header endRefreshing];
        //处理数据
        NSArray *lives = json[@"lives"];
        self.dataList = [Live mj_objectArrayWithKeyValuesArray:lives];
        [self.homeTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.homeTableView.mj_header endRefreshing];
        NSLog(@"失败了~~%@",error.localizedDescription);
    }];
}

#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseCell];
    Live *live = (Live *)self.dataList[indexPath.row];
    cell.live = live;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        LivePlayerViewController *playerVc = [LivePlayerViewController new];
        playerVc.live = (Live *)self.dataList[indexPath.row];
        [self presentViewController:playerVc animated:YES completion:nil];
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UIScreen.mainScreen.bounds.size.width + 70;
}

@end
