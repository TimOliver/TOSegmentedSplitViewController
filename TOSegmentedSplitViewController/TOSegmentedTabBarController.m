//
//  TOSegmentedTabBarController.m
//
//  Copyright 2018 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOSegmentedTabBarController.h"

/** The maximum width one of the segments in the segmented control may stretch to. */
CGFloat const kTOSegmentedTabBarControllerMaxWidth = 188.0f;

@interface TOSegmentedTabBarController () <UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIView *separatorView;
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

@property (nonatomic, readonly) BOOL compactLayout;
@property (nonatomic, readonly) CGFloat hairlineWidth;

@end

@implementation TOSegmentedTabBarController

#pragma mark - Controller Creation -

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers
{
    if (self = [super init]) {
        [self commonInit];
        _controllers = controllers;
    }
    
    return self;
}

- (void)commonInit
{
    _separatorLineColor = [UIColor colorWithRed:0.556f green:0.556 blue:0.576 alpha:1.0f];
    _secondaryViewControllerFractionalWidth = 0.3125f;
    _secondaryViewControllerMinimumWidth = 320.0f;
    _segmentedControlHeight = 38.0f;
}

#pragma mark - View Creation -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Set up the Scroll View
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // Set up the segmented view
    self.segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];

    // set up the separator view
    self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.separatorView.backgroundColor = _separatorLineColor;
    [self.scrollView addSubview:self.separatorView];
    
    // Set up the child controllers
    [self addChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.controllers.count != 2) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Number of View Controllers must be 2."
                                     userInfo:nil];
    }
}

#pragma mark - View Layout -

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.compactLayout) { [self layoutViewsForCompactSizeClass]; }
    else { [self layoutViewsForRegularSizeClass]; }
}

- (void)layoutViewsForCompactSizeClass
{
    CGSize bounds = self.view.bounds.size;
    CGRect frame = (CGRect){CGPointZero, bounds};
    
    UIViewController *primaryController = self.controllers[0];
    UIViewController *secondaryController = self.controllers[1];
    
    // Layout the controllers side by side
    primaryController.view.frame = frame;
    frame = CGRectOffset(frame, bounds.width, 0.0f);
    secondaryController.view.frame = frame;

    // Layout the separator view
    frame.size.width = self.hairlineWidth;
    frame.origin.x = CGRectGetMaxX(primaryController.view.frame);
    self.separatorView.frame = frame;
    self.separatorView.hidden = YES;
    [self.separatorView.superview bringSubviewToFront:self.separatorView];
    
    // Set up the scroll view
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = (CGSize){bounds.width * 2.0f, bounds.height};
}

- (void)layoutViewsForRegularSizeClass
{
    CGSize bounds = self.view.bounds.size;
    CGRect frame = CGRectZero;
    
    UIViewController *primaryController = self.controllers[0];
    UIViewController *secondaryController = self.controllers[1];
    
    // Layout the secondary controller first
    frame.size.width = bounds.width * self.secondaryViewControllerFractionalWidth;
    frame.size.width = MAX(frame.size.width, self.secondaryViewControllerMinimumWidth);
    frame.size.height = bounds.height;
    frame.origin.x   = bounds.width - frame.size.width;
    secondaryController.view.frame = frame;
    
    // Layout the first controller in the remaining space
    frame.size.width = frame.origin.x;
    frame.origin.x = 0.0f;
    primaryController.view.frame = frame;
    
    // Layout the separator
    frame.size.width = self.hairlineWidth;
    frame.origin.x = CGRectGetMaxX(primaryController.view.frame);
    self.separatorView.frame = frame;
    self.separatorView.hidden = NO;
    [self.separatorView.superview bringSubviewToFront:self.separatorView];
    
    // Adjust the scroll view properties
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = bounds;
    self.scrollView.contentOffset = CGPointZero;
}

#pragma mark - View Styling -

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];

    for (UIViewController *controller in self.controllers) {
        [self setNavigationTitleTextHidden:self.compactLayout inNavigationController:controller];
    }
}

- (void)setNavigationTitleTextHidden:(BOOL)hidden inNavigationController:(UIViewController *)controller
{
    if (![controller isKindOfClass:[UINavigationController class]]) { return; }
    UINavigationController *navController = (UINavigationController *)controller;
    NSDictionary *attributes = hidden ? @{NSForegroundColorAttributeName : [UIColor clearColor]} : nil;
    navController.navigationBar.titleTextAttributes = attributes;
}

#pragma mark - Child View Controller Management -

- (void)addChildViewControllers
{
    if (self.controllers.count == 0) { return; }
    
    for (UIViewController *controller in self.controllers) {
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
    }
}

- (void)removeAllChildControllers
{
    for (UIViewController *controller in self.childViewControllers) {
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }
}

#pragma mark - Scroll View Delegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.compactLayout) { self.separatorView.hidden = NO; }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.compactLayout) { self.separatorView.hidden = YES; }
}

#pragma mark - Accessors -

- (void)setControllers:(NSArray<UIViewController *> *)controllers
{
    if (controllers == _controllers) { return; }
    [self removeAllChildControllers];
    _controllers = controllers;
    [self addChildViewControllers];
}

- (BOOL)compactLayout
{
    return self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact;
}

- (CGFloat)hairlineWidth
{
    return 1.0 / [UIScreen mainScreen].nativeScale;
}

@end
