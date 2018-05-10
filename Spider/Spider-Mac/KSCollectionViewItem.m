//
//  KSCollectionViewItem.m
//  Spider-Mac
//
//  Created by Mac on 2018/5/3.
//

#import "KSCollectionViewItem.h"

#import <UIImageView+WebCache.h>

@interface KSCollectionViewItem ()

@end

@implementation KSCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
    self.imageView.layer.backgroundColor = [NSColor redColor].CGColor;
}

- (void)setUrl:(NSString *)url{
    _url = url.copy;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}
@end
