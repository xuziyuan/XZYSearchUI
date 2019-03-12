//
//  IRSSearchController.h
//  IRiverSystem
//
//  Created by xuziyuan on 2018/12/12.
//  Copyright © 2018 XiePu Tec Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IRSSearchResultProtocol <NSObject>
@required
@property (copy,nonatomic)NSString *keyword;

@end

NS_ASSUME_NONNULL_BEGIN

@interface IRSSearchController : UIViewController
/**
 搜索界面
 
 @param placeholder 搜索框占位符
 @param resultControllerBlock 返回一个符合IRSSearchResultProtocol协议的UIViewController
 @return 搜索UIViewController
 */
+ (IRSSearchController *)initWithPlaceholder:(NSString *)placeholder andResultController:(UIViewController<IRSSearchResultProtocol> *(^)(void))resultControllerBlock;
@end

NS_ASSUME_NONNULL_END
