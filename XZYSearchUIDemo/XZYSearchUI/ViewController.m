//
//  ViewController.m
//  XZYSearchUI
//
//  Created by xuziyuan on 2019/3/11.
//  Copyright © 2019 XiePu Tec Co.,Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rigtItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem = rigtItem;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;

}

- (void)searchAction:(id)sender{
    IRSSearchController *searchController = [IRSSearchController initWithPlaceholder:@"搜索河道" andResultController:^UIViewController<IRSSearchResultProtocol> * _Nonnull{
        ViewController *viewController = [[ViewController alloc] init];
        return viewController;
    }];
    [self.navigationController pushViewController:searchController animated:YES];
}

- (void)setKeyword:(NSString *)keyword{
    
}
@end
