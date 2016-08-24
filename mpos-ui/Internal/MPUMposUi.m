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

#import "MPUMposUi_Internal.h"
#import "MPUUIHelper.h"
#import "MPUMposUiConfiguration.h"
#import "MPUApplicationData.h"
#import "MPUSummaryMainController.h"
#import "MPUTransactionMainController.h"
#import "MPUPrintReceiptmainController.h"
#import "MPUSettingsMainController.h"
#import "MPULoginMainController.h"
#import <Lockbox/Lockbox.h>

NSString *const MPMposUiSDKVersion = @"2.11.1";

NSString *const MPUKeychainUsername =               @"MPUKeychainUsername";
NSString *const MPUKeychainMerchantIdentifier =     @"MPUKeychainMerchantIdentifier";
NSString *const MPUKeychainMerchantSecretKey =      @"MPUKeychainMerchantSecretKey";
NSString *const MPUKeychainApplicationIdentifier =  @"MPUKeychainApplicationIdentifier";

static MPUMposUi *mpu_mposUiInstance;

@implementation MPUMposUi


+ (NSString *)version
{
    return MPMposUiSDKVersion;
}

+ (id)initializeWithProviderMode:(MPProviderMode)providerMode merchantIdentifier:(NSString *)merchantIdentifier merchantSecret:(NSString *)merchantSecret {
    [MPUUIHelper loadIconFont];
    mpu_mposUiInstance = [[MPUMposUi alloc] initWithProvider:providerMode identifier:merchantIdentifier secret:merchantSecret];
    return mpu_mposUiInstance;
}

+ (id)initializeWithApplication:(MPUApplicationName)applicationName integratorIdentifier:(NSString *)integratorIdentifier {
    mpu_mposUiInstance = [[MPUMposUi alloc] initWithProvider:MPProviderModeLIVE application:applicationName integratorIdentifier:integratorIdentifier];
    return mpu_mposUiInstance;
}


+ (instancetype)initializeWithProviderMode:(MPProviderMode)providerMode application:(MPUApplicationName)applicationName integratorIdentifier:(NSString *)integratorIdentifier {
    [MPUUIHelper loadIconFont];
    mpu_mposUiInstance = [[MPUMposUi alloc] initWithProvider:providerMode application:applicationName integratorIdentifier:integratorIdentifier];
    return mpu_mposUiInstance;
}

+ (MPUMposUi *)sharedInitializedInstance {
    return mpu_mposUiInstance;
}

- (id)initWithProvider:(MPProviderMode)providerMode identifier:(NSString *)merchantIdentifier secret:(NSString *)merchantSecret {
    
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.mposUiMode = MPUMposUiModeProvider;
    self.providerMode = providerMode;
    self.applicationData = nil;
    self.merchantIdentifier = merchantIdentifier;
    self.merchantSecretKey = merchantSecret;
    self.username = nil;
    
    self.configuration = [[MPUMposUiConfiguration alloc] init];
    self.transactionProvider = [MPMpos transactionProviderForMode:self.providerMode merchantIdentifier:self.merchantIdentifier merchantSecretKey:self.merchantSecretKey];
    
    return self;
}

- (id)initWithProvider:(MPProviderMode)providerMode application:(MPUApplicationName)applicationName integratorIdentifier:(NSString *)integratorIdentifier {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    if (integratorIdentifier == nil || [integratorIdentifier length] == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Integrator identifier cannot be nil / empty"
                                     userInfo:nil];
    }
    
    self.mposUiMode = MPUMposUiModeApplication;
    self.applicationData =  [[MPUApplicationData alloc] initWithApplication:applicationName];
    
    if (providerMode == MPProviderModeMOCK) {
        self.applicationData.configuration.terminalParameters = [MPAccessoryParameters mockAccessoryParameters];
        self.applicationData.configuration.printerParameters = [MPAccessoryParameters mockAccessoryParameters];
    }
    
    self.configuration = self.applicationData.configuration;
    self.integratorIdentifier = integratorIdentifier;
    self.providerMode = providerMode;
    self.merchantIdentifier = [Lockbox stringForKey:MPUKeychainMerchantIdentifier];
    self.merchantSecretKey = [Lockbox stringForKey:MPUKeychainMerchantSecretKey];
    self.username = [Lockbox stringForKey:MPUKeychainUsername];
    NSString *applicationIdentifier = [Lockbox stringForKey:MPUKeychainApplicationIdentifier];

    if(self.merchantIdentifier != nil && self.merchantSecretKey !=nil) {
        // Make sure the user is using the same application used to log in with.
        if (applicationIdentifier != nil && [applicationIdentifier isEqualToString:self.applicationData.identifier]) {
            self.transactionProvider = [MPMpos transactionProviderForMode:self.providerMode merchantIdentifier:self.merchantIdentifier merchantSecretKey:self.merchantSecretKey];
        } else {
            [self clearMerchantCredentialsIncludingUsername:YES];
        }
    }
    
    return self;
}

