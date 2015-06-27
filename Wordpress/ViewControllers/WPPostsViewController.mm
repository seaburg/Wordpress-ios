//
//  WPPostsViewController.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 06/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ComponentKit/CKComponentProvider.h>
#import <ComponentKit/CKComponentFlexibleSizeRangeProvider.h>
#import <ComponentKit/CKCollectionViewDataSource.h>
#import <ComponentKit/CKArrayControllerChangeset.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "WPPostsViewController.h"
#import "WPPostsViewModel.h"
#import "WPPostsState.h"
#import "WPPostsItemState.h"
#import "WPPostCellComponent.h"

#import "UIScrollView+RACCommand.h"

@interface WPPostsViewController () <CKComponentProvider, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) id<WPPostsViewModel> viewModel;

@property (strong, nonatomic) CKComponentFlexibleSizeRangeProvider *sizeRangeProvider;

@property (strong, nonatomic) CKCollectionViewDataSource *dataSource;

@property (assign, nonatomic) BOOL viewFirstAppeared;

@end

@implementation WPPostsViewController

- (instancetype)initWithPostsViewModel:(id<WPPostsViewModel>)viewModel
{
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)loadView
{
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.view = self.collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];

    self.dataSource = [[CKCollectionViewDataSource alloc] initWithCollectionView:self.collectionView supplementaryViewDataSource:nil componentProvider:[self class] context:self.viewModel cellConfigurationFunction:nil];
    
    CKArrayControllerSections sections;
    sections.insert(0);
    [self.dataSource enqueueChangeset:{ sections, {} } constrainedSize:{}];

    RACSignal *updates = [[[self.viewModel state]
        map:^id(id<WPPostsState> value) {
            return [value items];
        }]
        combinePreviousWithStart:nil reduce:^id(RACSequence *previous, RACSequence *current) {
            NSArray *previousItems = [previous array];
            NSArray *currentItems = [current array];

            NSMutableArray *removedIndexPaths = [NSMutableArray array];
            for (NSUInteger i = 0; i < [previousItems count]; ++i) {
                if (![currentItems containsObject:previousItems[i]]) {
                    [removedIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }

            NSMutableArray *insertedItems = [NSMutableArray array];
            for (NSUInteger i = 0; i < [currentItems count]; ++i) {
                id item = currentItems[i];
                if (![previousItems containsObject:currentItems[i]]) {
                    [insertedItems addObject:RACTuplePack(item, [NSIndexPath indexPathForRow:i inSection:0])];
                }
            }

            return RACTuplePack([insertedItems copy], [removedIndexPaths copy]);
        }];
    [self rac_liftSelector:@checkselector(self, updateDataSourceWithInsertedItems:, removedIndexPaths:) withSignalOfArguments:updates];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.viewFirstAppeared) {
        @weakify(self);
        RACCommand *pullToRefreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.viewModel reloadData];
        }];
        pullToRefreshCommand.allowsConcurrentExecution = YES;
        self.collectionView.rac_pullToRefreshCommand = pullToRefreshCommand;

        RACSignal *nextPageExist = [[self.viewModel state] map:^id(id<WPPostsState> value) {
            return @([value nextPageExist]);
        }];
        RACSignal *infinityScrollEnabled = [[RACSignal combineLatest:@[ nextPageExist, pullToRefreshCommand.executing ]]
            map:^id(RACTuple *value) {
                RACTupleUnpack(NSNumber *nextPathExisted, NSNumber *pullToRefreshExicuting) = value;
                return @([nextPathExisted boolValue] && ![pullToRefreshExicuting boolValue]);
            }];
        RACCommand *infinityScrollCommand = [[RACCommand alloc] initWithEnabled:infinityScrollEnabled signalBlock:^RACSignal *(id input) {
            return [self.viewModel loadNextPage];
        }];
        infinityScrollCommand.allowsConcurrentExecution = YES;
        self.collectionView.rac_infinityScrollCommand = infinityScrollCommand;
        
        [[RACSignal merge:@[ infinityScrollCommand.errors, pullToRefreshCommand.errors ]]
            subscribeNext:^(NSError *error) {
                @strongify(self);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        
        self.viewFirstAppeared = YES;
    }
}

- (void)updateDataSourceWithInsertedItems:(RACTuple *)insertedItems removedIndexPaths:(NSArray *)removedIndexPaths
{
    CKArrayControllerInputItems items;

    for (NSIndexPath *removedIndexPath in removedIndexPaths) {
        items.remove({ removedIndexPath });
    }

    for (RACTuple *insertedPair in insertedItems) {
        RACTupleUnpack(id<NSObject> object, NSIndexPath *indexPath) = insertedPair;
        items.insert({ indexPath }, object);
    }
    [self.dataSource enqueueChangeset:{ {}, items } constrainedSize:[self.sizeRangeProvider sizeRangeForBoundingSize:self.collectionView.bounds.size]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<WPPostsItemState> itemState = (id<WPPostsItemState>)[self.dataSource modelForItemAtIndexPath:indexPath];

    @weakify(self);
    [[[[[self.viewModel selectPostsItemState:itemState]
        initially:^{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        }]
        finally:^{
            [SVProgressHUD dismiss];
        }]
        takeUntil:self.rac_willDeallocSignal]
        subscribeError:^(NSError *error) {
            @strongify(self);

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
}

#pragma mark - CKComponentProvider

+ (CKComponent *)componentForModel:(id<WPPostsItemState>)model context:(id<WPPostsViewModel>)context
{
    return [WPPostCellComponent newWithPostsItemState:model];
}

@end
