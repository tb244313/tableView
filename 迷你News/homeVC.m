//
//  homeVC.m
//  迷你News
//
//  Created by qingyun on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "homeVC.h"
#import "BigScrollView.h"
#import "itermsScrollView.h"
#import "Header.h"
#import "URL.h"
#import "Model.h"
#import "ModelCell.h"
#import "DataBaseEngine.h"

@interface homeVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong) itermsScrollView *itemsView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *middleTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic,strong)URL *urlString;
@property (nonatomic, strong) BigScrollView *tablesScrollView;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger i;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *itemsArr;
@property (nonatomic, strong) NSArray *leftArr;
@property (nonatomic, strong) NSArray *middleArr;
@property (nonatomic, strong) NSArray *rightArr;

@property (nonatomic,strong)UIRefreshControl *refresh;
@property (nonatomic,strong)UIRefreshControl *refresh1;
@property (nonatomic,strong)UIRefreshControl *refresh2;

//@property (nonatomic,strong) NSArray *mtDatas;

@property (nonatomic, assign) NSInteger time;


@end
@implementation homeVC
static NSString *iden = @"cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"迷祢News";
    //_dataArr = [NSMutableArray array];

    _itemsArr = @[@"科技",@"国际",@"体育",@"国内"];
    _time =1;

    
    //首先查询本地的数据，显示本地数据 ，网络数据请求到后，跟新为网络数据
    self.dataArr = [DataBaseEngine statusesFromDB];
    [self changeTableViewAndLoadData];
    

    
    [self createScrollViewAndTableViews];
    [self createItemsScrollView];
    [self wangluorequest];
    
  
    
    
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [_leftTableView addSubview:_refresh];

    _refresh1 = [[UIRefreshControl alloc] init];
    [_refresh1 addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [_middleTableView addSubview:_refresh1];
    
    _refresh2 = [[UIRefreshControl alloc] init];
    [_refresh2 addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [_rightTableView addSubview:_refresh2];
    
    

    self.leftTableView.estimatedRowHeight = 50;
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.middleTableView.estimatedRowHeight = 50;
    self.middleTableView.rowHeight = UITableViewAutomaticDimension;
    self.rightTableView.estimatedRowHeight = 50;
    self.rightTableView.rowHeight = UITableViewAutomaticDimension;
    self.currentTableView.estimatedRowHeight = 50;
    self.currentTableView.rowHeight = UITableViewAutomaticDimension;
    
    

}


- (UITableView *)currentTableView
{
    if (_currentTableView == nil) {
        _currentTableView = [[UITableView alloc] init];
    }
    return _currentTableView;
}


#pragma mark -网络请求1
- (void)wangluorequest
{
    NSString *url = [NSString stringWithFormat:@"http://api.avatardata.cn/TechNews/Query?key=dbbf73b2c7cc4bebb9f690b58f273997&page=1&rows=40"];
   NSString *url1 = [NSString stringWithFormat:@"http://api.avatardata.cn/WorldNews/Query?key=d0ddd2481e9d4e7295d50b304256fa7a&page=1&rows=40"];
    NSString *url2 = [NSString stringWithFormat:@"http://api.avatardata.cn/SportsNews/Query?key=ac66094654dc413c81672f4777321061&page=1&rows=40"];
    //NSString *url3 = [NSString stringWithFormat:@"http://api.avatardata.cn/QiWenNews/Query?key=c4378a1d1d6141bba659bc7818d0f55b&page=1&rows=40"];
//    NSString *url4 = [NSString stringWithFormat:@"http://api.avatardata.cn/TravelNews/Query?key=27e89e3be50b4a92a8575ed89f0c2fc5&page=1&rows=40"];
    NSString *url5 = [NSString stringWithFormat:@"http://api.avatardata.cn/GuoNeiNews/Query?key=d9679534492f44afba71004de40c84cb&page=1&rows=40"];

   
    NSArray *arry = @[url,url1,url2,url5];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:arry[_currentIndex] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //把请求的数据里的字典保存到数组
        NSArray *arr = responseObject[@"result"];
        NSMutableArray *resultArray = [NSMutableArray array];
        
        for (NSDictionary *dict in arr) {
            Model *model = [Model statusWithDictionary:dict];
            //NSLog(@"%@",model);
            [resultArray addObject:model];
        }
        if (!_dataArr) {
            _dataArr=[NSArray array];
        }
        
        self.dataArr = resultArray;
        //保存数据
        [DataBaseEngine saveStatus2DB:responseObject[@"result"]];
        
        [self changeTableViewAndLoadData];

        
        
        [_refresh endRefreshing];
        [_refresh1 endRefreshing];
        [_refresh2 endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"网络不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
       

        [_refresh endRefreshing];
        [_refresh1 endRefreshing];
        [_refresh2 endRefreshing];
    }];
}

