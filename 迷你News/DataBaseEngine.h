//
//  DBOperationManager.h
//  迷你News
//
//  Created by qingyun on 16/3/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseEngine : NSObject


//把网络请求的微博保存，在打开应用的时候，首先显示本地缓存的数据；在没有网络的时候，显示本地缓存的数据
+(void)saveStatus2DB:(NSArray *)statuses;

//从本地读取数据
+(NSArray *)statusesFromDB;


@end
