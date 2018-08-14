//
//  NearViewController.m
//  YKLiveShow
//
//  Created by markye on 2018/6/6.
//  Copyright © 2018年 markye. All rights reserved.
//

#import "NearViewController.h"
#import "LivePlayerViewController.h"
#import "NearCollectionCell.h"

#define ReuseCollectionCell @"NearCollectionCell"

@interface NearViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *nearColloectionView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation NearViewController

-(NSMutableArray *)dataList{
    if(!_dataList){
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置代理和数据源
    self.nearColloectionView.delegate = self;
    self.nearColloectionView.dataSource = self;
    //设置layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    //设置collection边距
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.nearColloectionView.collectionViewLayout = layout;
    //注册重用标示
    [self.nearColloectionView registerNib:[UINib nibWithNibName:@"NearCollectionCell" bundle:nil] forCellWithReuseIdentifier:ReuseCollectionCell];
    
    //添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:LocationUpdatedNotification  object:nil];
    
    //添加长按手势
    @weakify(self)
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(UILongPressGestureRecognizer  *gesture) {
        @strongify(self)
        
        //获取触摸位置
        CGPoint touchP = [gesture locationInView:self.nearColloectionView];
        //手势开始事件
        if (gesture.state == UIGestureRecognizerStateBegan) {
            //获取长按的cell下标
            NSIndexPath *indexPath = [self.nearColloectionView indexPathForItemAtPoint:touchP];
            if (indexPath == nil) {
            }else{
//                NSLog(@"Section = %ld,Row = %ld",(long)indexPath.section,(long)indexPath.row);
                Live *live = (Live *)self.dataList[indexPath.row];
                NSString *msg = [NSString stringWithFormat:@"主播:%@\n\n直播流地址%@已复制至粘贴板",live.creator.nick,live.stream_addr];
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[UIPasteboard generalPasteboard] setString:live.stream_addr];
                }];
                [alertVc addAction:action];
                [self presentViewController:alertVc animated:YES completion:nil];
            }
        }
    }];
    [self.nearColloectionView addGestureRecognizer:longPress];
    
    //刷新
    [self setupRefresh];
    [self setupInitData];
    //加载数据
    [self loadData];
}

-(void)setupInitData{
    //初始化一个
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *latitude = [userDefault objectForKey:latitudeKey];
    
    if (latitude == nil) {
        latitude = @"30.3";
        NSString *longitude =@"120.2";
        //存储在内存中
        [userDefault setObject:latitude forKey:latitudeKey];
        [userDefault setObject:longitude forKey:longitudeKey];
        [userDefault synchronize];
    }
}

-(void)loadData{
    @weakify(self)
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *latitude = [userDefault objectForKey:latitudeKey];
    NSString *longitude = [userDefault objectForKey:longitudeKey];
    
    NSString *url = [NSString stringWithFormat:API_NearLocation,latitude,longitude];
    [HttpTool getWithPath:url params:nil success:^(id json) {
        @strongify(self)
//        NSLog(@"%@",json);
        [self.nearColloectionView.mj_header endRefreshing];
        NSArray *lives = json[@"lives"];
        self.dataList = [Live mj_objectArrayWithKeyValuesArray:lives];
        [self.nearColloectionView reloadData];
    } failure:^(NSError *error) {
        [self.nearColloectionView.mj_header endRefreshing];
    }];
}

-(void)setupRefresh{
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.nearColloectionView.mj_header = header;
}

-(void)locationUpdated:(NSNotification *)notification{
    [self loadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NearCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseCollectionCell forIndexPath:indexPath];
    cell.live = (Live *)self.dataList[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NearCollectionCell * c = (NearCollectionCell *)cell;
    [c showAnimation];
}

//collection 大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (UIScreen.mainScreen.bounds.size.width - 3*10)/2;
    return CGSizeMake(width, width+30);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //主线程中运行
    dispatch_async(dispatch_get_main_queue(), ^{
        LivePlayerViewController *playerVc = [LivePlayerViewController new];
        playerVc.live = (Live *)self.dataList[indexPath.row];
        [self presentViewController:playerVc animated:YES completion:nil];
    });
}

-(void)dealloc{
    //移除通知~
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LocationUpdatedNotification object:nil];
}

@end
