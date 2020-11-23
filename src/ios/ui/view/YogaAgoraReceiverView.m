#import "YogaAgoraReceiverView.h"
#import <Masonry/Masonry.h>

@interface YogaAgoraReceiverView ()

@property (nonatomic, weak) id<YogaAgoraReceiverViewDelegate> delegate;
@property (nonatomic, weak) id<YogaAgoraReceiverViewDatasource> datasource;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *indexL;

@end

@implementation YogaAgoraReceiverView

- (instancetype)initWithDelegate:(id<YogaAgoraReceiverViewDelegate>)delegate datasource:(id<YogaAgoraReceiverViewDatasource>)datasource
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
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.datasource && [self.datasource respondsToSelector:@selector(containerView)]) {
        if (self && self.superview) {
//            [[self.datasource containerView] addSubview:self.closeBtn];
//            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.equalTo(@50);
//                make.bottom.equalTo(self).offset(-50);
//                make.right.equalTo(self).offset(-20);
//            }];
            
#if DEBUG
//            [[self.datasource containerView] addSubview:self.indexL];
//            [self.indexL mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(@(UIEdgeInsetsZero));
//            }];
#endif
        }
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
//    [self.closeBtn removeFromSuperview];
}

- (void)closeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(close)]) {
        [self.delegate close];
    }
}

#pragma mark -- Setter

- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.indexL.text = [NSString stringWithFormat:@"%ld",self.index];
}

#pragma mark -- Getter

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 0, 50, 50);
        _closeBtn.layer.cornerRadius = 5;
        _closeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)indexL
{
    if (!_indexL) {
        _indexL = [UILabel new];
        _indexL.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _indexL.textColor = [UIColor whiteColor];
        _indexL.textAlignment = NSTextAlignmentCenter;
    }
    return _indexL;
}


@end
