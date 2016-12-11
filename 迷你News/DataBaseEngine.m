//
//  DBOperationManager.m
//  迷你News
//
//  Created by qingyun on 16/3/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#define DataBaseName @"status.db"
#define TableName @"status"


#import "DataBaseEngine.h"
#import "Header.h"
#import "FMDB.h"
#import "Model.h"
#import "Model.h"
@interface DataBaseEngine ()
@end

@implementation DataBaseEngine

static NSArray *statusTableColumn;

//类的初始化方法
+(void)initialize{
    if (self == [DataBaseEngine class]) {
        //将数据库copy到Documents文件夹下
        [DataBaseEngine copyDB2Documents];
        
        //查找出表中的所有字段
        statusTableColumn = [DataBaseEngine tableColumn:TableName];
    }
}

+(void)copyDB2Documents{
    NSString *source = [[NSBundle mainBundle] pathForResource:DataBaseName ofType:nil];
    NSString *toPath = [DataBaseEngine dataBasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果Document下文件不存在，将mainBundel中的数据库copy，作为创建的数据库。
    if (![fileManager fileExistsAtPath:toPath]) {
        [fileManager copyItemAtPath:source toPath:toPath error:nil];
    }
}

//数据库的路径
+(NSString *)dataBasePath{
    NSString *documentspath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //追加文件的名字
    return [documentspath stringByAppendingPathComponent:DataBaseName];
    
}


//获取表中的所有字段
+(NSArray *)tableColumn:(NSString *)tableName{
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:[DataBaseEngine dataBasePath]];
    //打开数据库
    [db open];
    //执行查询
    FMResultSet *result = [db getTableSchema:tableName];
    NSMutableArray *columnArray = [NSMutableArray array];
    while ([result next]) {
        NSString *column = [result objectForColumnName:@"name"];
        [columnArray addObject:column];
    }
    
    [db close];
    
    return columnArray;
    
}
//从两个数组中找出交集
+(NSArray *)resultWithArray1:(NSArray *)array1 Array2:(NSArray *)array2{
    NSMutableArray *result = [NSMutableArray array];
    //遍历数组中的每一个对象
    [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //如果另外一个数组也包含相同的对象，则为共有的对象
        if ([array2 containsObject:obj]) {
            [result addObject:obj];
        }
    }];
    
    return result;
}

+(NSString *)creatSQLStringWithKey:(NSArray *)keys{
    //字段的拼接
    NSString *columnsString = [keys componentsJoinedByString:@", "];
    //占位字符串
    NSString *valuesString = [keys componentsJoinedByString:@", :"];
    valuesString = [@":"stringByAppendingString:valuesString];
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", TableName, columnsString, valuesString];
    return sql;
}

+(void)saveStatus2DB:(NSArray *)statuses{
    //FMDB提供的多线程GCD实现，异步派发的串行队列
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataBaseEngine dataBasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        for (int i = 0; i < statuses.count; i++) {
            
            NSDictionary *status = [statuses objectAtIndex:i];
            
            NSArray *allkey = status.allKeys;
            
            //本地数据库中包含的字段，并且服务器返回的字典也包含的字段
            NSArray *contentKeys = [DataBaseEngine resultWithArray1:statusTableColumn Array2:allkey];
            
            //插入语句
            NSString *sqlString = [DataBaseEngine creatSQLStringWithKey:contentKeys];
            
            //准备插入的字典
            NSMutableDictionary *insertDic = [NSMutableDictionary dictionary];
            //根据要插入的字段，构造字典
            [contentKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id value = [status objectForKey:obj];
                //如果是字典或者数组，归档为二进制数据再保存
                if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                    value = [NSKeyedArchiver archivedDataWithRootObject:value];
                }
                
                //构造新的字典
                [insertDic setObject:value forKey:obj];
            }];
            
            //执行插入
            BOOL result = [db executeUpdate:sqlString withParameterDictionary:insertDic];
            NSLog(@"%d", result);
        }
    }];
}

#pragma mark - read from DB
+(NSArray *)statusesFromDB{
    //从数据库中查询
    FMDatabase *db = [FMDatabase databaseWithPath:[DataBaseEngine dataBasePath]];
    [db open];
    
    //以id排序降序，查询结果限制20条
    NSString *sqlString = @"select * from status limit 20";
    //执行查询
    FMResultSet *result = [db executeQuery:sqlString];
    
    NSMutableArray *modelsArray = [NSMutableArray array];
    while ([result next]) {
        //将一条记录转化为一个字典
        NSDictionary *dic = result.resultDictionary;
        
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //将结果中的二进制数据解档，还原为原来的对象
            if ([obj isKindOfClass:[NSData class]]) {
                id value = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                [muDic setObject:value forKey:key];
            }
            //删除null类型的值
            if ([obj isKindOfClass:[NSNull class]]) {
                [muDic removeObjectForKey:key];
            }
        }];
        
        //将字典转化为model
        Model *status = [[Model alloc] initWithStatusDictionary:muDic];
        [modelsArray addObject:status];
    }
    
    return modelsArray;
}



@end
