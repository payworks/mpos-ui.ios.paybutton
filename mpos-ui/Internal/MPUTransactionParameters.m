/*
 * mpos-ui : http://www.payworksmobile.com
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 payworks GmbH
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

#import "MPUTransactionParameters.h"

@implementation MPUTransactionParameters {

}
- (instancetype)initWithSessionIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.sessionIdentifier = identifier;
    }
    return self;
}

- (instancetype)initWithAmount:(NSDecimalNumber *)amount currency:(MPCurrency)currency subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier {
    self = [super init];
    if (self) {
        self.amount = amount;
        self.currency = currency;
        self.subject = subject;
        self.customIdentifier = customIdentifier;
    }
    return self;
}

- (instancetype)initWithAmount:(NSDecimalNumber *)amount currency:(MPCurrency)currency subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier integratorIdentifier:(NSString *)integratorIdentifier {
    self = [super init];
    if (self) {
        self.amount = amount;
        self.currency = currency;
        self.subject = subject;
        if (customIdentifier) {
            self.customIdentifier = [NSString stringWithFormat:@"%@-%@", integratorIdentifier, customIdentifier];
        } else {
            self.customIdentifier = integratorIdentifier;
        }
    }
    return self;
}

-(instancetype)initWithTransactionIdentifier:(NSString *)transactionIndentifier subject:(NSString *)subject customIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.transactionIdentifier = transactionIndentifier;
        self.subject = subject;
        self.customIdentifier = identifier;
    }
    return self;
}

- (instancetype)initWithTransactionIdentifier:(NSString *)transactionIndentifier subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier integratorIdentifier:(NSString *)integratorIdentifier {
    self = [super init];
    if (self) {
        self.transactionIdentifier = transactionIndentifier;
        self.subject = subject;
        if (customIdentifier) {
            self.customIdentifier = [NSString stringWithFormat:@"%@-%@", integratorIdentifier, customIdentifier];
        } else {
            self.customIdentifier = integratorIdentifier;
        }
    }
    return self;
}

@end
