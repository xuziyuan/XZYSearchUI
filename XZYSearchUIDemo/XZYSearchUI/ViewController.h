//
//  ViewController.h
//  XZYSearchUI
//
//  Created by xuziyuan on 2019/3/11.
//  Copyright © 2019 中移物联网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRSSearchController.h"
@interface ViewController : UIViewController<IRSSearchResultProtocol>

@property (copy,nonatomic)NSString *keyword;

@end

