/*
 * mpos-ui : http://www.payworksmobile.com
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 payworks GmbH
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

#import "MPUTransactionActionsCell.h"

NSString * const MPUTransactionActionsCellIdentifier = @"MPUTransactionActionsCell";

@implementation MPUTransactionActionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self clearEveryThing];
}


- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self clearEveryThing];
}

- (void)clearEveryThing {
    
    self.button0FromLeft.hidden = YES;
    self.button0FromRight.hidden = YES;
    self.button1FromRight.hidden = YES;
    
    self.button0FromLeftAction = nil;
    self.button0FromRightAction = nil;
    self.button1FromRightAction = nil;
}


- (void)setAction:(MPUSCActionsCellAction)action forButton:(UIButton*)button {
    
    if (button == self.button0FromLeft) {
        self.button0FromLeftAction = action;
    }
    
    if (button == self.button0FromRight) {
        self.button0FromRightAction = action;
    }
    
    if (button == self.button1FromRight) {
        self.button1FromRightAction = action;
    }
}


- (IBAction)didTapButton0FromLeft:(id)sender {
    
    if (self.button0FromLeftAction) {
        self.button0FromLeftAction();
    }
}


- (IBAction)didTapButton0FromRight:(id)sender {
    
    if (self.button0FromRightAction) {
        self.button0FromRightAction();
    }
}


- (IBAction)didTapButton1FromRight:(id)sender {
    
    if (self.button1FromRightAction) {
        self.button1FromRightAction();
    }
}


@end
