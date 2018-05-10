//
//  ViewController.h
//  Spider-Mac
//
//  Created by Mac on 2018/5/3.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<
NSCollectionViewDataSource,
NSCollectionViewDelegate,
NSCollectionViewDelegateFlowLayout>

@property (weak) IBOutlet NSCollectionView *collectionView;


@end

