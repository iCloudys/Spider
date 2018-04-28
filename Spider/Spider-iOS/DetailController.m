//
//  DetailController.m
//  Spider-iOS
//
//  Created by Mac on 2018/4/4.
//

#import "DetailController.h"
#import <UIImageView+WebCache.h>

@interface DetailController()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation DetailController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.url]];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.imageView.frame = self.view.bounds;
}

@end
