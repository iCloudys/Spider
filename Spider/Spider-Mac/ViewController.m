//
//  ViewController.m
//  Spider-Mac
//
//  Created by Mac on 2018/5/3.
//

#import "ViewController.h"
#import "KSCollectionViewItem.h"
#import "Spider.h"

#define WeakSelf __weak typeof(self) weakSelf = self

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray<NSString*> *urls;
@property (strong, nonatomic) Spider *spider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urls = [NSMutableArray array];
    [self.view addSubview:self.collectionView];
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundViewScrollsWithContent = YES;
    [self.collectionView registerClass:[KSCollectionViewItem class] forItemWithIdentifier:@"KSCollectionViewItem"];
    
    //初始化一个参数类
    SpiderOption* option = [[SpiderOption alloc] init];
    
    //准备目标网址
    option.website = @"https://www.enterdesk.com";
    
    option.pattern = @"(?<=(src=\"))https?://.+?.(jpg|png)";
    
    option.maxDepth = 2;
    
    //处理回调，
    WeakSelf;
    option.complete = ^(NSArray<NSString *>* urls) {
        [weakSelf appendUrls:urls];
    };
    
    //初始化爬虫类
    self.spider = [[Spider alloc] initWithOption:option];
    
    //开始抓取
//    [self.spider start];
}

- (void)appendUrls:(NSArray<NSString *>*)urls{
    
    if (urls.count > 0) {
        WeakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView performBatchUpdates:^{
                
                NSMutableSet<NSIndexPath*>* idxs = [NSMutableSet set];
                
                for (int i = 0; i < urls.count; i ++) {
                    NSIndexPath* idx = [NSIndexPath indexPathForItem:weakSelf.urls.count + i inSection:0];
                    [idxs addObject:idx];
                }
                
                [weakSelf.urls addObjectsFromArray:urls];
                
                [weakSelf.collectionView insertItemsAtIndexPaths:idxs];
                
            } completionHandler:NULL];
        });
    }
}

- (void)viewDidLayout{
    [super viewDidLayout];
    self.collectionView.frame = self.view.bounds;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.urls.count;
    return 500;
}

- (NSCollectionViewItem*)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath{
    KSCollectionViewItem* item = [collectionView makeItemWithIdentifier:@"KSCollectionViewItem" forIndexPath:indexPath];
//    item.url = self.urls[indexPath.item];
    item.url = @"http://img3.imgtn.bdimg.com/it/u=2194466256,3369833539&fm=27&gp=0.jpg";
    return item;
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return NSMakeSize(50, 50);
}

@end
