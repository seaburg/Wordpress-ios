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

#import "UIFont+Factory.h"

#define TITLE_LABEL_FONT ([UIFont wp_regularFontWithSize:17])
#define EXCERPT_LABEL_FONT ([UIFont wp_regularFontWithSize:14])

@interface WPPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *excerptLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (strong, nonatomic) RACDisposable *disposable;

@end

@implementation WPPostCell

+ (CGFloat)cellHeightWithVewModel:(WPPostsItemViewModel *)viewModel tableView:(UITableView *)tableView
{
    const CGFloat minCellHeight = 111;
    const UIEdgeInsets insetsLabels = UIEdgeInsetsMake(8, 80, 31, 8);
    const CGFloat spaceBetweenLabels = 4;
    
    CGFloat widthLabels = CGRectGetWidth(tableView.frame) - insetsLabels.left - insetsLabels.right;
    
    CGRect titleBounds = [viewModel.title boundingRectWithSize:CGSizeMake(widthLabels, INFINITY)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{ NSFontAttributeName: TITLE_LABEL_FONT }
                                                       context:nil];
    
    CGRect excerptBounds = [viewModel.excerpt boundingRectWithSize:CGSizeMake(widthLabels, INFINITY)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{ NSFontAttributeName: EXCERPT_LABEL_FONT }
                                                           context:nil];
    
    CGFloat cellHeight = CGRectGetHeight(titleBounds) + CGRectGetHeight(excerptBounds) + spaceBetweenLabels + insetsLabels.top + insetsLabels.bottom;
    cellHeight = MAX(cellHeight, minCellHeight);
    
    return cellHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.font = TITLE_LABEL_FONT;
    self.excerptLabel.font = EXCERPT_LABEL_FONT;
}

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
    
    [disposable addDisposable:[[RACObserve(self.viewModel, numberOfComments)
        map:^id(NSNumber *value) {
            return [value stringValue];
        }]
        setKeyPath:@keypath(self.commentsLabel, text) onObject:self.commentsLabel]];
    
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
