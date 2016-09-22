/*
 * mpos-ui : http://www.payworks.com
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Payworks GmbH
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Class for fine tuning the appearance of the ViewController instantiated by MPUMposUi. 
 * In case no colors are set, the used UIAppearance is respected.
 */
@interface MPUMposUiAppearance : NSObject

/**
 * The tint of the navigation bar.
 */
@property (nonatomic, strong, nonnull) UIColor *navigationBarTint;

/**
 * The color of the navigation bar text.
 */
@property (nonatomic, strong, nonnull) UIColor *navigationBarTextColor;

/**
 * The color of the background view.
 */
@property (nonatomic, strong, nonnull) UIColor *backgroundColor;

/**
 * The style of the status bar.
 */
@property (nonatomic, assign) UIStatusBarStyle  statusBarStyle;



/**
 * The colors used to customize the summary header
 */
@property (nonatomic, strong, nonnull) UIColor *preauthorizedBackgroundColor;
@property (nonatomic, strong, nonnull) UIColor *preauthorizedTextColor;

@property (nonatomic, strong, nonnull) UIColor *approvedBackgroundColor;
@property (nonatomic, strong, nonnull) UIColor *approvedTextColor;

@property (nonatomic, strong, nonnull) UIColor *declinedBackgroundColor;
@property (nonatomic, strong, nonnull) UIColor *declinedTextColor;

@property (nonatomic, strong, nonnull) UIColor *refundedBackgroundColor;
@property (nonatomic, strong, nonnull) UIColor *refundedTextColor;

@property (nonatomic, strong, nullable) UIColor *actionButtonTextColor;



@end
