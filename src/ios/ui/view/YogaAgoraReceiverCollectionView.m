#import "YogaAgoraReceiverCollectionView.h"
#import <Masonry/Masonry.h>
#import "YogaAgoraShared.h"
#import "YogaAgoraReceiverCell.h"

@interface YogaAgoraReceiverCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id<YogaAgoraReceiverCollectionViewDelegate> delegate;
@property (nonatomic, weak) id<YogaAgoraReceiverCollectionViewDatasource> datasource;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*uids;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YogaAgoraReceiverCollectionView

- (instancetype)initWithDelegate:(id<YogaAgoraReceiverCollectionViewDelegate>)delegate datasource:(id<YogaAgoraReceiverCollectionViewDatasource>)datasource
{
    if (self = [super init]) {
        self.backgroundColor = UIColor.lightGrayColor;
        self.delegate = delegate;
        self.datasource = datasource;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor yellowColor];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.datasource && [self.datasource respondsToSelector:@selector(containerView)]) {
        if (self && self.superview) {
            [[self.datasource containerView] addSubview:self.closeBtn];
            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@40);
                make.top.right.equalTo(self);
            }];
        }
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.closeBtn removeFromSuperview];
}

- (void)closeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(close)]) {
        [self.delegate close];
    }
}

- (void)addUid:(NSUInteger)uid
{
    __block BOOL inside = NO;
    [self.uids enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == uid) {
            inside = YES;
            *stop = YES;
        }
    }];
    if (!inside) {
        [self.uids addObject:[NSNumber numberWithInteger:uid]];
    }else {
        
    }
    [self.collectionView reloadData];
}

- (void)removeUid:(NSUInteger)uid
{
    __block NSInteger insideIndex = -1;
    [self.uids enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == uid) {
            insideIndex = idx;
            *stop = YES;
        }
    }];
    if (insideIndex > -1) {
        [self.uids removeObjectAtIndex:insideIndex];
        [self.collectionView reloadData];
    }
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.uids.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%s]self.uids: %@",__func__,self.uids);
    YogaAgoraReceiverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YogaAgoraReceiverCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.uid = [self.uids objectAtIndex:indexPath.row];
    return cell;
}

// UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -- UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_itemSize.width > 0 && _itemSize.height > 0) {
        CGSize newItemSize = _itemSize;
        if (_itemSize.width > 0  && _itemSize.width <= 1) {
            newItemSize.width = self.bounds.size.width*_itemSize.width;
        }
        if (_itemSize.height > 0  && _itemSize.height <= 1) {
            newItemSize.height = self.bounds.size.height*_itemSize.height;
        }
        return newItemSize;
    }
    return CGSizeMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark -- Setter

- (void)setIsHorizontal:(BOOL)isHorizontal
{
    _isHorizontal = isHorizontal;
    NSLog(@"isHorizontal>>>>>>>>>>>>>>: %@",isHorizontal?@"横向":@"竖向");
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layout.scrollDirection = _isHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    __weak __typeof(self) weakSelf = self;
    [self.collectionView setCollectionViewLayout:layout animated:YES completion:^(BOOL finished) {
        [weakSelf.collectionView reloadData];
    }];
}

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    [self.collectionView reloadData];
}

#pragma mark -- Getter

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 0, 40, 40);
        _closeBtn.layer.cornerRadius = 20;
        _closeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [_closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (NSMutableArray *)uids
{
    if (!_uids) {
        _uids = [NSMutableArray array];
    }
    return _uids;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为水平流布局
        _layout.scrollDirection = _isHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YogaAgoraReceiverCell class] forCellWithReuseIdentifier:@"YogaAgoraReceiverCell"];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@(UIEdgeInsetsZero));
        }];
        _collectionView.backgroundColor = [UIColor grayColor];
    }
    return _collectionView;
}

@end
