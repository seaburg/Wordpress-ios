//
//  WPPostsViewController.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 06/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "WPPostsViewController.h"
#import "WPPostsViewModel.h"
#import "WPPostCell.h"

#import "UITableView+RACCommand.h"

@interface WPPostsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) WPPostsViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL viewFirstAppeared;

@end

@implementation WPPostsViewController

- (instancetype)initWithPostsViewModel:(WPPostsViewModel *)viewModel
{
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([WPPostCell class]) bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NSStringFromClass([WPPostCell class])];
    
    @weakify(self);
    [self.viewModel.dataUpdated
        subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView reloadData];
        }];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
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
        self.tableView.rac_pullToRefreshCommand = pullToRefreshCommand;

        RACSignal *infinityScrollEnabled = [RACSignal combineLatest:@[ RACObserve(self.viewModel, nextPageExisted), pullToRefreshCommand.executing ]
            reduce:^id (NSNumber *nextPathExisted, NSNumber *pullToRefreshExicuting){
                return @([nextPathExisted boolValue] && ![pullToRefreshExicuting boolValue]);
            }];
        RACCommand *infinityScrollCommand = [[RACCommand alloc] initWithEnabled:infinityScrollEnabled signalBlock:^RACSignal *(id input) {
            return [self.viewModel loadNextPage];
        }];
        infinityScrollCommand.allowsConcurrentExecution = YES;
        self.tableView.rac_infinityScrollCommand = infinityScrollCommand;
        
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.numberOfObjets;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPPostCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WPPostCell class]) forIndexPath:indexPath];
    cell.viewModel = [self.viewModel itemViewModelAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    [[[[self.viewModel selectItemViewModelAtIndex:indexPath.row]
        initially:^{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        }]
        finally:^{
            [SVProgressHUD dismiss];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }]
        subscribeError:^(NSError *error) {
            @strongify(self);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPPostsItemViewModel *itemViewModel = [self.viewModel itemViewModelAtIndex:indexPath.row];
    CGFloat cellHeight = [WPPostCell cellHeightWithVewModel:itemViewModel tableView:tableView];
    
    return cellHeight;
}

@end
