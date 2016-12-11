//
//  centerVC.m
//  迷你News
//
//  Created by qingyun on 16/3/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "centerVC.h"

@interface centerVC ()<UIWebViewDelegate>

@end

@implementation centerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0 && indexPath.row ==1) {
        UIAlertController *alertController = [[UIAlertController alloc] init];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:OK];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (indexPath.section == 0 &&indexPath.row ==2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"欢迎使用迷祢News" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *ok1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [alert addAction:ok1];
        [self presentViewController:alert animated:YES completion:nil];
    }
        if (indexPath.section ==1 && indexPath.row==0) {
            
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"需要进入下载中心吗" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cn.bing.com"]];
                UIWebView *web = [[UIWebView alloc] init];
                web.delegate = self;
                NSURL *url = [NSURL URLWithString:@"http://cn.bing.com"];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [web loadRequest:request];
                web.opaque = YES;
                centerVC *viewController = [[centerVC alloc] init];
                [viewController setView:web];
                [self.navigationController pushViewController:viewController animated:YES];
            }];
            UIAlertAction *ok1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:ok];
            [alert addAction:ok1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    
    if (indexPath.section ==1&&indexPath.row ==1) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"需要进入反馈中心吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIWebView *web = [[UIWebView alloc] init];
            web.delegate = self;
            NSURL *url = [NSURL URLWithString:@"http://www.zcool.com.cn/work/ZMjQzOTQxMg==.html"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [web loadRequest:request];
            web.opaque = YES;
            centerVC *viewController = [[centerVC alloc] init];
            [viewController setView:web];
            [self.navigationController pushViewController:viewController animated:YES];
            
        }];
        
        UIAlertAction *ok1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [alert addAction:ok1];
        [self presentViewController:alert animated:YES completion:nil];
        

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
