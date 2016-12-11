//
//  findVC.m
//  迷你News
//
//  Created by qingyun on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "findVC.h"
#import "Header.h"
#import "URL.h"
#import "CollectView.h"
@interface findVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic,assign) NSInteger GXtimes;
@property (nonatomic, strong) URL *urlL;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) CollectView *cell;
@end

@implementation findVC

static NSString *identifer = @"cell";

//懒加载
- (NSMutableArray *)datasArr
{
    if (_datasArr == nil) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    
    [self createCollectionView];
    [self addRefresh];
    [self loadDataFromNet];
    //刷新瀑布流
    [self.collectionView reloadData];
}

#pragma mark -creatCollectionView
- (void)createCollectionView
{
    //设置瀑布流布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置section的页眉和页脚高
    flowLayout.headerReferenceSize = CGSizeMake(10, 10);
    flowLayout.footerReferenceSize = CGSizeMake(10, 10);
    
    flowLayout.itemSize= CGSizeMake(350, 180);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    
    //钉住头视图
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    
   _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    
    //设置数据源和代理
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.25 alpha:0.9];
    
    //注册item
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectView" bundle:nil] forCellWithReuseIdentifier:identifer];
    //注册头未识图
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifer];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifer];
}

#pragma mark -下啦刷新
- (void)addRefresh
{
    _urlL = [[URL alloc] init];
    _time =1;
    [_urlL setValue:@(_time) forKey:@"GXtimes"];
    
    __weak findVC *weakSelf = self;
    //下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _time = 1;
        [_urlL setValue:@(_time) forKey:@"GXtimes"];
        [weakSelf loadDataFromNet];
    }];
    
    //上拉加载
    _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        _time++;
        [_urlL setValue:@(_time) forKey:@"GXtimes"];
        [weakSelf loadDataFromNet];
    }];


}

#pragma mark 结束刷新
- (void)endRefresh
{
    if (_refresh.isRefreshing) {
        [_refresh endRefreshing];
    }
    
    if ([_collectionView.mj_header isRefreshing]) {
        [_collectionView.mj_header endRefreshing];
    }
    if ([_collectionView.mj_footer isRefreshing]) {
        [_collectionView.mj_footer endRefreshing];
    }
}


#pragma mark 网络请求
-(void)loadDataFromNet
{
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/javascript",@"application/json", nil];
    [manager GET:_urlL.urlGaoXiao parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject[@"data"][@"list"];
        NSMutableArray *arry = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            [arry addObject:dict];
        }
        [self.datasArr addObjectsFromArray:arry];
        [self.collectionView reloadData];
        NSLog(@"===========");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
    [self endRefresh];
}

#pragma mark -UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    
        _cell.layer.shadowOpacity = 1;
    _cell.layer.shadowRadius = 30;
    _cell.layer.cornerRadius = 10;
    _cell.layer.shadowOffset = CGSizeMake(-6, 6);
//    _cell.layer.contentsAreFlipped = YES;
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.25 alpha:0.9];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [_cell setBackgroundColor:[UIColor whiteColor]];
    _cell.title.textColor = [UIColor blackColor];
    

    NSDictionary *dict = self.datasArr[indexPath.row];
    _cell.title.text = dict[@"title"];
    [_cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"kpic"]]];
    
    return _cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat white = kScreenWidth - 60;
    CGFloat height = kScreenHeight /4;
    return CGSizeMake(white, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIWebView *web = [[UIWebView alloc] init];
    web.delegate = self;
    NSDictionary *model = self.datasArr[indexPath.row];
    NSURL *url = [NSURL URLWithString:model[@"link"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    web.opaque = NO;
    web.backgroundColor = [UIColor clearColor];
    
    findVC *viewController = [[findVC alloc] init];
    [viewController setView:web];
    [self.navigationController pushViewController:viewController animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
