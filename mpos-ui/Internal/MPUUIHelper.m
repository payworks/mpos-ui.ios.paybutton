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

#import "MPUUIHelper.h"
#import "MPUMposUi_Internal.h"
#import "MPUMposUiAppearance.h"
#import "MPUMposUiConfiguration.h"
#import <CoreText/CoreText.h>

NSString *const MPUUIHelperFrameworkBundleName = @"mpos-ui-resources";

@implementation MPUUIHelper

+ (NSBundle *)frameworkBundle {
    static NSBundle *frameworkBundle = nil;
    static dispatch_once_t frameworkBundleOnce;
    dispatch_once(&frameworkBundleOnce, ^{
        
        frameworkBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"mpos-ui-resources" withExtension:@"bundle"]];
        DDLogDebug(@"bundle found: %@", ((frameworkBundle) ? @"YES" : @"NO"));
    });
    return frameworkBundle;
}

+ (void)loadIconFont{
    // register the font:
    static dispatch_once_t loadIconFontOnce;
    dispatch_once(&loadIconFontOnce, ^{
        NSURL *url = [[MPUUIHelper frameworkBundle] URLForResource:@"FontAwesome" withExtension:@"otf"];
        NSData *fontData = [NSData dataWithContentsOfURL:url];
        if (fontData) {
            CFErrorRef error;
            CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
            CGFontRef font = CGFontCreateWithDataProvider(provider);
            if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
                CFStringRef errorDescription = CFErrorCopyDescription(error);
                DDLogError(@"Failed to load font: %@", errorDescription);
                CFRelease(errorDescription);
            }
            CFRelease(font);
            CFRelease(provider);
        }
    });

}

+ (BOOL)isStringEmpty:(NSString *)string {
    if ([string length] == 0) {
        return YES;
    }

    return ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
}

+ (NSString *)defaultControllerTitleBasedOnParameters:(MPTransactionParameters *)parameters
                                          transaction:(MPTransaction *)transaction
                                              toolbox:(MPLocalizationToolbox *)toolbox {

    NSString *token = [self titleTokenForParameters:parameters];
    
    
    NSString *title = [MPUUIHelper localizedString:token];
    
    if (transaction) {
        NSString *titleAmount = [toolbox textFormattedForAmount:transaction.amount currency:transaction.currency];
        title = [title stringByAppendingFormat:@": %@", titleAmount];
    }

    return title;
}


+ (NSString*)titleTokenForParameters:(MPTransactionParameters*)parameters {
    
    switch (parameters.parametersType) {
            
        case MPTransactionParametersTypeCharge:
            return @"MPUSale";
            
        case MPTransactionParametersTypeRefund:
            return @"MPURefund";
            
        case MPTransactionParametersTypeCapture:
            return @"MPUCapture";
    }
}


+ (NSDictionary*)actionButtonTitleAttributesBold:(BOOL)bold {
    
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [self buttonTitleColor],
                                 NSFontAttributeName : [self fontForBold:bold]};
    
    return attributes;
}


+ (UIColor*)buttonTitleColor {
    
     MPUMposUiAppearance *appearance = [[[MPUMposUi sharedInitializedInstance] configuration] appearance];
    
    if (appearance.actionButtonTextColor) {
        return appearance.actionButtonTextColor;
    }
    
    if (appearance.navigationBarTint) {
        return appearance.navigationBarTint;
    }
    
    return [UIColor blackColor];
}


+ (UIFont*)fontForBold:(BOOL)bold {
    
    const CGFloat fontSize = 17.0;
    
    if (bold) {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
    
    return [UIFont systemFontOfSize:fontSize];
}




// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (NSString *)localizedString:(NSString *)token {
    if (!token) return @"";
    
    //here we check for three different occurances where it can be found
    
    //first up is the app localization
    NSString *appSpecificLocalizationString = NSLocalizedString(token, @"");
    if (![token isEqualToString:appSpecificLocalizationString])
    {
        return appSpecificLocalizationString;
    }
    
    //second is the app localization with specific table
    NSString *appSpecificLocalizationStringFromTable = NSLocalizedStringFromTable(token, @"mpos-ui", @"");
    if (![token isEqualToString:appSpecificLocalizationStringFromTable])
    {
        return appSpecificLocalizationStringFromTable;
    }
    
    //third time is the charm, looking in our resource bundle
    if ([self frameworkBundle])
    {
        NSString *bundleSpecificLocalizationString = NSLocalizedStringFromTableInBundle(token, @"mpos-ui", [self frameworkBundle], @"");
        if (![token isEqualToString:bundleSpecificLocalizationString])
        {
            return bundleSpecificLocalizationString;
        }
    }
    
    //and as a fallback, we just return the token itself
    DDLogError(@"could not find any localization files. please check that you added the resource bundle and/or your own localizations");
    return token;
}



@end