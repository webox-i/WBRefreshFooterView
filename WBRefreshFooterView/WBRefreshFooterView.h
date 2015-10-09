//
//  WBRefreshFooterView.h
//  
//
//  Created by webox on 10/8/15.
//
//

#import <UIKit/UIKit.h>

@interface WBRefreshFooterView : UIControl

@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) NSString *dragingTitle;
@property (nonatomic, strong) NSString *loadingTitle;

- (void)startLoading;
- (void)stopLoading;

@end