#pragma mark 下啦刷新
- (void)loadData
{
    //科技新闻
    NSString *url = [NSString stringWithFormat:@"http://api.avatardata.cn/TechNews/Query?key=dbbf73b2c7cc4bebb9f690b58f273997&page=1&rows=20"];
    //国际新闻
    NSString *url1 = [NSString stringWithFormat:@"http://api.avatardata.cn/WorldNews/Query?key=d0ddd2481e9d4e7295d50b304256fa7a&page=1&rows=20"];
    //体育新闻
    NSString *url2 = [NSString stringWithFormat:@"http://api.avatardata.cn/SportsNews/Query?key=ac66094654dc413c81672f4777321061&page=1&rows=20"];
    //奇闻新闻
    //NSString *url3 = [NSString stringWithFormat:@"http://api.avatardata.cn/QiWenNews/Query?key=c4378a1d1d6141bba659bc7818d0f55b&page=1&rows=20"];
//    //旅游
//    NSString *url4 = [NSString stringWithFormat:@"http://api.avatardata.cn/TravelNews/Query?key=27e89e3be50b4a92a8575ed89f0c2fc5&page=1&rows=20"];
    //国内新闻
    NSString *url5 = [NSString stringWithFormat:@"http://api.avatardata.cn/GuoNeiNews/Query?key=d9679534492f44afba71004de40c84cb&page=1&rows=20"];
    NSArray *arry = @[url,url1,url2,url5];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:arry[_currentIndex] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //把请求到的数据先保存到数组
         NSArray *modelArry = responseObject[@"result"];
        //将数组中的字典转数组
       // NSMutableArray *result = [Model statusWithDictionary:modelArray];
        NSMutableArray *resultArray = [NSMutableArray array];
        [modelArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Model *model = [[Model alloc] initWithStatusDictionary:obj];
            [resultArray addObject:model];
        }];
        //新老数据合并，新数据在前面
        [resultArray addObjectsFromArray:self.dataArr];
        self.dataArr = resultArray;
        [self changeTableViewAndLoadData];
        
        //保存数据
        //[DataBaseEngine saveStatus2DB:responseObject[@"result"]];
        

        [_refresh endRefreshing];
        [_refresh1 endRefreshing];
        [_refresh2 endRefreshing];
        NSLog(@"下啦刷新新老数据合并完成");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"网络不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];

        NSLog(@"下啦刷新失败");
        [_refresh endRefreshing];
        [_refresh1 endRefreshing];
        [_refresh2 endRefreshing];
    }];
}

- (NSInteger)i
{
    self.i = 2;
    return _i;
}
//cell将要展示的方法
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //如果倒数第五条上啦加载更多
    if (self.dataArr.count-indexPath.row == 5) {
        //加载更多数据
        
        [self loadMore];
        _i=_i+1;
        
    }
}


