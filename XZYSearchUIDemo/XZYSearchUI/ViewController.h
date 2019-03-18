//
//  ViewController.h
//  XZYSearchUI
//
//  Created by xuziyuan on 2019/3/11.
//  Copyright © 2019 XiePu Tec Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRSSearchController.h"
@interface ViewController : UIViewController<IRSSearchResultProtocol>

@property (copy,nonatomic)NSString *keyword;

@end