- (void)storeMerchantCredentials:(NSString *)merchantIdentifier merchantSecretKey:(NSString *)merchantSecretKey username:(NSString *)username {
    self.merchantIdentifier = merchantIdentifier;
    self.merchantSecretKey = merchantSecretKey;
    self.username = username;
    self.transactionProvider = [MPMpos transactionProviderForMode:self.providerMode merchantIdentifier:self.merchantIdentifier merchantSecretKey:self.merchantSecretKey];
    
    [Lockbox setString:merchantIdentifier forKey:MPUKeychainMerchantIdentifier];
    [Lockbox setString:merchantSecretKey forKey:MPUKeychainMerchantSecretKey];
    [Lockbox setString:username forKey:MPUKeychainUsername];
    [Lockbox setString:self.applicationData.identifier forKey:MPUKeychainApplicationIdentifier];
}

- (void)clearMerchantCredentialsIncludingUsername:(BOOL)clearUsername {
    [Lockbox setString:nil forKey:MPUKeychainMerchantIdentifier];
    [Lockbox setString:nil forKey:MPUKeychainMerchantSecretKey];
    [Lockbox setString:nil forKey:MPUKeychainApplicationIdentifier];

    if(clearUsername){
        [Lockbox setString:nil forKey:MPUKeychainUsername];
        self.username = nil;
    }
    
    self.merchantIdentifier = nil;
    self.merchantSecretKey = nil;
    self.transactionProvider = nil;
}


- (UIViewController *)createTransactionViewControllerWithSessionIdentifier:(NSString *)sessionIdentifier completed:(MPUTransactionCompleted)completed {
    if (self.mposUiMode != MPUMposUiModeProvider) {
        [self throwExceptionForWrongMode:MPUMposUiModeProvider];
    }
    
    MPUTransactionMainController *transactionMainController = [self createTransactionViewControllerWithCompleted:completed];
    transactionMainController.sessionIdentifier = sessionIdentifier;
    
    return transactionMainController;
}


- (UIViewController *)createChargeTransactionViewControllerWithAmount:(NSDecimalNumber *)amount currency:(MPCurrency)currency subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier completed:(MPUTransactionCompleted)completed {

    
    MPTransactionParameters *parameters = [MPTransactionParameters chargeWithAmount:amount currency:currency optionals:^(id<MPTransactionParametersOptionals> optionals) {
        
        optionals.subject = subject;
        
        if (self.mposUiMode == MPUMposUiModeProvider) {
            optionals.customIdentifier = customIdentifier;
        } else {
            optionals.customIdentifier = [NSString stringWithFormat:@"%@-%@", self.integratorIdentifier, customIdentifier];
        }

    }];
    
    return [self createTransactionViewControllerWithTransactionParameters:parameters completed:completed];
}

- (UIViewController *)createRefundTransactionViewControllerWithTransactionIdentifer:(NSString *)transactionIndentifier subject:(NSString *)subject customIdentifier:(NSString *)customIdentifier completed:(MPUTransactionCompleted)completed {
    
    MPTransactionParameters *parameters = [MPTransactionParameters refundForTransactionIdentifier:transactionIndentifier optionals:^(id<MPTransactionParametersRefundOptionals>  _Nonnull optionals) {
        
        optionals.subject = subject;
        
        if (self.mposUiMode == MPUMposUiModeProvider) {
            optionals.customIdentifier = customIdentifier;
        } else {
            optionals.customIdentifier = [self generateCustomIdentifier:customIdentifier forIntegratorIdentifier:self.integratorIdentifier];
        }
    }];
    
    return [self createTransactionViewControllerWithTransactionParameters:parameters completed:completed];
}


- (UIViewController *)createTransactionViewControllerWithTransactionParameters:(MPTransactionParameters *)transactionParameters completed:(MPUTransactionCompleted)completed {
 
   return [self createTransactionViewControllerWithTransactionParameters:transactionParameters processParameters:nil completed:completed];
}


- (UIViewController *)createTransactionViewControllerWithTransactionParameters:(MPTransactionParameters *)transactionParameters processParameters:(MPTransactionProcessParameters *)processParameters completed:(MPUTransactionCompleted)completed {

    MPUTransactionMainController *transactionMainController = [self createTransactionViewControllerWithCompleted:completed];
    
    if (self.mposUiMode == MPUMposUiModeProvider) {
        transactionMainController.parameters = transactionParameters;
    } else {
        NSString *customIdentifier = [self generateCustomIdentifier:transactionParameters.customIdentifier forIntegratorIdentifier:self.integratorIdentifier];
        transactionMainController.parameters = [self generateTransactionParameters:transactionParameters forCustomIdentifier:customIdentifier];
    }
    
    transactionMainController.processParameters = processParameters;
    
    return transactionMainController;
}


