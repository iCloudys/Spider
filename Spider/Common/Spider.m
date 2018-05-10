//
//  Spider.m
//  Spider-Mac
//
//  Created by Mac on 2018/3/28.
//

#import "Spider.h"
#import "NSURL+depth.h"

#define WeakSelf __weak typeof(self) wSelf = self
#define StrongSelf __strong typeof(wSelf) sSelf = wSelf

@interface Spider()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSOperationQueue* fetchHtmlQueue;
@property (nonatomic, strong) NSOperationQueue* operationQueue;

@end

@implementation Spider
{
    //已经抓取的url
    NSMutableSet<NSString*>* _finashUrl;
    
    NSRegularExpression* _urlExpression;
    NSRegularExpression* _imgExpression;
    
    NSURLSession* _session;
}

- (instancetype)initWithOption:(SpiderOption *)option{
    self = [super init];
    if (self) {
        _option = option;
        
        _finashUrl = [NSMutableSet set];
        
        _imgExpression = [NSRegularExpression regularExpressionWithPattern:option.pattern
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
        
        _urlExpression = [NSRegularExpression regularExpressionWithPattern:@"(?<=href=\")https?:.+?.html(?=\")"
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
        
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 3;
        _operationQueue.name = @"com.html.loadQueue";

        _fetchHtmlQueue = [[NSOperationQueue alloc] init];
        _fetchHtmlQueue.maxConcurrentOperationCount = 3;
        _fetchHtmlQueue.name = @"com.html.fetchQueue";
        
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 30;
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:_fetchHtmlQueue];
        
    }
    return self;
}

- (void)start{
    NSURL* url = [NSURL URLWithString:self.option.website];
    url.depth = 0;
    
    [self loadUrl:url];
}

- (void)loadUrl:(NSURL*)url{
    
    WeakSelf;
    
    @synchronized(self){
        [self->_operationQueue addOperationWithBlock:^{
            
            StrongSelf;
            
            NSURLSessionDataTask* task = [sSelf->_session dataTaskWithURL:url];
            
            [task resume];
            
        }];
    }
}

- (void)fetchImgWithHtml:(NSString*)html{
    
    WeakSelf;
    [self.fetchHtmlQueue addOperationWithBlock:^{
        StrongSelf;
        NSArray<NSString*>* strings = [sSelf fetchStringsWithHtml:html expression:sSelf->_imgExpression];
        
        sSelf.option.complete ? sSelf.option.complete(strings) : nil;
    }];
}

- (void)fetchUrlWithHtml:(NSString*)html depth:(NSUInteger)depth{
    
    WeakSelf;
    [self.fetchHtmlQueue addOperationWithBlock:^{
        StrongSelf;
        NSArray<NSString*>* strings = [sSelf fetchStringsWithHtml:html expression:sSelf->_urlExpression];
        
        for (NSString* string in strings) {
            NSURL* url = [NSURL URLWithString:string];
            if ([sSelf->_finashUrl containsObject:string]) {
                continue;
            }
            
            url.depth = depth;
            [sSelf->_finashUrl addObject:string];
            [sSelf loadUrl:url];
        }
    }];
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

///MARK:- NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseCancel;
    
    NSInteger statusCode = 0;
    
    if ([response respondsToSelector:@selector(statusCode)]){
        statusCode = [((NSHTTPURLResponse*)response) statusCode];
    }
    
    if (statusCode == 200) {
        disposition = NSURLSessionResponseAllow;
    }
    
    completionHandler(disposition);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    NSString* html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSUInteger depth = dataTask.originalRequest.URL.depth;
    
    if (html && html.length > 0) {
        if (depth < self.option.maxDepth) {
            [self fetchUrlWithHtml:html depth:depth + 1];
        }
        [self fetchImgWithHtml:html];

    }
}

@end
