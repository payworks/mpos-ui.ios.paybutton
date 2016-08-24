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
#import "MPUAbstractContainerViewController.h"

@interface MPUAbstractContainerViewController ()

@end

@implementation MPUAbstractContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mposUi = [MPUMposUi sharedInitializedInstance];
    self.showLoginScreen = NO;
    if (self.mposUi.mposUiMode == MPUMposUiModeApplication && ![self.mposUi isApplicationLoggedIn]) {
        self.showLoginScreen = YES;
    }
}

- (void)swapToViewController:(UIViewController *)toViewController {
    self.viewTransitionInProgress = YES;
    UIView* destView = ((UIViewController *)toViewController).view;
    destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:destView];
    
    if (self.childViewControllers.count > 0) {
        //We handle this particular case of refunds in case of application selection
        UIViewController * fromViewController = [self.childViewControllers objectAtIndex:0];
        
        [fromViewController willMoveToParentViewController:nil];
        [self addChildViewController:toViewController];
        
        [self transitionFromViewController:fromViewController
                          toViewController:toViewController
                                  duration:0.2
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{}
                                completion:^(BOOL finished) {
                                    [fromViewController removeFromParentViewController];
                                    [toViewController didMoveToParentViewController:self];
                                    self.viewTransitionInProgress = NO;
                                }];
    } else {
        [self addChildViewController:toViewController];
        [toViewController didMoveToParentViewController:self];
        self.viewTransitionInProgress = NO;
    }
}

- (void)backButtonPressed {
    //NO-OP
    // Make sure to override this if you need back button behaviour.
}

- (void)closeButtonPressed {
    //NO-OP
    // Make sure to override this if you need close button behaviour
}

@end
