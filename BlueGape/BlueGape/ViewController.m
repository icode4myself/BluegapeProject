//
//  ViewController.m
//  BlueGape
//
//  Created by Gaurav Kumar Singh on 06/06/15.
//  Copyright (c) 2015 Gaurav Kumar Singh. All rights reserved.
//

#import "ViewController.h"
#import "BGBingManager.h"
#import "ContentCollectionViewCell.h"
#import "ImageModel.h"
#import "UIImageView+AFNetworking.h"
#import "SGSStaggeredFlowLayout.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, assign) CGFloat cellWidth;
@property (strong, nonatomic) NSArray *cellColors;


@end

static NSString * const ImageCellIdentifier = @"ImageViewCell";

static const CGFloat kCellEqualSpacing = 15.0f;

@implementation ViewController

- (void)awakeFromNib
{
    
    self.cellColors = @[ [UIColor colorWithRed:166.0f/255.0f green:201.0f/255.0f blue:227.0f/255.0f alpha:1.0],
                         [UIColor colorWithRed:227.0f/255.0f green:192.0f/255.0f blue:166.0f/255.0f alpha:1.0] ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    [self.contentCollectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:ImageCellIdentifier];

    
//    _flowLayout = [[SGSStaggeredFlowLayout alloc] init];
    SGSStaggeredFlowLayout *flowLayout = [[SGSStaggeredFlowLayout alloc] init];//self.contentCollectionView.collectionViewLayout;
    
    flowLayout.layoutMode = SGSStaggeredFlowLayoutMode_Even;
    flowLayout.minimumLineSpacing = 2.0f;
    flowLayout.minimumInteritemSpacing = 2.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    flowLayout.itemSize = CGSizeMake(75.0f, 75.0f);
    self.contentCollectionView.collectionViewLayout = flowLayout;
    
//    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.contentCollectionView.collectionViewLayout;
//    layout.sectionInset = UIEdgeInsetsMake(0, kCellEqualSpacing, 0, kCellEqualSpacing);
}

- (void)viewDidAppear:(BOOL)animated {
//    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.contentCollectionView.collectionViewLayout;
//    
//    layout.columnCount = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    return CGSizeMake(100, 100);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier
                                                                       forIndexPath:indexPath];
    ImageModel *imageRecord = [self.images objectAtIndex:indexPath.row];
    
    [cell.contentImageView setImageWithURL:imageRecord.thumbnailURL];
    
    if (indexPath.row == [self.images count] - 1) {
        [self loadImagesWithOffset:(int)[self.images count]];
    };
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.contentCollectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - CHTCollectionViewWaterfallLayoutDelagate

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageModel *imageRecord = [self.images objectAtIndex:indexPath.row];
    
    return imageRecord.thumbnailSize.height * (50 / imageRecord.thumbnailSize.width);
}


#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Dismiss the keyboard
    [searchBar resignFirstResponder];
    
    [self loadImagesWithOffset:0];
}


#pragma mark -

- (void)updateTitle
{
    NSString *searchProviderString = [[NSUserDefaults standardUserDefaults] stringForKey:@"search_provider"];
    self.title = [NSClassFromString(searchProviderString) title];;
    
    NSLog(@"Updated search provider to %@", searchProviderString);
}

- (void)loadImagesWithOffset:(int)offset
{
    if ([self.searchBar.text isEqual:@""]) {
        return;
    }
    
    if (offset == 0) {
        [self.images removeAllObjects];
        [self.contentCollectionView reloadData];
    }
    
    __weak ViewController *weakSelf = self;
    
    [[BGBingManager sharedClient] findImagesForQuery:self.searchBar.text withOffset:offset
                                          success:^(NSURLSessionDataTask *dataTask, NSArray *imageArray) {
                                              if (offset == 0) {
                                                  weakSelf.images = [NSMutableArray arrayWithArray:imageArray];
                                              } else {
                                                  [weakSelf.images addObjectsFromArray:imageArray];
                                              }
                                              
                                              [weakSelf.contentCollectionView reloadData];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                              });
                                          }
                                          failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                                              NSLog(@"An error occured while searching for images, %@", [error description]);
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                              });
                                          }
     ];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
