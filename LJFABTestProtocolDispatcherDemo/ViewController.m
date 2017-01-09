//
//  ViewController.m
//  LJFABTestProtocolDispatcherDemo
//
//  Created by f.li on 17/1/6.
//  Copyright © 2017年 lijianfei. All rights reserved.
//

#import "ViewController.h"
#import "UITableViewDelegateDataSource_A.h"
#import "UITableViewDelegateDataSource_B.h"
#import "LJFABTestProtocolDispatcher.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewDelegateDataSource_A *delegateSource_A;
@property (nonatomic, strong) UITableViewDelegateDataSource_B *delegateSource_B;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    
    self.delegateSource_A = [UITableViewDelegateDataSource_A new];
    self.delegateSource_B = [UITableViewDelegateDataSource_B new];
    
    // A = 0
    // B = 1
    NSUInteger type = 1;
    
    self.tableView.delegate = ABTestProtocolDispatcher(UITableViewDelegate,
                                                   @(type),
                                                   self.delegateSource_A,
                                                   self.delegateSource_B);
    
    self.tableView.dataSource = ABTestProtocolDispatcher(UITableViewDataSource,
                                                     @(type),
                                                     self.delegateSource_A,
                                                     self.delegateSource_B);

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
