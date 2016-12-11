//
//  Model.m
//  迷你News
//
//  Created by qingyun on 16/3/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "Model.h"

@implementation Model

-(instancetype)initWithStatusDictionary:(NSDictionary *)info
{
    if (self = [super init]) {
       //创建时间
        self.ctime = info[@"ctime"];
        self.title = info[@"title"];
        self.desc = info[@"description"];
        self.picUrl = info[@"picUrl"];
        self.url = info[@"url"];
     }
    return self;
}

+(instancetype)statusWithDictionary:(NSDictionary *)info
{
    return [[self alloc] initWithStatusDictionary:info];
}

@end
