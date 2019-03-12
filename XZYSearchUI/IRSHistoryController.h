//
//  IRSHistoryController.h
//  IRSerchant
//
//  Created by ziyuan_Xu on 2018/3/18.
//  Copyright © 2018年 Hainan Full Street Industrial Co., Ltd. All rights reserved.
//
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define kBottomSaveHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)
#define  kIRSColorBackground  [UIColor redColor]
#define  kIRSColorTextDark   [UIColor blueColor]

#import <UIKit/UIKit.h>
@class IRSHistoryController;
@protocol HistoryControllerDelegate <NSObject>
@required
- (void)historyController:(IRSHistoryController *)controller didSelectItemText:(NSString *)text;
@end

@interface IRSHistoryController : UIViewController
@property (weak,nonatomic) id<HistoryControllerDelegate> delegate;

@end


@interface IRSCollectionHeadCell : UICollectionReusableView
- (void)cancelHistory:(void (^)(void))cancelBlcok;
@end


@interface IRSSearchCell : UICollectionViewCell
@property (nonatomic,copy)NSString *content;
@end
