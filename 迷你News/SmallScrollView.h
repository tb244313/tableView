//
//  SmallScrollView.h
//  UI-app运动
//
//  Created by qingyun on 16/1/20.
//  Copyright (c) 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallScrollView : UIScrollView

@property (nonatomic) NSInteger index;
@property (nonatomic)int currentIndex;
@property (nonatomic, strong)UIColor *selectedColor;
@property (nonatomic, strong)void (^changeIndexValue)(NSInteger);

- (instancetype)initWithButtonsArr:(NSArray *)arr;


@end
