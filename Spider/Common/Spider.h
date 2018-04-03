//
//  Spider.h
//  Spider-Mac
//
//  Created by Mac on 2018/3/28.
//

#import <Foundation/Foundation.h>
#import "SpiderOption.h"

@interface Spider : NSObject

/**
 参数类
 */
@property (nonatomic, strong, readonly) SpiderOption* option;

/**
 初始化方法

 @param option 参数类
 @return self
 */
- (instancetype)initWithOption:(SpiderOption*)option;

/**
 开始抓取
 */
- (void)start;

@end
