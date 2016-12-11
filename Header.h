//
//  Header.h
//  迷你News
//
//  Created by qingyun on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#ifndef Header_h
#define Header_h

//第三方库
#import "AFNetworking.h"
#import "FMDatabase.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>




#define UIColorRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define UIColorRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];

//SmallScrollView's button's width
#define kButtonWidth    [UIScreen mainScreen].bounds.size.width/4

//数据库存储名称
#define DBFILE @"shujv.db"


#endif /* Header_h */