#pragma mark - Private

- (UIViewController *)createSummaryViewControllerWithTransactionIdentifier:(NSString *)transactionIdentifier completed:(MPUSummaryCompleted)completed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mpos-ui" bundle:[MPUUIHelper frameworkBundle]];
    MPUSummaryMainController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"MPUSummaryMainController"];
    viewController.transactionIdentifer = transactionIdentifier;
    viewController.completed = completed;
    return viewController;
}

- (MPUTransactionMainController *)createTransactionViewControllerWithCompleted:(MPUTransactionCompleted)completed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mpos-ui" bundle:[MPUUIHelper frameworkBundle]];
    MPUTransactionMainController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MPUTransactionMainController"];
    viewController.completed = completed;
    return viewController;
}


- (UIViewController *)createPrintTransactionViewControllerWithTransactionIdentifier:(NSString *)transactionIdentifier completed:(MPUPrintReceiptCompleted)completed {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mpos-ui" bundle:[MPUUIHelper frameworkBundle]];
    MPUPrintReceiptMainController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MPUPrintReceiptMainController"];
    viewController.transactionIdentifer = transactionIdentifier;
    viewController.completed = completed;
    return viewController;
}

- (UIViewController *)createSettingsViewController:(MPUSettingsCompleted)completed {
    if (self.mposUiMode != MPUMposUiModeApplication) {
        [self throwExceptionForWrongMode:MPUMposUiModeApplication];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mpos-ui" bundle:[MPUUIHelper frameworkBundle]];
    MPUSettingsMainController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MPUSettingsMainController"];
    viewController.completed = completed;
    return viewController;
}

- (UIViewController *)createLoginViewController:(MPULoginCompleted)completed {
    if (self.mposUiMode != MPUMposUiModeApplication) {
        [self throwExceptionForWrongMode:MPUMposUiModeApplication];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mpos-ui" bundle:[MPUUIHelper frameworkBundle]];
    MPULoginMainController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MPULoginMainController"];
    viewController.completed = completed;
    return viewController;
}

- (void)logoutFromApplication {
    if (self.mposUiMode != MPUMposUiModeApplication) {
        [self throwExceptionForWrongMode:MPUMposUiModeApplication];
    } else {
        [self clearMerchantCredentialsIncludingUsername:NO];
        [Lockbox setString:nil forKey:MPUKeychainUsername];
    }
}

- (BOOL)isApplicationLoggedIn {
    if (self.mposUiMode != MPUMposUiModeApplication) {
        [self throwExceptionForWrongMode:MPUMposUiModeApplication];
    } else if (self.transactionProvider != nil) {
        return YES;
    }
    return NO;
}

- (void)throwExceptionForWrongMode:(MPUMposUiMode)mode {
    if (mode == MPUMposUiModeApplication) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"This method is only available if the MPUMposUi is initialzed with an Application"
                                     userInfo:nil];
    } else if (mode == MPUMposUiModeProvider) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"This method is only available if the MPUMposUi is initialzed with a Provider"
                                     userInfo:nil];
    }
    
}

- (NSString *)generateCustomIdentifier:(NSString *)customIdentifier forIntegratorIdentifier:(NSString *)integratorIdentifier {
    if (customIdentifier != nil || [customIdentifier length] != 0) {
        return [NSString stringWithFormat:@"%@-%@", integratorIdentifier, customIdentifier];
    }
    return integratorIdentifier;
}

- (MPTransactionParameters *)generateTransactionParameters:(MPTransactionParameters *) transactionParameters forCustomIdentifier:(NSString *)customIdentifier {
    if(transactionParameters.transactionType == MPTransactionTypeCharge) {
        return [MPTransactionParameters chargeWithAmount:transactionParameters.amount
                                                currency:transactionParameters.currency
                                                optionals:^(id<MPTransactionParametersOptionals> optionals) {
                                                    optionals.subject = transactionParameters.subject;
                                                    optionals.customIdentifier = customIdentifier;
                                                    optionals.statementDescriptor = transactionParameters.statementDescriptor;
                                                    optionals.metadata = transactionParameters.metadata;
                                                    optionals.applicationFee = transactionParameters.applicationFee;
                                                }];
    }
    
    // Refund
    return [MPTransactionParameters refundForTransactionIdentifier:transactionParameters.referencedTransactionIdentifier
                                                         optionals:^(id<MPTransactionParametersRefundOptionals>  _Nonnull optionals) {
                                                             optionals.subject = transactionParameters.subject;
                                                             optionals.customIdentifier = customIdentifier;
                                                         }];
}

@end
