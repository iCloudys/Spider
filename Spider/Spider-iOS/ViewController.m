//
//  ViewController.m
//  Spider-iOS
//
//  Created by Mac on 2018/3/28.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "DetailController.h"

#import "Spider.h"

#define WeakSelf __weak typeof(self) weakSelf = self

@interface ViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<NSString*> *urls;
@property (strong, nonatomic) Spider *spider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    
    self.urls = [NSMutableArray array];
    [self.view addSubview:self.collectionView];
    
    
    //初始化一个参数类
    SpiderOption* option = [[SpiderOption alloc] init];
    
    //准备目标网址
    option.website = @"https://www.enterdesk.com";
    
    option.pattern = @"(?<=(src=\"))https?://.+?.(jpg|png)";
    
    //处理回调，当成功抓取一个内容之后，我们就把他拼接到textView的底部
    WeakSelf;
    option.complete = ^(NSArray<NSString *>* urls) {
        [weakSelf appendUrls:urls];
    };
    
    //初始化爬虫类
    self.spider = [[Spider alloc] initWithOption:option];
    
    //开始抓取
    [self.spider start];
}

- (void)appendUrls:(NSArray<NSString *>*)urls{
    
    if (urls.count > 0) {
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView performBatchUpdates:^{
                
                NSMutableArray<NSIndexPath*>* idxs = [NSMutableArray array];
                
                for (int i = 0; i < urls.count; i ++) {
                    NSIndexPath* idx = [NSIndexPath indexPathForItem:weakSelf.urls.count + i inSection:0];
                    [idxs addObject:idx];
                }
                
                [weakSelf.urls addObjectsFromArray:urls];

                [weakSelf.collectionView insertItemsAtIndexPaths:idxs];
                
            } completion: NULL];
        });
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urls.count;
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    cell.url = self.urls[indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.01;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)collectionViewLayout;
    
    CGFloat w = (CGRectGetWidth(collectionView.frame) -
                 layout.minimumInteritemSpacing -
                 layout.sectionInset.left -
                 layout.sectionInset.right) / 8 - 0.5;
    
    return CGSizeMake(w, w);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailController* detail = [[DetailController alloc] init];
    detail.url = self.urls[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[CollectionViewCell class]
            forCellWithReuseIdentifier:CollectionViewCellID];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


@end
