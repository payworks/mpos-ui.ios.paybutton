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

#import "MPUMposUiConfiguration.h"
#import "MPUMposUiAppearance.h"

const NSTimeInterval MPUMposUiConfigurationResultDisplayCloseTimeout = 5.;

@interface MPUMposUiConfiguration ()

@end

@implementation MPUMposUiConfiguration


- (instancetype)init {
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    self.appearance = [[MPUMposUiAppearance alloc] init];
    self.terminalParameters = [MPAccessoryParameters mockAccessoryParameters];
    self.printerParameters = [MPAccessoryParameters mockAccessoryParameters];
    self.signatureCapture = MPUMposUiConfigurationSignatureCaptureOnScreen;
    self.summaryFeatures = MPUMposUiConfigurationSummaryFeatureNone;

    return self;
}


- (void)setTerminalFamily:(MPAccessoryFamily)terminalFamily {
    self.terminalParameters = [self defaultAccessoryParametersFromFamily:terminalFamily];
}

- (MPAccessoryFamily)terminalFamily {
    return  self.terminalParameters.accessoryFamily;
}

- (void)setPrinterFamily:(MPAccessoryFamily)printerFamily {
    self.printerParameters = [self defaultAccessoryParametersFromFamily:printerFamily];
}

- (MPAccessoryFamily)printerFamily {
    return self.printerParameters.accessoryFamily;
}

- (MPAccessoryParameters *)defaultAccessoryParametersFromFamily:(MPAccessoryFamily)accessoryFamily {
    
    switch (accessoryFamily) {
        case MPAccessoryFamilyMiuraMPI:
            return [MPAccessoryParameters externalAccessoryParametersWithFamily:accessoryFamily protocol:@"com.miura.shuttle" optionals:nil];
            
        case MPAccessoryFamilyVerifoneESeries:
            return [MPAccessoryParameters externalAccessoryParametersWithFamily:accessoryFamily protocol:@"not.used" optionals:nil];
            
        case MPAccessoryFamilyVerifoneE105:
            return [MPAccessoryParameters audioJackAccessoryParametersWithFamily:accessoryFamily optionals:nil];
            
        case MPAccessoryFamilyMock:
            return [MPAccessoryParameters mockAccessoryParameters];
            
        case MPAccessoryFamilyBBPOS:
            return [MPAccessoryParameters externalAccessoryParametersWithFamily:accessoryFamily protocol:@"not.used" optionals:nil];
            
        case MPAccessoryFamilyBBPOSChipper:
            return [MPAccessoryParameters audioJackAccessoryParametersWithFamily:accessoryFamily optionals:nil];
            
        case MPAccessoryFamilySewoo:
            return [MPAccessoryParameters externalAccessoryParametersWithFamily:accessoryFamily protocol:@"com.mobileprinter.datapath" optionals:nil];
    }
    
    return [MPAccessoryParameters mockAccessoryParameters];
}


@end
