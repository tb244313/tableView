//
//  URLanalysis.m
//  迷你News
//
//  Created by qingyun on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "URL.h"
#import "findVC.h"
@implementation URL

- (NSString *)urlGaoXiao
{
    _urlGaoXiao = [NSString stringWithFormat:@"http://api.sina.cn/sinago/list.json?uid=41ecde5c80c03620&loading_ad_timestamp=0&platfrom_version=4.4.2&wm=b207&oldchwm=15006_0001&imei=866654027822656&from=6049295012&connection_type=2&chwm=15006_0001&AndroidID=fb6e0feb1aeb3506cd64d8381c55d7b8&v=1&s=20&IMEI=1f58224c5955957d5ef3dcec38381d6b&p=%ld&user_uid=5105428043&MAC=9fa67d2a76274f8764d05d3a78ed0763&channel=news_funny",self.GXtimes];
    return _urlGaoXiao;
}


@end
