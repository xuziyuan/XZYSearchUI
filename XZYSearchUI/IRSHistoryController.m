//
//  IRSHistoryController.m
//  IRSerchant
//
//  Created by ziyuan_Xu on 2018/3/18.
//  Copyright © 2018年 Hainan Full Street Industrial Co., Ltd. All rights reserved.
//

#import "IRSHistoryController.h"
#import "IRSEqualSpaceFlowLayout.h"
@interface IRSHistoryController ()<UICollectionViewDelegate,UICollectionViewDataSource,IRSEqualSpaceFlowLayoutDelegate>
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong,nonatomic)NSMutableArray *titleKeys;
@end

@implementation IRSHistoryController
static NSString *const cellId = @"IRSSearchCell";
static NSString *const headerId = @"IRSCollectionHeadCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.titleKeys removeAllObjects];
    NSArray *historys = [[NSUserDefaults standardUserDefaults] objectForKey:@"HISTORY_SEARCH"];
    [historys enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.titleKeys addObject:obj];
    }];
    [self.collectionView reloadData];
}

- (NSMutableArray *)titleKeys{
    if (!_titleKeys) {
        _titleKeys = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _titleKeys;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        IRSEqualSpaceFlowLayout *flowLayout = [[IRSEqualSpaceFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[IRSSearchCell class] forCellWithReuseIdentifier:cellId];
        [_collectionView registerClass:[IRSCollectionHeadCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark --UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleKeys.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IRSSearchCell *cell = (IRSSearchCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.content = self.titleKeys[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (self.titleKeys.count == 0) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }else{
        __block IRSCollectionHeadCell *headCell = (IRSCollectionHeadCell *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        [headCell cancelHistory:^{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HISTORY_SEARCH"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.titleKeys removeAllObjects];
            [self.collectionView reloadData];
            headCell.hidden =  YES;
        }];
        return headCell;
    }
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(historyController:didSelectItemText:)]) {
        [self.delegate historyController:self didSelectItemText:(NSString *)self.titleKeys[indexPath.item]];
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = self.titleKeys[indexPath.item];
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(120, 12)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]}
                                               context:nil].size;
    return CGSizeMake(contentSize.width +20, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return section ==0 ?CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 34) :CGSizeZero;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

@end

typedef void (^CancelBlock)(void);

@interface IRSCollectionHeadCell ()
@property (nonatomic,copy)CancelBlock cancelBlock;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *imageView;
@end
@implementation IRSCollectionHeadCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createBasicView];
    }
    return self;
    
}

- (void)createBasicView{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorNamed:@""];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleLabel.text = @"历史搜索";
    [self addSubview:self.titleLabel];
    
    
    self.imageView = [UIView new];
    self.imageView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"order_del"].CGImage);
    UIGestureRecognizer *gestureRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
    [self.imageView addGestureRecognizer:gestureRecoginzer];

    [self addSubview:self.imageView];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [self.titleLabel setFrame:CGRectMake(10, 0, self.bounds.size.width-10, self.bounds.size.height)];
    [self.imageView setFrame:CGRectMake(0, self.bounds.size.width-35, 20, 20)];
    [super layoutSubviews];
}

- (void)cancelHistory:(void (^)(void))cancelBlcok{
    self.cancelBlock = cancelBlcok;
}

- (void)handleActionForTapGesture:(UIGestureRecognizer *)ges{
    self.cancelBlock?self.cancelBlock():nil;
}
@end

@interface IRSSearchCell ()
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic,strong)UILabel *contentLabel;
@end
@implementation IRSSearchCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createBasicView];
    }
    return self;
    
}

- (void)createBasicView{
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = kIRSColorBackground;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:self.bgView];
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [UIColor yellowColor];
    self.contentLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.bgView addSubview:self.contentLabel];
}

- (void)layoutSubviews{
    [self.bgView setFrame:self.bounds];
    [self.contentLabel setFrame:CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height)];
    [super layoutSubviews];
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.contentLabel.text = _content;
    [self layoutIfNeeded];
    
}
@end
