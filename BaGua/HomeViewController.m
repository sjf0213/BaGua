//
//  HomeViewController.m
//  BaGua
//
//  Created by 宋炬峰 on 16/9/12.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "HomeViewController.h"
#import "BGEngine.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRequest
{
    typeof(self) __weak wself = self;
    
    // 请求推荐应用列表
    NSURLSessionTask* task = [BGEngine homepageByParam:nil contentWithBlock:^(NSDictionary *result, NSError *error) {
        if (nil == error) {
            DLog(@"---Home List---%@",result);
            
        }else{
            DLog(@"--error.code = %zd, description = %@", error.code, [error localizedDescription]);
            
        }
    }];
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
