/*
 * mpos-ui : http://www.payworksmobile.com
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

#import "MPUPrintReceiptContainerViewController.h"
#import "MPUUIHelper.h"

NSString* const MPUSegueIdentifierPrint_PrintReceipt = @"ptPushPrint";
NSString* const MPUSegueIdentifierPrint_Error = @"ptPushError";

@interface MPUPrintReceiptContainerViewController ()

@property (nonatomic, weak) MPUPrintReceiptController *printReceiptViewController;
@property (nonatomic, weak) MPUErrorController *errorViewController;

@property (nonatomic, strong) NSError *lastError;

@end

@implementation MPUPrintReceiptContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewTransitionInProgress = NO;
    self.previousSegueIdentifier = MPUSegueIdentifierPrint_PrintReceipt;
    // Do any additional setup after loading the view.
    [self performSegueWithIdentifier:MPUSegueIdentifierPrint_PrintReceipt sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.previousSegueIdentifier = self.currentSegueIdentifier;
    self.currentSegueIdentifier = segue.identifier;
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierPrint_PrintReceipt]) {
        DDLogDebug(@"prepareForSegue:Print Receipt");
        self.printReceiptViewController = segue.destinationViewController;
        DDLogDebug(@"Container:Segue:%@",self.transactionIdentifer);
        [self showPrintReceipt:self.transactionIdentifer];
        [self swapToViewController:self.printReceiptViewController];
    }
    
    if ([segue.identifier isEqualToString:MPUSegueIdentifierPrint_Error]) {
        DDLogDebug(@"prepareForSegue:Error");
        self.errorViewController = segue.destinationViewController;
        [self showError:self.lastError];
        [self swapToViewController:self.errorViewController];
    }
}

- (void)showPrintReceipt:(NSString *)transactionIdentifier {
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUPrinting"]];
    self.printReceiptViewController.transactionIdentifer = transactionIdentifier;
    self.printReceiptViewController.delegate = self;
}

- (void)showError:(NSError *)error{
    [self.delegate titleChanged:[MPUUIHelper localizedString:@"MPUError"]];
    self.errorViewController.error = error;
    self.errorViewController.delegate = self;
    self.errorViewController.retryEnabled = YES;
}

#pragma mark - Public

- (void)backButtonPressed{
    //NO OP
}

#pragma mark - MPUPrintReceiptDelegate

- (void)printReceiptFailed:(NSError *)error {
    self.lastError = error;
    [self performSegueWithIdentifier:MPUSegueIdentifierPrint_Error sender:nil];
}

- (void)printReceiptSuccess {
    self.completed(self, MPUPrintReceiptResultSuccessful);
}

- (void)printReceiptAborted {
    self.completed(self, MPUPrintReceiptResultFailed);
}

#pragma mark - MPUErrorDelegate
- (void)errorCancelClicked {
    self.completed(self, MPUPrintReceiptResultFailed);
}

- (void)errorRetryClicked {
    [self performSegueWithIdentifier:MPUSegueIdentifierPrint_PrintReceipt sender:nil];
}

@end
