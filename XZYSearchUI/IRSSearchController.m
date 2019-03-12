//
//  IRSSearchController.m
//  IRiverSystem
//
//  Created by xuziyuan on 2018/12/12.
//  Copyright © 2018 XiePu Tec Co.,Ltd. All rights reserved.
//

#import "IRSSearchController.h"
#import "IRSHistoryController.h"
typedef UIViewController<IRSSearchResultProtocol> *(^ResultControllerBlock)(void);
@interface IRSSearchController ()<UITextFieldDelegate,HistoryControllerDelegate>
{
    UIViewController *_currentController;
}
@property (copy,nonatomic)ResultControllerBlock resultControllerBlock;
@property (copy,nonatomic)NSString *placeholder;
@property (strong, nonatomic)UITextField *searchTextField;

@property (strong, nonatomic)UIViewController <IRSSearchResultProtocol>*resultController;
@property (strong, nonatomic)IRSHistoryController *historyController;
@end

@implementation IRSSearchController

+ (IRSSearchController *)initWithPlaceholder:(NSString *)placeholder andResultController:(UIViewController<IRSSearchResultProtocol> *(^)(void))resultControllerBlock{
    return [[self alloc] initWithPlaceholder:placeholder andResultController:resultControllerBlock];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder andResultController:(UIViewController *(^)(void))resultControllerBlock{
    self = [super init];
    if (!self) return nil;
    _resultControllerBlock = resultControllerBlock;
    _placeholder = placeholder;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    [self addChildViewController:self.historyController];
    [self didMoveToParentViewController:self];
    
    _currentController = self.historyController;
    [self.view addSubview:_currentController.view];
    
}

- (IRSHistoryController *)historyController{
    if (!_historyController) {
        _historyController = [[IRSHistoryController alloc] init];
        [_historyController.view setFrame:CGRectMake(0, kTopHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTopHeight)];
        _historyController.delegate = self;
    }
    return _historyController;
}

- (UIViewController <IRSSearchResultProtocol>*)resultController{
    if (!_resultController) {
        _resultController = self.resultControllerBlock ?self.resultControllerBlock() :nil;
        [_resultController.view setFrame:CGRectMake(0, kTopHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTopHeight)];
    }
    return _resultController;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)setupNavBar{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 7.0f +kStatusBarHeight, 40, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kIRSColorTextDark forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cancelBtn addTarget:self action:@selector(backPop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIView *searchView = [UIView new];
    [searchView setFrame:CGRectMake(10, 7.0f +kStatusBarHeight, [UIScreen mainScreen].bounds.size.width-80, 30)];
    searchView.backgroundColor = kIRSColorBackground;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 3.0f;
    [self.view addSubview:searchView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"river_search"]];
    [searchImageView setFrame:CGRectMake(10, 7.5, 15, 15)];
    [searchView addSubview:searchImageView];
    
    self.searchTextField = [UITextField new];
    [self.searchTextField setFrame:CGRectMake(30, 2,  [UIScreen mainScreen].bounds.size.width-80-30, 26)];

    self.searchTextField.delegate = self;
    [self.searchTextField setFont:[UIFont systemFontOfSize:12.0f]];
    [self.searchTextField setPlaceholder:self.placeholder];
    [self.searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.searchTextField becomeFirstResponder];
    [self.searchTextField setReturnKeyType:UIReturnKeySearch];
    [searchView addSubview:self.searchTextField];

}

- (void)backPop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (!(textField.text.length>0)) return NO;
    [self insetHistorysText:textField.text];
    self.resultController.keyword = textField.text;
    if ([_currentController isMemberOfClass:[IRSHistoryController class]]) {
        [self changeControllerFromOldController:self.historyController toNewController:self.resultController];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (![_currentController isMemberOfClass:[IRSHistoryController class]]) {
        [self changeControllerFromOldController:self.resultController toNewController:self.historyController];
    }
}


- (void)changeControllerFromOldController:(UIViewController *)oldController toNewController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    /**
     *  切换ViewController
     */
    __weak IRSSearchController *weakself = self;
    [self transitionFromViewController:oldController toViewController:newController duration:0.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        __strong IRSSearchController *strongself = weakself;
        if (finished) {
            //移除oldController，但在removeFromParentViewController：方法前不会调用willMoveToParentViewController:nil 方法，所以需要显示调用
            [newController didMoveToParentViewController:strongself];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            strongself->_currentController = newController;
            
        }else {
            strongself->_currentController = oldController;
        }
    }];
}

- (void)historyController:(IRSHistoryController *)controller didSelectItemText:(NSString *)text{
    [self insetHistorysText:text];
    self.searchTextField.text = text;
    self.resultController.keyword = text;
    [self.searchTextField resignFirstResponder];
    if ([_currentController isMemberOfClass:[IRSHistoryController class]]) {
        [self changeControllerFromOldController:self.historyController toNewController:self.resultController];
    }
}

- (void)insetHistorysText:(NSString *)text{
    NSMutableArray *historys = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"HISTORY_SEARCH"]];
    if ([historys containsObject:text]) {
        [historys removeObject:text];
        [historys addObject:text];
    }else{
        if (historys.count==10) [historys removeObjectAtIndex:0];
        [historys addObject:text];
    }
    [[NSUserDefaults standardUserDefaults] setObject:historys forKey:@"HISTORY_SEARCH"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc{
//    GDDLog(@"IRSSearchController :::dealloc");
}
@end
