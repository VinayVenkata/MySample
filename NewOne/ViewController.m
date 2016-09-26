//
//  ViewController.m
//  NewOne
//
//  Created by Vinay Ponnuri on 7/28/16.
//  Copyright © 2016 Vinay Ponnuri. All rights reserved.
//

#import "ViewController.h"
#import "DishDashItemCollectionCell.h"
#import "DishDashItemDetailsViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *dishItemsInfo;
@property (nonatomic, weak) IBOutlet UICollectionView *collection_dishItems;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_collection_dishItems.pagingEnabled = YES;
    [self loadDishItemsInfo];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadDishItemsInfo{
    [_loadingIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       NSString *dishItemsFilePath = [[NSBundle mainBundle] pathForResource:@"DishItems" ofType:@"plist"];
        _dishItemsInfo = [[NSMutableArray alloc] initWithContentsOfFile:dishItemsFilePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingIndicator stopAnimating];
            [_collection_dishItems reloadData];
            
            //Manually calling delegate method to eliminate calculations again.
            [self scrollViewDidEndDecelerating:_collection_dishItems];
            //[_collection_dishItems scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_dishItemsInfo.count/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        });
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float pageWidth = (float)self.collection_dishItems.bounds.size.width;
    float cellWidth = pageWidth - (2 * 100);
    
    double cellToSwipeDeciderValue = (scrollView.contentOffset.x)/cellWidth;
    int rowIndexPath = (int)ceil(cellToSwipeDeciderValue);
    
    float offset = (pageWidth - cellWidth) / 2;
    //Handling the edge conditions as well.
    if (rowIndexPath == 0) {
        [_collection_dishItems setContentOffset:CGPointMake(- offset, scrollView.contentOffset.y) animated:YES];
    }
    else if (rowIndexPath == _dishItemsInfo.count-1){
        [_collection_dishItems setContentOffset:CGPointMake((_dishItemsInfo.count - 1) * cellWidth - offset, scrollView.contentOffset.y) animated:YES];
    }
    else{
        [_collection_dishItems scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:rowIndexPath inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dishItemsInfo.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DishDashItemCollectionCell *dishDashCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DishDashItemCollectionCell" forIndexPath:indexPath];
    [dishDashCollectionCell fillDataWithContent:_dishItemsInfo[indexPath.item]];
    return dishDashCollectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.bounds.size.width - (2 * 100), collectionView.bounds.size.height);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DishDashItemDetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"DishDashItemDetails"];
    details.detailsContent =_dishItemsInfo[indexPath.row];
    [self.navigationController pushViewController:details animated:YES];
    
}
@end
