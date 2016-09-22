/*
 * mpos-ui-sample : http://www.payworks.com
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

#import "ViewController.h"
#import <mpos-ui/mpos-ui.h>
#import <mpos.core/mpos-extended.h>
#import <UIView+Toast.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

NSString *const CheckoutControllerMerchantIdentifier    = @"merchant_identifier";
NSString *const CheckoutControllerMerchantSecret        = @"merchant_secret";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mposUiVersion;
@property (weak, nonatomic) IBOutlet UILabel *mposSdkVersion;
@property (weak, nonatomic) IBOutlet UIButton *summaryButton;
@property (weak, nonatomic) IBOutlet UIButton *printButton;
@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UIButton *customReceiptButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@property (nonatomic, strong) MPUMposUi *mposUi;
@property (nonatomic, strong) MPTransaction *lastTransaction;
@property (nonatomic, assign) BOOL applicationMode;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x0d2048)];
    // Do any additional setup after loading the view, typically from a nib.
    self.mposUiVersion.text = [self.mposUiVersion.text stringByAppendingString:[MPUMposUi version]];
    self.mposSdkVersion.text = [self.mposSdkVersion.text stringByAppendingString:[MPMpos version]];
    
    [self enableLastTransactionActions:NO transaction:nil];
    
    //Initializing in the test mode.
    [self initWithTestProvider:nil];
}


- (void)enableLastTransactionActions:(BOOL)enabled transaction:(MPTransaction *) transaction {
    self.lastTransaction = transaction;
    self.summaryButton.enabled = enabled;
    self.printButton.enabled = enabled;
    self.refundButton.enabled = enabled;
    self.customReceiptButton.enabled = enabled;
    self.captureButton.enabled = enabled;
}


- (void)startMockPayment:(NSString *)amount {
    self.mposUi = [MPUMposUi initializeWithProviderMode:MPProviderModeMOCK merchantIdentifier:CheckoutControllerMerchantIdentifier merchantSecret:CheckoutControllerMerchantSecret];
    self.mposUi.configuration.terminalParameters = [MPAccessoryParameters mockAccessoryParameters];   // Using a mock accessory
    self.mposUi.configuration.printerParameters = [MPAccessoryParameters mockAccessoryParameters];    // Using a mock printer
    
    self.mposUi.configuration.appearance.navigationBarTint = UIColorFromRGB(0x4562a1);          // Color of the navigation bar
    self.mposUi.configuration.appearance.navigationBarTextColor = UIColorFromRGB(0xFFFFFF);     // Color of the text in the navigation bar
    self.mposUi.configuration.appearance.backgroundColor = UIColorFromRGB(0xF7F5F4);            // Background color is customizable. Recommended light colors.
    
    // Features the summary screen should have.
    self.mposUi.configuration.summaryFeatures = MPUMposUiConfigurationSummaryFeaturePrintReceipt |
                                                MPUMposUiConfigurationSummaryFeatureRefundTransaction |
                                                MPUMposUiConfigurationSummaryFeatureSendReceiptViaEmail;
    
    
    MPTransactionParameters *parameters = [MPTransactionParameters chargeWithAmount:[NSDecimalNumber decimalNumberWithString:amount]
                                                                           currency:MPCurrencyEUR
                                                                          optionals:^(id<MPTransactionParametersOptionals> optionals) {
                                                                              
                                                                              optionals.subject = @"Subject";
                                                                          }];
    
    UIViewController *viewController = [self.mposUi createTransactionViewControllerWithTransactionParameters:parameters completed:^(UIViewController *controller, MPUTransactionResult result, MPTransaction *transaction) {
        
        [controller dismissViewControllerAnimated:YES completion:nil];
        if (result == MPUTransactionResultApproved) {
            [self.view makeToast:@"Transaction approved" duration:2.0 position:CSToastPositionBottom];
        } else {
            [self.view makeToast:@"Transaction failed" duration:2.0 position:CSToastPositionBottom];
        }
        [self enableLastTransactionActions:YES transaction:transaction];
    }];
    [self displayViewController:viewController];
}



- (void)startTestPaymentOnMiuraWithAmount:(NSString *)amount tipAmount:(NSString*)tipAmount autocapture:(BOOL)autocapture  {
    
    [self startTestPayment:amount tipAmount:tipAmount autocapture:autocapture withAccessoryParameters:[MPAccessoryParameters externalAccessoryParametersWithFamily:MPAccessoryFamilyMiuraMPI
                                                                                                                                            protocol:@"com.miura.shuttle"
                                                                                                                                           optionals:nil]];
}



- (void)startTestPayment:(NSString *)amount withAccessoryParameters:(MPAccessoryParameters*)accessoryParameters {
    // Usually you only need initialize the provider only once in your app. Since the configuration is with MOCK configuration currently, we reinitialize again with TEST.
    
    [self startTestPayment:amount tipAmount:nil autocapture:YES withAccessoryParameters:accessoryParameters];
}


- (void)startTestPayment:(NSString *)amount tipAmount:(NSString*)tipAmount autocapture:(BOOL)autocapture withAccessoryParameters:(MPAccessoryParameters*)accessoryParameters {
    // Usually you only need initialize the provider only once in your app. Since the configuration is with MOCK configuration currently, we reinitialize again with TEST.
    
    if (!self.applicationMode) {
        [self initializeWithProvider];
        self.mposUi.configuration.terminalParameters = accessoryParameters;
    }
    
    MPTransactionParameters *parameters = [MPTransactionParameters chargeWithAmount:[NSDecimalNumber decimalNumberWithString:amount]
                                                                           currency:MPCurrencyEUR
                                                                          optionals:^(id<MPTransactionParametersOptionals> optionals) {
                                                                              optionals.subject = @"Subject";
                                                                              optionals.autoCapture = autocapture;
                                                                          }];
    
    
    
    MPTransactionProcessParameters *processParams = nil;
    
    if (tipAmount) {
        
        processParams = [MPTransactionProcessParameters parametersWithSteps:^(id<MPTransactionProcessParametersSteps>  _Nonnull steps) {
            
            [steps addAskForTipStepWithSuggestedAmount:[NSDecimalNumber decimalNumberWithString:tipAmount]];
        }];
    }


    
    UIViewController *viewController = [self.mposUi createTransactionViewControllerWithTransactionParameters:parameters processParameters:processParams completed:^(UIViewController *controller, MPUTransactionResult result, MPTransaction *transaction) {
        
        [controller dismissViewControllerAnimated:YES completion:nil];
        if (result == MPUTransactionResultApproved) {
            [self.view makeToast:@"Transaction approved" duration:2.0 position:CSToastPositionBottom];
        } else {
            [self.view makeToast:@"Transaction failed" duration:2.0 position:CSToastPositionBottom];
        }
        [self enableLastTransactionActions:YES transaction:transaction];
    }];
    [self displayViewController:viewController];
}



- (void)initializeWithProvider {
    self.mposUi = [MPUMposUi initializeWithProviderMode:MPProviderModeTEST merchantIdentifier:CheckoutControllerMerchantIdentifier merchantSecret:CheckoutControllerMerchantSecret];
    self.mposUi.configuration.printerParameters = [MPAccessoryParameters externalAccessoryParametersWithFamily:MPAccessoryFamilySewoo protocol:@"com.mobileprinter.datapath" optionals:nil];    // Using a SEWOO printer
    
    self.mposUi.configuration.appearance.navigationBarTint = UIColorFromRGB(0x0d2048);          // Color of the navigation bar
    self.mposUi.configuration.appearance.navigationBarTextColor = UIColorFromRGB(0xFFFFFF);     // Color of the text in the navigation bar
    self.mposUi.configuration.appearance.backgroundColor = UIColorFromRGB(0xF7F5F4);            // Background color is customizable. Recommended light colors.
    
    // Features the summary screen should have.
    self.mposUi.configuration.summaryFeatures = MPUMposUiConfigurationSummaryFeaturePrintReceipt |
    MPUMposUiConfigurationSummaryFeatureRefundTransaction |
    MPUMposUiConfigurationSummaryFeatureCaptureTransaction |
    MPUMposUiConfigurationSummaryFeatureSendReceiptViaEmail;
}


- (void)showSummary:(NSString *)transactionIdentifier {
    // We make use of the exisiting mposUi configurations.
    
    UIViewController *viewController = [self.mposUi createSummaryViewControllerWithTransactionIdentifier:transactionIdentifier completed:^(UIViewController *controller) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        [self.view makeToast:@"Summary Completed" duration:2.0 position:CSToastPositionBottom];
    }];
    [self displayViewController:viewController];
}

- (void)printReceipt:(NSString *)transactionIdentifier {
    UIViewController *viewController = [self.mposUi createPrintTransactionViewControllerWithTransactionIdentifier:transactionIdentifier completed:^(UIViewController *controller, MPUPrintReceiptResult result) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        if(result == MPUPrintReceiptResultSuccessful){
            [self.view makeToast:@"Printing Successful" duration:2.0 position:CSToastPositionBottom];
        } else {
            [self.view makeToast:@"Printing Failed" duration:2.0 position:CSToastPositionBottom];
        }
    }];
    
    [self displayViewController:viewController];
}

- (void)startCapture:(NSString *)transactionIdentifier {
    
    MPTransactionParameters *params = [MPTransactionParameters captureTransactionWithIdentifier:transactionIdentifier optionals:nil];
    
    UIViewController *viewController = [self.mposUi createTransactionViewControllerWithTransactionParameters:params completed:^(UIViewController *controller, MPUTransactionResult result, MPTransaction *transaction) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        if (result == MPUTransactionResultApproved) {
            [self.view makeToast:@"Captured" duration:2.0 position:CSToastPositionBottom];
        } else {
            [self.view makeToast:@"Capture Failed" duration:2.0 position:CSToastPositionBottom];
        }
    }];
    
    [self displayViewController:viewController];
}



- (void)startRefund:(NSString *)transactionIdentifier {
    MPTransactionParameters *params = [MPTransactionParameters refundForTransactionIdentifier:transactionIdentifier optionals:^(id<MPTransactionParametersRefundOptionals> optionals) {
        optionals.subject = self.lastTransaction.subject;
    }];
    
    UIViewController *viewController = [self.mposUi createTransactionViewControllerWithTransactionParameters:params completed:^(UIViewController *controller, MPUTransactionResult result, MPTransaction *transaction) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        if (result == MPUTransactionResultApproved) {
            [self.view makeToast:@"Refund approved" duration:2.0 position:CSToastPositionBottom];
        } else {
            [self.view makeToast:@"Refund failed" duration:2.0 position:CSToastPositionBottom];
        }
    }];
    
    [self displayViewController:viewController];
}

- (void)displayViewController:(UIViewController *)viewController {
    // We want to wrap the view Controllers in a navigation controller and present it.
    UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:viewController];
    modalNav.modalPresentationStyle = UIModalPresentationFormSheet;
    // This shows a white status bar. If you want this, make sure to have "View controller-based status bar appearance" value set to YES in the app's Info.plist.
    modalNav.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController presentViewController:modalNav animated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)chargeSignature:(id)sender {
    [self startMockPayment:@"108.20"];
}

- (IBAction)chargeAppSelection:(id)sender {
    [self startMockPayment:@"113.73"];
}

- (IBAction)chargeTxFailure:(id)sender {
    [self startMockPayment:@"115.00"];
}

- (IBAction)chargeMiura:(id)sender {
    // Start transaction on a Miura
    [self startTestPaymentOnMiuraWithAmount:@"13.37" tipAmount:nil autocapture:YES];
}

- (IBAction)chargeMiuraWithoutAutocapture:(id)sender {
    
    [self startTestPaymentOnMiuraWithAmount:@"13.37" tipAmount:nil autocapture:NO];
}

- (IBAction)chargeMiuraWithTip:(id)sender {

    [self startTestPaymentOnMiuraWithAmount:@"13.37" tipAmount:@"1.63" autocapture:YES];
}

- (IBAction)chargeVerifone:(id)sender {
    // Start transaction on a Verifone E105
    [self startTestPayment:@"13.37" withAccessoryParameters:[MPAccessoryParameters audioJackAccessoryParametersWithFamily:MPAccessoryFamilyVerifoneE105 optionals:nil]];
}

- (IBAction)summary:(id)sender {
    [self showSummary:self.lastTransaction.identifier];
}

- (IBAction)print:(id)sender {
    [self printReceipt:self.lastTransaction.identifier];
}

- (IBAction)captureLastTransaction:(id)sender {
    [self startCapture:self.lastTransaction.identifier];
}


- (IBAction)refund:(id)sender {
    [self startRefund:self.lastTransaction.identifier];
}

- (IBAction)initWithTestProvider:(id)sender {
    self.applicationMode = NO;
}

- (IBAction)initWithConCardis:(id)sender {
    self.applicationMode = YES;
    self.mposUi = [MPUMposUi initializeWithProviderMode:MPProviderModeTEST application:MPUApplicationNameConcardis integratorIdentifier:@"TESTINTEGRATOR"];
}

- (IBAction)initWithMcashier:(id)sender {
    self.applicationMode = YES;
    self.mposUi = [MPUMposUi initializeWithProviderMode:MPProviderModeTEST application:MPUApplicationNameMcashier integratorIdentifier:@"TESTINTEGRATOR"];
}

- (IBAction)initWithSecureRetail:(id)sender {
    self.applicationMode = YES;
    self.mposUi = [MPUMposUi initializeWithProviderMode:MPProviderModeTEST application:MPUApplicationNameSecureRetail integratorIdentifier:@"TESTINTEGRATOR"];
}

- (IBAction)initWithYourBrand:(id)sender {
    self.applicationMode = YES;
    self.mposUi = [MPUMposUi initializeWithProviderMode:MPProviderModeTEST application:MPUApplicationNameYourBrand integratorIdentifier:@"TESTINTEGRATOR"];

}

- (IBAction)settings:(id)sender {
    if ( self.applicationMode ) {
        UIViewController *viewController = [self.mposUi createSettingsViewController:^(UIViewController *controller) {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [self displayViewController:viewController];
    }
}

- (IBAction)forceLogin:(id)sender {
    if ( self.applicationMode ) {
        UIViewController *viewController = [self.mposUi createLoginViewController:^(UIViewController *controller, MPULoginResult result) {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [self displayViewController:viewController];
    }
}


- (IBAction)customReceipt:(id)sender {
    
    if (self.applicationMode) {
        
        [self fetchAndShowCustomReceiptForApplicationMode];
    
    } else {
        
        [self fetchAndShowCustomReceipt];
    }
}


- (void)fetchAndShowCustomReceiptForApplicationMode {
    
    if ([self.mposUi isApplicationLoggedIn]) {
        [self fetchAndShowCustomReceipt];
    } else {
        NSLog(@"Not logged in");
        // Here we can show the login screen
        UIViewController *viewController = [self.mposUi createLoginViewController:^(UIViewController *controller, MPULoginResult result) {
            [controller dismissViewControllerAnimated:YES completion:nil];
            if (result == MPULoginResultFailed) {
                [self.view makeToast:@"Login failed" duration:2.0 position:CSToastPositionBottom];
            } else {
                [self.view makeToast:@"Login successful" duration:2.0 position:CSToastPositionBottom];
                [self fetchAndShowCustomReceipt];
            }
        }];
        [self displayViewController:viewController];
        
    }
    // NOTE : [self.mposUi isApplicationLoggedIn] will throw an exception if the MposUi is not initialized using the application.
}

- (void)fetchAndShowCustomReceipt {
    // To fetch receipts from payworks, use the transactionProvider from the mposUi object.
    [self.mposUi.transactionProvider.transactionModule lookupTransactionWithTransactionIdentifier:self.lastTransaction.identifier completed:^(MPTransaction *transaction, NSError * error) {

        if (!error) {
            
            MPReceipt *receipt = transaction.customerReceipt;
            
            NSString *merchantName = [[receipt receiptLineItemForKey:MPReceiptLineKeyMerchantDetailsPublicName] value];
            NSString *subject = [[receipt receiptLineItemForKey:MPReceiptLineKeySubject] value];
            NSString *amount = [[receipt receiptLineItemForKey:MPReceiptLineKeyAmountAndCurrency] value];
            
            NSString *receiptText = [NSString stringWithFormat:@"%@ \n %@ \n %@",merchantName,subject,amount];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Custom Receipt"
                                                            message:receiptText
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } ];
     
    // NOTE : Do not keep a reference to the mposUi.transactionProvider as it is subject to change and might result in unexpected behaviour if used improperly.
}

@end
