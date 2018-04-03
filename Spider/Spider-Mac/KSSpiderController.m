//
//  KSSpiderController.m
//  Spider-Mac
//
//  Created by Mac on 2018/3/28.
//

#import "KSSpiderController.h"
#import "Spider.h"

@implementation KSSpiderController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    SpiderOption* option = [[SpiderOption alloc] init];
    option.url = @"https://www.enterdesk.com/special/xiaoqingxin/";
    
    option.progress = ^(NSString *url) {
        [self appendLogs:url];
    };
    
    [Spider spiderOption:option];
    
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    return YES;
}

- (IBAction)buttonAction:(NSButton *)sender {
}

- (void)appendLogs:(NSString*)log{
    
    if (log.length > 0) {
        
        NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",log]];
        [self.textView.textStorage appendAttributedString:attributeString];
    }
}

@end
