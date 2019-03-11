//
//  HFSMEqualSpaceFlowLayout.h
//  HFSMerchant
//
//  Created by ziyuan_Xu on 2018/3/13.
//  Copyright © 2018年 Hainan Full Street Industrial Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IRSEqualSpaceFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>
@end

@interface IRSEqualSpaceFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<IRSEqualSpaceFlowLayoutDelegate> delegate;
@end  
