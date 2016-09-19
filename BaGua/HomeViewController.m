//
//  HomeViewController.m
//  BaGua
//
//  Created by 宋炬峰 on 16/9/12.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "HomeViewController.h"
#import "BGEngine.h"
#import "MJRefresh.h"
@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UITableView* mainTable;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wself = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself startRequest];
    }];
    
    // 马上进入刷新状态
    [self.mainTable.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRequest
{
    
    [BGEngine homepageByParam:nil contentWithBlock:^(NSDictionary *result, NSError *error) {
        if (nil == error) {
            DLog(@"---Home List---%@",result);
            
        }else{
            DLog(@"--error.code = %zd, description = %@", error.code, [error localizedDescription]);
            
        }
        [self.mainTable.mj_header endRefreshing];
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
