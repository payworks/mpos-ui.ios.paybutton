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

#import "MPUApplicationData.h"
#import "MPUMposUi.h"
#import "MPUUIHelper.h"

@implementation MPUApplicationData

- (instancetype)initWithApplication:(MPUApplicationName)applicationName {
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    NSDictionary *applicationDictionary = [self applicationDictionaryForApplicationName:applicationName];
    self.applicationName = applicationName;
    self.identifier = [applicationDictionary objectForKey:@"applicationIdentifier"];
    self.helpUrl = [self generateHelpUrl];
    self.applicationLogo = [self logoForApplication];
    
    self.configuration = [[MPUMposUiConfiguration alloc]init];
    self.configuration.appearance.navigationBarTextColor =  [MPUUIHelper colorFromHexString:[applicationDictionary objectForKey:@"navigationBarTextColor"]];
    self.configuration.appearance.navigationBarTint = [MPUUIHelper colorFromHexString:[applicationDictionary objectForKey:@"navigationBarTint"]];
    self.configuration.appearance.backgroundColor = [MPUUIHelper colorFromHexString:[applicationDictionary objectForKey:@"backgroundColor"]];
    self.configuration.printerParameters = [self printerParametersForFamily:[applicationDictionary objectForKey:@"printerFamily"]];
    self.configuration.terminalParameters = [self terminalParametersForFamily:[applicationDictionary objectForKey:@"terminalFamily"]];
    self.configuration.summaryFeatures = [self summaryFeatures:applicationDictionary];
    self.configuration.signatureCapture = MPUMposUiConfigurationSignatureCaptureOnScreen;
    
    return self;
}


- (NSDictionary *)applicationDictionaryForApplicationName:(MPUApplicationName) applicationName {
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[self plistPathForApplication:applicationName]];
    
    return dictionary;
}


- (NSString *)plistPathForApplication:(MPUApplicationName) applicationName {

    switch (applicationName) {
        case MPUApplicationNameMcashier:
            return [[MPUUIHelper frameworkBundle] pathForResource:@"mcashier" ofType:@"plist"];
            
        case MPUApplicationNameConcardis:
            return [[MPUUIHelper frameworkBundle] pathForResource:@"concardis" ofType:@"plist"];

        case MPUApplicationNameSecureRetail:
            return [[MPUUIHelper frameworkBundle] pathForResource:@"secureretail" ofType:@"plist"];

        case MPUApplicationNameYourBrand:
            return [[MPUUIHelper frameworkBundle] pathForResource:@"yourbrand" ofType:@"plist"];
    }
    
    return @"";
}


- (UIImage *)logoForApplication {

    NSString *image = [self imageNameForApplication:self.applicationName];
    
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:image inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[[MPUUIHelper frameworkBundle] pathForResource:image ofType:@".png"]];
    }
}


- (NSString*)imageNameForApplication:(MPUApplicationName)applicationName {
    
    switch (applicationName) {
        case MPUApplicationNameMcashier:
            return @"mCashier";

        case MPUApplicationNameConcardis:
            return @"ConCardis";

        case MPUApplicationNameSecureRetail:
            return @"SecureRetail";

        case MPUApplicationNameYourBrand:
            return @"YourBrand";
    }

    return @"";
}



- (MPAccessoryParameters*)printerParametersForFamily:(NSString*)printer {
    
    MPAccessoryParameters *accessoryParameters = nil;
    
    if ([printer isEqualToString:@"Sewoo"]) {
        accessoryParameters = [MPAccessoryParameters externalAccessoryParametersWithFamily:MPAccessoryFamilySewoo protocol:@"com.mobileprinter.datapath" optionals:nil];
    } else {
        accessoryParameters = [MPAccessoryParameters mockAccessoryParameters];
    }
    
    return accessoryParameters;
}


- (MPAccessoryParameters*)terminalParametersForFamily:(NSString*)terminal {
    
    MPAccessoryParameters *terminalParameters = nil;
    
    if([terminal isEqualToString:@"Miura"]) {
        terminalParameters = [MPAccessoryParameters externalAccessoryParametersWithFamily:MPAccessoryFamilyMiuraMPI protocol:@"com.miura.shuttle" optionals:nil];
    } else if ([terminal isEqualToString:@"VerifoneE105"]) {
        terminalParameters = [MPAccessoryParameters audioJackAccessoryParametersWithFamily:MPAccessoryFamilyVerifoneE105 optionals:nil];
    } else {
        terminalParameters = [MPAccessoryParameters mockAccessoryParameters];
    }
    
    return terminalParameters;
}


- (MPUMposUiConfigurationSummaryFeature)summaryFeatures:(NSDictionary *)dictionary {
    BOOL printReceiptEnabled = [[dictionary objectForKey:@"featureSummaryPrintReceipt"] boolValue];
    BOOL sendReceiptEnabled = [[dictionary objectForKey:@"featureSummarySendReceipt"] boolValue];
    BOOL refundEnabled = [[dictionary objectForKey:@"featureSummaryRefund"] boolValue];
    
    MPUMposUiConfigurationSummaryFeature features = MPUMposUiConfigurationSummaryFeatureNone;
    
    if(printReceiptEnabled) {
        features = features | MPUMposUiConfigurationSummaryFeaturePrintReceipt;
    }
    if (sendReceiptEnabled) {
        features = features | MPUMposUiConfigurationSummaryFeatureSendReceiptViaEmail;
    }
    if (refundEnabled) {
        features = features | MPUMposUiConfigurationSummaryFeatureRefundTransaction;
    }
    
    return features;
}

- (NSURL *)generateHelpUrl {
    NSString *liveUrlString = @"https://services.pwtx.info";
    NSString *redirectBaseString = [NSString stringWithFormat:@"applications/%@/redirects", self.identifier];
    NSString *helpEndpoint = @"help";
    
    NSString *redirectUrlString = [NSString stringWithFormat:@"%@/%@/%@",liveUrlString, redirectBaseString, helpEndpoint];
    
    NSString *localizedUrlString = [NSString stringWithFormat:@"%@?language=%@",redirectUrlString ,[self localizationString]];

    return [NSURL URLWithString:localizedUrlString];
}

- (NSString *)localizationString {
    return [[[MPUUIHelper frameworkBundle] preferredLocalizations] objectAtIndex:0];
}

@end
