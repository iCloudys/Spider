//
//  Spider.m
//  Spider-Mac
//
//  Created by Mac on 2018/3/28.
//

#import "Spider.h"

#define WeakSelf __weak typeof(self) weakSelf = self
@implementation Spider

- (instancetype)initWithOption:(SpiderOption *)option{
    self = [super init];
    if (self) {
        _option = option;
    }
    return self;
}

- (void)start{
    [self htmlWithURLString:self.option.website];
}

- (void)htmlWithURLString:(NSString*)urlString{
    
    WeakSelf;
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask* task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            if (!error) {
                                                NSString* html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                [weakSelf matchesStringInHtml:html];
                                            }
                                        }];
    
    [task resume];
}

- (void)matchesStringInHtml:(NSString*)html{
    WeakSelf;

    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:self.option.pattern
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
    [expression enumerateMatchesInString:html
                                 options:NSMatchingReportCompletion
                                   range:NSMakeRange(0, html.length)
                              usingBlock:^(NSTextCheckingResult* result, NSMatchingFlags flags, BOOL* stop) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      NSString* sub = [html substringWithRange:result.range];
                                      weakSelf.option.progress ? weakSelf.option.progress(sub) : nil;
                                  });
                              }];
}

@end
