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

/** The view controllers to be displayed by this controller, in order of display. */
@property (nonatomic, copy) NSArray<UIViewController *> *controllers;

/** In regular width environments, the maximum number of child view controllers
 to display onscreen at once. (Default is 2) */
@property (nonatomic, assign) NSInteger maximumNumberOfVisibleControllers;

/** The color of the separator lines between each child controller */
@property (nonatomic, strong) UIColor *separatorLineColor;



/**
 Creates a new instance of this view controller, populated by the content
 view controllers provided in the arguments.

 @param controllers The child view controllers to present in this controller
 @return A new instance of `TOSegmentedTabBarController`
 */
- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers;

@end

NS_ASSUME_NONNULL_END
