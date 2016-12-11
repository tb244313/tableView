//
//  URLanalysis.h
//  迷你News
//
//  Created by qingyun on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URL : NSObject
@property (nonatomic, strong) NSString *urlTouTiao;
@property (nonatomic, strong) NSString *urlTuiJian;
@property (nonatomic, strong) NSString *urlYuLe;
@property (nonatomic, strong) NSString *urlSheHui;
@property (nonatomic, strong) NSString *urlTiYu;
@property (nonatomic, strong) NSString *urlNBA;
@property (nonatomic, strong) NSString *urlCaiJing;
@property (nonatomic, strong) NSString *urlQiChe;
@property (nonatomic, strong) NSString *urlKeJi;
@property (nonatomic, strong) NSString *urlYouXi;
@property (nonatomic, strong) NSString *urlJiaoYu;
@property (nonatomic, strong) NSString *urlGaoXiao;
@property (nonatomic, strong) NSString *urlBaGua;
@property (nonatomic, strong) NSString *urlJianKang;
@property (nonatomic, strong) NSString *urlShiShang;
@property (nonatomic, strong) NSString *urlLiShi;
@property (nonatomic, strong) NSString *urlShouCang;
@property (nonatomic, strong) NSString *urlJiaJu;
@property (nonatomic, strong) NSString *urlBoKe;
@property (nonatomic, strong) NSString *urlXingZuo;
@property (nonatomic, strong) NSString *urlNvXing;

@property (nonatomic, strong) NSArray *pathArr;

@property (nonatomic,assign) NSInteger times;
@property (nonatomic,assign) NSInteger GXtimes;

- (NSString *)urlGaoXiao;


@end
