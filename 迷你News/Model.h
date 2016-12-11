//
//  Model.h
//  迷你News
//
//  Created by qingyun on 16/3/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic,strong)NSString *ctime;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSString *picUrl;
@property (nonatomic,strong)NSString *url;


-(instancetype)initWithStatusDictionary:(NSDictionary *)info;

+(instancetype)statusWithDictionary:(NSDictionary *)info;



@end
