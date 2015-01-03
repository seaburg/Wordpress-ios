//
//  WPPostCell.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 03/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostCell.h"
#import "WPPostsItemViewModel.h"

@interface WPPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *excerptLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (strong, nonatomic) RACDisposable *disposable;

@end

@implementation WPPostCell

- (void)setViewModel:(WPPostsItemViewModel *)viewModel
{
    _viewModel = viewModel;
    
    [self.disposable dispose];
    self.disposable = nil;
    if (!_viewModel) {
        return;
    }
    
    RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
    [disposable addDisposable:[RACObserve(self.viewModel, title)
        setKeyPath:@keypath(self.titleLabel, text) onObject:self.titleLabel]];
    [disposable addDisposable:[RACObserve(self.viewModel, excerpt)
        setKeyPath:@keypath(self.excerptLabel, text) onObject:self.excerptLabel]];
    [disposable addDisposable:[[[self.viewModel image]
        catchTo:[RACSignal empty]]
        setKeyPath:@keypath(self.postImageView, image) onObject:self.postImageView]];
    
    self.disposable = disposable;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.disposable dispose];
}

@end
