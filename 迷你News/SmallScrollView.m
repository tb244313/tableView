//
//  SmallScrollView.m
//  UI-app运动
//
//  Created by qingyun on 16/1/20.
//  Copyright (c) 2016年 qingyun. All rights reserved.
//

#import "SmallScrollView.h"
#import "QYScreen.h"

#define kButtonWidth  [UIScreen mainScreen].bounds.size.width/5

@interface SmallScrollView()

@property (nonatomic, strong) NSArray *buttonsArr;
@property (nonatomic, strong) UIView *slidView;//滑动的视图
@end

@implementation SmallScrollView
- (instancetype)initWithButtonsArr:(NSArray *)arr
{
    if (self = [super init]) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.frame = CGRectMake(0,0, kScreenWidth, 40);
        self.contentSize = CGSizeMake(arr.count*kButtonWidth,0);
        self.backgroundColor = [UIColor colorWithRed:245.0/255 green:255.0/255 blue:250.0/255 alpha:1];
        
        self.selectedColor = [UIColor redColor];
        
        [self createSlidView];
        
        //创建ScrollView上的所有Button
        NSMutableArray *muArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kButtonWidth*i,0, kButtonWidth, 40);
            [self addSubview:button];
            
            //设置button上的内容
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
            
            //设置button的tag值
            button.tag = 100 + i;
            
            [button addTarget:self action:@selector(buttonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [muArr addObject:button];
        }
        self.buttonsArr = muArr;
        self.index = 0;
        
    }
    return self;
}

//创建滑动的视图
- (void)createSlidView
{
    _slidView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, kButtonWidth, 2)];
    _slidView.backgroundColor = [UIColor redColor];
    [self addSubview:_slidView];
    
}
- (void)buttonIsClicked:(UIButton *)button
{
    self.index = button.tag - 100;
    //block的回调，当Item的index发生变化时，将index的传给控制器
    if (_changeIndexValue) {
        _changeIndexValue(_index);
    }
}

- (void)setIndex:(NSInteger)index
{
    //给上一个button设置未选中状态
    
    UIButton *notSelctedButton = _buttonsArr[_index];
    notSelctedButton.selected = NO;
    
    UIButton *selectedButton = _buttonsArr[index];
    selectedButton.selected = YES;
    
    //设置选中的button居中
    CGFloat offSetX = selectedButton.frame.origin.x - kScreenWidth/2;
    offSetX = offSetX > 0 ? (offSetX + kButtonWidth/2):0;
    offSetX = offSetX > self.contentSize.width - kScreenWidth ? self.contentSize.width - kScreenWidth : offSetX;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentOffset = CGPointMake(offSetX, 0);
        
    }];
    
    //设置滑动视图的偏移
    _index = index;
    CGRect frame = _slidView.frame;
    frame.origin.x = _index*kButtonWidth;
    [UIView animateWithDuration:0.3 animations:^{
        _slidView.frame = frame;
    }];
    
}



@end