- (void)loadMore
{
//    if (_i>=5) {
//        return;
//    }
    NSString *url = [NSString stringWithFormat:@"http://api.avatardata.cn/TechNews/Query?key=dbbf73b2c7cc4bebb9f690b58f273997&page=%ld&rows=40",(long)_i];
    
    NSString *url1 = [NSString stringWithFormat:@"http://api.avatardata.cn/WorldNews/Query?key=d0ddd2481e9d4e7295d50b304256fa7a&page=%ld&rows=40",_i+2];
    NSString *url2 = [NSString stringWithFormat:@"http://api.avatardata.cn/SportsNews/Query?key=ac66094654dc413c81672f4777321061&page=%ld&rows=40",_i+2];
    //NSString *url3 = [NSString stringWithFormat:@"http://api.avatardata.cn/QiWenNews/Query?key=c4378a1d1d6141bba659bc7818d0f55b&page=%ld&rows=40",_i+2];
    //NSString *url4 = [NSString stringWithFormat:@"http://api.avatardata.cn/TravelNews/Query?key=27e89e3be50b4a92a8575ed89f0c2fc5&page=%ld&rows=40",_i+2];
    NSString *url5 = [NSString stringWithFormat:@"http://api.avatardata.cn/GuoNeiNews/Query?key=d9679534492f44afba71004de40c84cb&page=%ld&rows=40",_i+2];
    
    
    NSArray *arry = @[url,url1,url2,url5];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:arry[_currentIndex] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //把请求到的数据保存到字典
        NSArray *moderray = responseObject[@"result"];
        //将数组里的字典全部转化为模型
        NSMutableArray *resultArray = [NSMutableArray array];
        [moderray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Model *model = [Model statusWithDictionary:obj];
            
            [resultArray addObject:model];
        }];
        //新老数据合并，老数据在前面
        NSMutableArray *mmArry = [NSMutableArray arrayWithArray:self.dataArr];
        [mmArry addObjectsFromArray:resultArray];
        self.dataArr = mmArry;

        [self changeTableViewAndLoadData];
        
        //保存数据
        //[DataBaseEngine saveStatus2DB:responseObject[@"result"]];
        

        [_refresh endRefreshing];
        [_refresh1 endRefreshing];
        [_refresh2 endRefreshing];
        NSLog(@"上啦加载更多成功啦啦啦");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"网络不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        
        [_refresh endRefreshing];
        [_refresh1 endRefreshing];
        [_refresh2 endRefreshing];
        NSLog(@"上啦加载更多失败啦啦啦啦®");
    }];
    

    
}

- (void)createItemsScrollView

{
    _itemsView = [[itermsScrollView alloc] initWithButtonsArr:_itemsArr];
    
    //控制器通过block块来获取index值的变化
    __weak homeVC *weakSelf = self;
    void (^changeValue)(NSInteger) = ^(NSInteger currentIndex){
        _currentIndex = currentIndex;
        [self wangluorequest];
        [weakSelf changeTableViewAndLoadData];
       
    };
    [_itemsView setValue:changeValue forKey:@"changeIndexValue"];
    
    [self.view addSubview:_itemsView];
}

- (void)changeTableViewAndLoadData
{
    //self.dataArr = [DataBaseEngine statusesFromDB];
    //index = 0 情况，只需要刷新左边tableView和中间tableView
    if (_currentIndex == 0) {
        _leftArr = self.dataArr;
        _middleArr = self.dataArr;
        [_leftTableView reloadData];
        [_middleTableView reloadData];
        self.tablesScrollView.contentOffset = CGPointMake(0, 0);
        
        //index 是为最后的下标时，刷新右边tableView 和 中间 tableView
    }else if(_currentIndex == _itemsArr.count - 1){
        _rightArr = self.dataArr;
        _middleArr = self.dataArr;
        [_rightTableView reloadData];
        [_middleTableView reloadData];
      
        self.tablesScrollView.contentOffset = CGPointMake(kScreenWidth*2, 0);
        
        //除了上边两种情况，三个tableView 都要刷新，为了左右移动时都能够显示数据
    }else{
        _rightArr = self.dataArr;
        _middleArr = self.dataArr;
        _leftArr = self.dataArr;
        [_rightTableView reloadData];
        [_middleTableView reloadData];
        [_leftTableView reloadData];
        
        self.tablesScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    }
    
    

    
}

