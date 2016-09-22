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

#import "MPUAbstractMainController.h"
#import "MPUMposUiConfiguration.h"
#import "MPUMposUiAppearance.h"
#import "MPUUIHelper.h"

@interface MPUAbstractMainController ()

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *closeButton;

@end

@implementation MPUAbstractMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mposUi = [MPUMposUi sharedInitializedInstance];
    self.mposUi.error = nil; //We clear the error everytime.
    
    self.backButton = [[UIBarButtonItem alloc]initWithTitle:[MPUUIHelper localizedString:@"MPUBack"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    
    self.closeButton = [[UIBarButtonItem alloc]initWithTitle:[MPUUIHelper localizedString:@"MPUClose"] style:UIBarButtonItemStyleDone target:self action:@selector(closeButtonPressed)];
    
    self.navigationController.navigationBar.translucent = NO;
    MPUMposUiConfiguration *configuration = self.mposUi.configuration;
    if (configuration.appearance.navigationBarTint) {
        self.navigationController.navigationBar.barTintColor = configuration.appearance.navigationBarTint;
    }
    
    if (configuration.appearance.navigationBarTextColor) {
        [self.navigationController.navigationBar setTintColor:configuration.appearance.navigationBarTextColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                                                              configuration.appearance.navigationBarTextColor} ];
    }
    
    if (configuration.appearance.backgroundColor) {
        self.view.backgroundColor = self.mposUi.configuration.appearance.backgroundColor;
    }
    
    self.navigationItem.hidesBackButton = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.mposUi.configuration.appearance.statusBarStyle;
}


- (void)backButtonPressed{
    //NOOP
}

- (void)closeButtonPressed{
    //NOOP
}

#pragma mark - MPUContainerViewDelegate

- (void)titleChanged:(NSString *)title {
    if (!IS_OS_8_OR_LATER) {
        //iOS7 this fading doesnt work well. Not at all!
        self.navigationItem.title = title;
        return;
    }
    
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 0.2;
    fadeTextAnimation.type = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    self.navigationItem.title = title;
}


- (void)hideBackButton:(BOOL)hide {
    
    self.navigationItem.leftBarButtonItem = (hide)?nil:self.backButton;
}


- (void)hideCloseButton:(BOOL)hide {

    self.navigationItem.rightBarButtonItem = (hide)?nil:self.closeButton;
}


@end
