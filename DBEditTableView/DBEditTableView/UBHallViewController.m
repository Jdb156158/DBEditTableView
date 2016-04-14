//
//  MesssageViewController.m
//  1.UITabBarControllerDemo
//


#import "UBHallViewController.h"
#import "AppDelegate.h"


@interface UBHallViewController ()

@end

@implementation UBHallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)loadView
{
}

- (void)viewWillAppear: (BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor orangeColor];
    self.view = view;
    
    self.wideth = [[UIScreen mainScreen] bounds].size.width;
    self.height = [[UIScreen mainScreen] bounds].size.height;
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.wideth, self.height)];
    [self.webView setUserInteractionEnabled:YES];             //是否支持交互
    [self.webView setDelegate:self];                          //委托
    [self.webView setOpaque:YES];                              //Opaque为不透明的意思，这里为透明
    [self.webView setScalesPageToFit:YES];                    //自动缩放以适应屏幕
    [self.view addSubview:self.webView];
    
    NSString *paramURLAsString= self.urlpath;
    if ([paramURLAsString length] == 0){
        NSLog(@"Nil or empty URL is given");
        return;
    }
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    /* 设置缓存的大小为1M*/
    [urlCache setMemoryCapacity:1*1024*1024];
    //创建一个nsurl
    NSURL *url = [NSURL URLWithString:paramURLAsString];
    //创建一个请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    //从请求中获取缓存输出
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
    //判断是否有 内存缓存
    if (response != nil){
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        [request setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
    }
    [self.webView loadRequest:request];
    
    self.opaqueview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.wideth, self.height)]; //opaqueview 需要在.h文件中进行声明用以做UIActivityIndicatorView的容器view；
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.wideth, self.height)];
    [self.activityIndicatorView setCenter:self.opaqueview.center];
    
    [ self.activityIndicatorView   setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];  //颜色根据不同的界面自己调整
    self.activityIndicatorView.color = [UIColor blackColor];
    [ self.opaqueview  setBackgroundColor:[UIColor  groupTableViewBackgroundColor]];
    [ self.opaqueview  setAlpha: 1.0 ];
    [ self.view  addSubview :  self.opaqueview];
    [ self.opaqueview  addSubview : self.activityIndicatorView];

    
}
-(void)setMyWebTitle:(NSString *)webtitle andsetMyWebUrlpath:(NSString *)urlpath
{
    self.webtitle = webtitle;
    self.title = self.webtitle;
    self.urlpath = urlpath;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当网页视图已经开始加载一个请求之后得到通知

- (void) webViewDidStartLoad:(UIWebView  *)webView {
    [self.activityIndicatorView startAnimating];
    self.opaqueview.hidden = NO;
}

//当网页视图结束加载一个请求之后得到通知

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicatorView stopAnimating]; //停止风火轮
    self.opaqueview.hidden = YES; //隐藏
    [self.opaqueview removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//当网页加载出错时
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载出错信息:%@",error);
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
