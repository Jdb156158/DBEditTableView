//
//  MesssageViewController.h
//  1.UITabBarControllerDemo
//


#import <UIKit/UIKit.h>
@interface UBHallViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic) int wideth;
@property (nonatomic) int height;
@property (nonatomic ,strong) NSString *urlpath;
@property (nonatomic ,strong) NSString *webtitle;
@property (nonatomic ,strong) UIWebView *webView;
@property (nonatomic ,strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic ,strong) UIView *opaqueview;
-(void)setMyWebTitle:(NSString *)webtitle andsetMyWebUrlpath:(NSString *)urlpath;
@end
