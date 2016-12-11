//
//  ViewController.m
//  迷你News
//
//  Created by qingyun on 16/3/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "GuideVC.h"
#import "AppDelegate.h"

@interface GuideVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;

@end

@implementation GuideVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollerView.delegate = self;
}

- (IBAction)buttonClick:(UIButton *)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    //切换控制器
    [delegate guideEnd];
}


//拖拽结束，开始减速
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //不减速，滚动结束
    if (!decelerate) {
        self.pageView.currentPage = self.scrollerView.contentOffset.x/self.view.frame.size.width;
    }

}

//减速结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageView.currentPage = self.scrollerView.contentOffset.x/self.view.frame.size.width;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
