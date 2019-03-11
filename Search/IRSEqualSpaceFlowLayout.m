//
//  HFSMEqualSpaceFlowLayout.m
//  HFSMerchant
//
//  Created by ziyuan_Xu on 2018/3/13.
//  Copyright © 2018年 Hainan Full Street Industrial Co., Ltd. All rights reserved.
//

#import "IRSEqualSpaceFlowLayout.h"
@interface IRSEqualSpaceFlowLayout()
@property (nonatomic, strong)NSMutableArray *itemAttributes;
@end  
@implementation IRSEqualSpaceFlowLayout
#pragma mark - Methods to Override
- (void)prepareLayout{
    [super prepareLayout];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:0];
    NSInteger sectionCount = [[self collectionView] numberOfSections];
    for (NSInteger i=0; i<sectionCount; i++) {
        NSInteger itemCount = [[self collectionView] numberOfItemsInSection:i];
        CGFloat xOffset = self.sectionInset.left;
        CGFloat yOffset = self.sectionInset.top + 34;
        CGFloat xNextOffset = self.sectionInset.left;
        for (NSInteger idx = 0; idx < itemCount; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            
            xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
            if (xNextOffset > [self collectionView].bounds.size.width - self.sectionInset.right) {
                xOffset = self.sectionInset.left;
                xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
                yOffset += (itemSize.height + self.minimumLineSpacing);
            }else{
                xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
            }
            
            UICollectionViewLayoutAttributes *layoutAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
            [_itemAttributes addObject:layoutAttributes];
        }
        CGSize sectionSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:i];
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:i]];
        layoutAttributes.frame = CGRectMake(0, 0, sectionSize.width, sectionSize.height);
        [_itemAttributes addObject:layoutAttributes];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

@end
