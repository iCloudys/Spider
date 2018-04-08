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
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

- (void)setUrl:(NSString *)url{
    _url = url.copy;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end

NSString * const CollectionViewCellID = @"CollectionViewCellID";
