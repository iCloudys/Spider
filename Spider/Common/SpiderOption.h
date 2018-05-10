//
//  SpiderOption.h
//  Spider-Mac
//
//  Created by Mac on 2018/3/28.
//

#import <Foundation/Foundation.h>

typedef void(^SpiderCompleteHander)(NSArray<NSString*>* urls);

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
 最大抓取深度 默认 NSUIntegerMax
 */
@property (nonatomic, assign) NSUInteger maxDepth;

/**
 Url抓取完成回调
 */
@property (nonatomic, copy) SpiderCompleteHander complete;

@end
