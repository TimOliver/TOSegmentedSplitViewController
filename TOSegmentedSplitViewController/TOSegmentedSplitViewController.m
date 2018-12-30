//
//  TOSegmentedSplitViewController.m
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

#import "TOSegmentedSplitViewController.h"

/** The maximum width one of the segments in the segmented control may stretch to. */
CGFloat const kTOSegmentedViewWidth = 178.0f;

@interface TOSegmentedSplitViewController () <UIScrollViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong, readwrite) UIView *separatorView;
@property (nonatomic, strong, readwrite) UIView *controlsContainer;
@property (nonatomic, strong, readwrite) UIVisualEffectView *blurView;
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

@property (nonatomic, readonly) BOOL compactLayout;
@property (nonatomic, readonly) CGFloat hairlineWidth;

@end

@implementation TOSegmentedSplitViewController

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
    _segmentedControlHeight = 26.0f;
    _segmentedControlVerticalOffset = 9.0f;
}

- (void)dealloc
{
    [self removeAllChildControllers];
}

#pragma mark - View Creation -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Set up the Scroll View
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.insetsLayoutMarginsFromSafeArea = NO;
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.controlsContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.controlsContainer];
    
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.blurView.frame = self.controlsContainer.bounds;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.controlsContainer addSubview:self.blurView];
    
    // Hide the dimming view
    if (self.blurView.subviews.count > 1) {
        self.blurView.subviews[1].hidden = YES;
    }
    
    // Set up the segmented view with dummy values for now
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2"]];
    self.segmentedControl.frame = self.controlsContainer.bounds;
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.controlsContainer addSubview:self.segmentedControl];
    
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
    
    // Show the segmented control and lay it out
    frame = CGRectZero;
    frame.size.width = kTOSegmentedViewWidth;
    frame.size.height = self.segmentedControlHeight;
    frame.origin.y = CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame) + self.segmentedControlVerticalOffset;
    frame.origin.x = (bounds.width - frame.size.width) * 0.5f;
    self.controlsContainer.frame = frame;
    self.controlsContainer.hidden = NO;

    [self.controlsContainer.superview bringSubviewToFront:self.controlsContainer];
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

    // Hide the segmented control
    self.controlsContainer.hidden = YES;
}

#pragma mark - Child View Controller Management -

- (void)addChildViewControllers
{
    if (self.controllers.count == 0) { return; }
    
    NSInteger i = 0;
    for (UIViewController *controller in self.controllers) {
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [self.segmentedControl setTitle:controller.title forSegmentAtIndex:i++];
        
        if ([controller isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)controller setDelegate:self];
        }
    }
}

- (void)removeAllChildControllers
{
    for (UIViewController *controller in self.childViewControllers) {
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        
        if ([controller isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)controller setDelegate:nil];
        }
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

#pragma mark - Navigation Controller Management -
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.compactLayout == NO) { return; }
    
    // Hide the title text
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTOSegmentedViewWidth, 45)];
    viewController.navigationItem.titleView = dummyView;
}

- (void)setTitlesHidden:(BOOL)hidden inNavigationController:(UINavigationController *)navigationController
{
    
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

- (NSArray<UIViewController *> *)visibleControllers
{
    if (self.compactLayout == NO) {
        return self.controllers.copy;
    }
    
    CGSize boundSize = self.view.bounds.size;
    if (self.scrollView.contentOffset.x > boundSize.width - FLT_EPSILON) {
        return @[self.controllers[1]];
    }
    
    return @[self.controllers[0]];
}

@end