//在ScrollView中创建三个tableView
- (void)createScrollViewAndTableViews
{
    _tablesScrollView = [[BigScrollView alloc] initBigScroll];
    _tablesScrollView.delegate = self;
    [self.view addSubview:_tablesScrollView];
    
    CGRect frame = _tablesScrollView.frame;
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-30) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    
    [_tablesScrollView addSubview:_leftTableView];
    
    frame.origin.x = kScreenWidth;
    _middleTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth,kScreenHeight-30) style:UITableViewStylePlain];
    _middleTableView.delegate = self;
    _middleTableView.dataSource = self;
    [_tablesScrollView addSubview:_middleTableView];
    
    frame.origin.x = 2*kScreenWidth;
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth,kScreenHeight-30) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    [_tablesScrollView addSubview:_rightTableView];
    
    //这里的contentOffset初始化为(0,0)
    _tablesScrollView.contentOffset = CGPointMake(0, 0);
    
    
}

//SrollView 的代理方法，停止滑动时，确定index 并且调用刷新 tableView 的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    

    if ([scrollView isEqual: _tablesScrollView]) {
        
        CGPoint point = _tablesScrollView.contentOffset;
        //当ScrollView的contentOffSet的偏移量从 kScreenWidth 到 2*kScreenWidth 的情况
        if(point.x > _tablesScrollView.frame.size.width){
            
            _currentIndex +=1;
            if (_currentIndex > _itemsArr.count - 1) {
                _currentIndex = _itemsArr.count - 1;
            }
            [self wangluorequest];
            [self changeTableViewAndLoadData];
            //自动滚动到顶部
           [_currentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //当ScrollView的contentOffSet 的偏移量从 kScreenWidth 到 0 时的情况
        }else if(point.x == 0){
            
            _currentIndex -=1;
            if (_currentIndex < 0) {
                _currentIndex = 0;
            }
            
            
            [self wangluorequest];
            [self changeTableViewAndLoadData];
            //自动滚动到顶部
            [_currentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

            
        }
        //当下标为0，并且当ScrollView的contentOffSet 的偏移量从 0 到 kScreenWidth 的情况
        if (point.x == kScreenWidth && _currentIndex == 0){
            _currentIndex ++;
            
            [self wangluorequest];
            [self changeTableViewAndLoadData];
            //自动滚动到顶部
            [_currentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        //当下标为最后一个时，并且ScrollView 的ContentOffSet 的偏移量 从 2*kScreenWidth 到 kScreenWidth 的情况
        if (point.x == kScreenWidth && _currentIndex == _itemsArr.count-1) {
            _currentIndex --;
            [self wangluorequest];
            [self changeTableViewAndLoadData];
            //自动滚动到顶部
            [_currentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    }
    
    _itemsView.index = _currentIndex;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_leftTableView]) {
        return  _leftArr.count;
   }else if([tableView isEqual:_middleTableView]){
        return _middleArr.count;
    }
    return _rightArr.count;

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
   
    ModelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ModelCell class]) owner:self options:nil][0];
            }
    
    if (tableView == self.leftTableView) {
         NSUInteger row = indexPath.row % self.dataArr.count;
        self.currentTableView = _leftTableView;
        [cell bangdingStatus:self.dataArr[row]];
        
    }else if(tableView == self.middleTableView){
         NSUInteger row = indexPath.row % self.dataArr.count;
        self.currentTableView = _middleTableView;
        [cell bangdingStatus:self.dataArr[row]];
    }else{
         NSUInteger row = indexPath.row % self.dataArr.count;
        self.currentTableView = self.rightTableView;
        [cell bangdingStatus:self.dataArr[row]];
    }
    return cell;

    
}


//点击cell事件的响应方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        Model *model = self.dataArr[indexPath.row];

        NSURL *url = [[NSURL alloc] initWithString:model.url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        UIWebView *webView = [[UIWebView alloc] init];
        [webView loadRequest:request];
        webView.delegate = self;
        webView.opaque = YES;
        
        homeVC *viewControll = [[homeVC alloc] init];
        [viewControll setView:webView];
        
        [self.navigationController pushViewController:viewControll animated:YES];
    
}


//将要出现时
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //从网路获取数据
    [self wangluorequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end


