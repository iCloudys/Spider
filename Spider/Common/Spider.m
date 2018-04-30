//
//  Spider.m
//  Spider-Mac
//
//  Created by Mac on 2018/3/28.
//

#import "Spider.h"

#define WeakSelf __weak typeof(self) wSelf = self
#define StrongSelf __strong typeof(wSelf) sSelf = wSelf

@implementation Spider
{
    //等待抓取的Url
    NSMutableOrderedSet<NSString*>* _sourceUrl;
    //已经抓取的url
    NSMutableOrderedSet<NSString*>* _finashUrl;
    
    NSRegularExpression* _urlExpression;
    NSRegularExpression* _imgExpression;
}

- (instancetype)initWithOption:(SpiderOption *)option{
    self = [super init];
    if (self) {
        _option = option;
        
        _sourceUrl = [NSMutableOrderedSet orderedSet];
        
        _finashUrl = [NSMutableOrderedSet orderedSet];
        
        _imgExpression = [NSRegularExpression regularExpressionWithPattern:option.pattern
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
        
        _urlExpression = [NSRegularExpression regularExpressionWithPattern:@"https?:.+?.html"
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
        
    }
    return self;
}

- (void)start{
    [self loadUrl:self.option.website];
    
    

}

- (void)loadUrl:(NSString*)urlString{
    
    NSLog(@"加载:%@",urlString);
    
    WeakSelf;
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30;
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask* task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            StrongSelf;
                                            
                                            NSString* html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                                            if (!error && html.length > 0) {
                                                [sSelf fetchImgWithHtml:html];
                                                [sSelf fetchUrlWithHtml:html];
                                                
                                            }else{
                                                NSLog(@"加载出错:%@",error);
                                            }
                                            
                                            [sSelf loadNext];
                                        }];
    
    [task resume];
}

- (void)loadNext{
    
    //上个url结束之后，继续下一个(先进先出)
    
    NSString* url = self->_sourceUrl.firstObject;
    
    [self->_sourceUrl removeObject:url];
    
    if ([self->_finashUrl containsObject:url]) {
        NSLog(@"丢弃:%@",url);
        [self loadNext];
    }else{
        [self->_finashUrl addObject:url];
        [self loadUrl:url];
    }
}

- (void)fetchImgWithHtml:(NSString*)html{
    
    NSArray<NSString*>* strings = [self fetchStringsWithHtml:html expression:_imgExpression];

    self.option.complete ? self.option.complete(strings) : nil;
}

- (void)fetchUrlWithHtml:(NSString*)html{
    
    NSArray<NSString*>* strings = [self fetchStringsWithHtml:html expression:_urlExpression];
    
    [self->_sourceUrl addObjectsFromArray:strings];
}

- (NSArray<NSString*>*)fetchStringsWithHtml:(NSString*)html
                                 expression:(NSRegularExpression*)expression{
    
    NSArray<NSTextCheckingResult*>* results = [expression matchesInString:html
                                                                      options:NSMatchingReportCompletion
                                                                        range:NSMakeRange(0, html.length)];
    
    NSMutableArray<NSString*>* strings = [NSMutableArray arrayWithCapacity:results.count];
    
    for (NSTextCheckingResult* result in results) {
        NSString* sub = [html substringWithRange:result.range];
        [strings addObject:sub];
    }
    
    return strings;
}

@end
