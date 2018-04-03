//
//  ViewController.m
//  Spider-iOS
//
//  Created by Mac on 2018/3/28.
//

#import "ViewController.h"
#import "Spider.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) Spider *spider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化一个参数类
    SpiderOption* option = [[SpiderOption alloc] init];
    
    //准备目标网址
    option.website = @"https://www.enterdesk.com";
    
    option.pattern = @"https?://.+?.(jpg|png)";
    
    //处理回调，当成功抓取一个内容之后，我们就把他拼接到textView的底部
    option.progress = ^(NSString *url) {
        [self showLogs:url];
    };
    
    //初始化爬虫类
    self.spider = [[Spider alloc] initWithOption:option];
    
    //开始抓取
    [self.spider start];
}

- (void)showLogs:(NSString*)log{
    
    //把Log内容拼接到textView最下面，并且滚动到最下面
    if (log.length > 0) {
        [self.textView insertText:[NSString stringWithFormat:@"%@\n\n",log]];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
    }
}

@end
