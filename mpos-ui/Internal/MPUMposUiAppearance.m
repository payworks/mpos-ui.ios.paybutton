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

#import "MPUMposUiAppearance.h"
#import "MPUUIHelper.h"

@interface MPUMposUiAppearance ()

@end

@implementation MPUMposUiAppearance


- (instancetype)init {

    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.navigationBarTextColor = [UIColor whiteColor];
    self.navigationBarTint = [MPUUIHelper colorFromHexString:@"#0D2048"];
    self.backgroundColor = [MPUUIHelper colorFromHexString:@"#F7F5F4"];
    self.statusBarStyle = UIStatusBarStyleDefault;
    
    self.preauthorizedBackgroundColor = [MPUUIHelper colorFromHexString:@"#DCA54C"];
    self.preauthorizedTextColor  = [MPUUIHelper colorFromHexString:@"#FFFFFF"];
    
    self.approvedBackgroundColor = [MPUUIHelper colorFromHexString:@"#638D31"];
    self.approvedTextColor = [MPUUIHelper colorFromHexString:@"#FFFFFF"];
    
    self.declinedBackgroundColor = [MPUUIHelper colorFromHexString:@"#B03B3B"];
    self.declinedTextColor = [MPUUIHelper colorFromHexString:@"#FFFFFF"];
    
    self.refundedBackgroundColor = [MPUUIHelper colorFromHexString:@"#3F6CA1"];
    self.refundedTextColor = [MPUUIHelper colorFromHexString:@"#FFFFFF"];
    
    self.actionButtonTextColor = nil;
    
    return self;
}

@end
