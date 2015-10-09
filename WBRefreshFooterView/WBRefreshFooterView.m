//
//  WBRefreshFooterView.m
//  
//
//  Created by webox on 10/8/15.
//
//

#import "WBRefreshFooterView.h"

static const NSInteger WBDragingThreshold = 10;

static NSString *WBNormalTitle = @"加载更多";
static NSString *WBDragingTilte = @"松开立即刷新";
static NSString *WBLoadingTitle = @"加载中...";

typedef NS_ENUM(NSInteger, WBRefreshFooterState) {
    WBRefreshFooterStateNormal,
    WBRefreshFooterStateDraging,
    WBRefreshFooterStateLoading,
    WBRefreshFooterStateLoaded,
};

@interface WBRefreshFooterView () {
    WBRefreshFooterState _refreshState;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadMoreIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadMoreLabel;

@end

@implementation WBRefreshFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(WBRefreshFooterView.class) owner:self options:nil];
    [self addSubview:self.contentView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMorePressed:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    _normalTitle = WBNormalTitle;
    _dragingTitle = WBDragingTilte;
    _loadingTitle = WBLoadingTitle;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadMorePressed:(id)sender {
    [self startLoading];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.superview && [keyPath isEqualToString:@"contentOffset"]) {
        if ([self.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            [self scrollViewDidScroll:scrollView];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - fake UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.contentOffset.y + CGRectGetHeight(scrollView.bounds);
    CGFloat delta = height - scrollView.contentSize.height;
    if (delta > WBDragingThreshold && scrollView.isTracking && _refreshState == WBRefreshFooterStateNormal) {
        _refreshState = WBRefreshFooterStateDraging;
        _loadMoreLabel.text = _dragingTitle;
    } else if (_refreshState == WBRefreshFooterStateDraging) {
        if (delta > WBDragingThreshold && !scrollView.isDragging) {
            [self startLoading];
        } else if (delta < WBDragingThreshold && scrollView.isDragging) {
            [self stopLoading];
        }
    }
}

- (void)startLoading
{
    if (_refreshState == WBRefreshFooterStateLoading) {
        return;
    }
    
    _refreshState = WBRefreshFooterStateLoading;
    _loadMoreLabel.text = _loadingTitle;
    [_loadMoreIndicator startAnimating];

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)stopLoading
{
    if (_refreshState == WBRefreshFooterStateNormal) {
        return;
    }
    
    _refreshState = WBRefreshFooterStateNormal;
    [_loadMoreIndicator stopAnimating];
    _loadMoreLabel.text = _normalTitle;
}

@end
