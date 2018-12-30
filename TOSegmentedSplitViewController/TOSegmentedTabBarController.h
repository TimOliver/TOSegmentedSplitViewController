//
//  TOSegmentedTabBarController.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOSegmentedTabBarController : UIViewController

/** The segemented view control placed at the top of the control. */
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;

/** When in compact mode, the controllers are kept in this scroll view so they may be swiped. */
@property (nonatomic, readonly) UIScrollView *scrollView;

/** The view controllers to be displayed by this controller, in order of display. There may only be 2. */
@property (nonatomic, copy) NSArray<UIViewController *> *controllers;

/** The color of the separator lines between each child controller */
@property (nonatomic, strong) UIColor *separatorLineColor;

/** When in regular size class, the fractional size of the secondary view controller (Default is 0.31f) */
@property (nonatomic, assign) CGFloat secondaryViewControllerFractionalWidth;

/** When in regular size class, the minimum size that the secondary column may be. (Default is 320.0f) */
@property (nonatomic, assign) CGFloat secondaryViewControllerMinimumWidth;

/** When in compact layout, the height of the segmented controller (Default is 36.0f) */
@property (nonatomic, assign) CGFloat segmentedControlHeight;

/** When in compact layout, the vertical offset of the segmented control from the status bar */
@property (nonatomic, assign) CGFloat segmentedControlVerticalOffset;

/** When in compact mode, the controller that's currently visible */
@property (nonatomic, strong) NSArray<UIViewController *> *visibleControllers;

/**
 Creates a new instance of this view controller, populated by the content
 view controllers provided in the arguments.

 @param controllers The child view controllers to present in this controller. There must be 2.
 @return A new instance of `TOSegmentedTabBarController`
 */
- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers;


/**
 In compact presentation mode, plays a transition animation between the two controllers

 @param visibleController The controller to show
 @param animated Whether the effect is animated or not
 */
- (void)setVisibleController:(UIViewController *)visibleController animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
