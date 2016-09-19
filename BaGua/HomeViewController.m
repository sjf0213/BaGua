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
@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView* mainTable;
@property (strong, nonatomic) NSMutableArray* dataList;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = [NSMutableArray array];
    __weak typeof(self) wself = self;
    
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
    self.mainTable.rowHeight = 40;
    [self.mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeCell"];
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
            NSArray* list = result[@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                for (NSDictionary* dic in list) {
                    NSDictionary* item = @{@"id":   dic[@"id"],
                                           @"text": dic[@"text"]};
                    [self.dataList addObject:item];
                }
            }
            DLog(@"---DATA List---count:%zd, %@",self.dataList.count, self.dataList);
            [self.mainTable reloadData];
        }else{
            DLog(@"--error.code = %zd, description = %@", error.code, [error localizedDescription]);
        }
        [self.mainTable.mj_header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    NSDictionary* item = self.dataList[indexPath.row];
    cell.textLabel.text = item[@"text"];
    return cell;
    
}

@end
