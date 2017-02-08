//
//  ViewController.m
//  MaoYanLoadingRefresh
//
//  Created by APPLE on 17/2/8.
//  Copyright © 2017年 David. All rights reserved.
//

#import "ViewController.h"
#import "RefreshHeader.h"

#import "LoadingView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) RefreshHeader *header;

@property (nonatomic, strong) NSMutableArray *temDatas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.mj_header = self.header;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    }
    return _mainTableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            [_datas addObject:[NSString stringWithFormat:@"测试数据--%d", i]];
        }
    }
    return _datas;
}

- (NSMutableArray *)temDatas {
    if (!_temDatas) {
        _temDatas = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            [_temDatas addObject:[NSString stringWithFormat:@"新增测试数据--%d", i]];
        }
    }
    return _temDatas;
}

- (RefreshHeader *)header {
    if (!_header) {
        _header = [RefreshHeader headerWithRefreshingBlock:^{
            [_header beginRefreshing];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //添加数据
                [self.datas arrayByAddingObjectsFromArray:self.temDatas];
                
                [_header endRefreshing];
            });
        }];
    }
    return _header;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

@end
