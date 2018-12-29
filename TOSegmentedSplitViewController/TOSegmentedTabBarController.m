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

@interface TOSegmentedTabBarController ()

@property (nonatomic, strong, readwrite) NSArray<UIView *> *separatorViews;
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

@end

@implementation TOSegmentedTabBarController

#pragma mark - Controller Creation -

- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];

}

#pragma mark - Child View Controller Management -

- (void)addChildViewController:(UIViewController *)childController
{
    
}

- (void)removeAllChildControllers
{
    for (UIViewController *controller in self.childViewControllers) {
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }
}

#pragma mark - Accessors -

- (void)setControllers:(NSArray<UIViewController *> *)controllers
{
    if (controllers == _controllers) { return; }
    
    
}

@end
