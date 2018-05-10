//
//  CollectionViewCell.m
//  Spider-iOS
//
//  Created by Mac on 2018/4/4.
//

#import "CollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface CollectionViewCell()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imageView.image = nil;
}

- (void)setUrl:(NSString *)url{
    _url = url.copy;
    
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf.imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                NSLog(@"%@[%@]",error,imageURL);
            }
        }];
    });
}

@end

NSString * const CollectionViewCellID = @"CollectionViewCellID";
