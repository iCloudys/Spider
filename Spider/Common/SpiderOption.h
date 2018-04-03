//
//  SpiderOption.h
//  Spider-Mac
//
//  Created by Mac on 2018/3/28.
//

#import <Foundation/Foundation.h>

typedef void(^SpiderProgressHander)(NSString* url);

@interface SpiderOption : NSObject

/**
 目标网站
 */
@property (nonatomic, copy) NSString* website;

/**
 抓取数据正则表达式
 */
@property (nonatomic, copy) NSString* pattern;

/**
 抓取数据回调
 */
@property (nonatomic, copy) SpiderProgressHander progress;

@end
