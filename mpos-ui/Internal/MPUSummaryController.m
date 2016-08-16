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

#import "MPUSummaryController.h"
#import "MPUUIHelper.h"
#import "MPUMposUiConfiguration.h"
#import "MPUTransactionHeaderCell.h"
#import "MPUTransactionCardCell.h"
#import "MPUTransactionSubjectCell.h"
#import "MPUTransactionActionsCell.h"
#import "MPUTransactionHistoryDetailCell.h"
#import "MPUTransactionDateFooterCell.h"
#import "MPUCellBuilder.h"
#import "MPUMposUiAppearance.h"


typedef NS_ENUM(NSUInteger, MPUSummaryControllerAlertTag) {
    MPUSummaryControllerAlertTagRefund,
    MPUSummaryControllerAlertTagCapture
};



@interface MPUSummaryController() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *cellBuilders;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (assign, nonatomic, getter=isReceiptPrinted) BOOL receiptPrinted;
@property (assign, nonatomic, getter=isReceiptSent) BOOL receiptSent;

@property (assign, nonatomic) NSTimer *autoCloseTimer;

@end



@implementation MPUSummaryController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self reloadCells];
    
    if (self.mposUi.configuration.resultDisplayBehavior == MPUMposUiConfigurationResultDisplayBehaviorCloseAfterTimeout) {
        
        self.autoCloseTimer = [NSTimer scheduledTimerWithTimeInterval:MPUMposUiConfigurationResultDisplayCloseTimeout target:self selector:@selector(autoCloseTimerFired:) userInfo:nil repeats:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self disableAutoCloseTimer];
}


- (void)updatePrintReceiptButtonText {

    self.receiptPrinted = YES;
    [self reloadCells];
}


- (void)updateSendReceiptButtonText {

    self.receiptSent = YES;
    // nothing else to do, the updated button will be requested when this VC will be displayed
}


#pragma mark - Button tap

- (void)didTapCloseButton {
    
    [self disableAutoCloseTimer];
    [self.delegate summaryCloseClicked];
}


- (void)didTapSendButton {
    
    [self disableAutoCloseTimer];
    [self.delegate summarySendReceiptClicked:[self transactionIdentifierForReceiptForTransaction:self.transaction]];
}


- (void)didTapPrintButtonForTransactionWithId:(NSString*)transactionId {
    
    [self disableAutoCloseTimer];
    [self.delegate summaryPrintReceiptClicked:transactionId];
}



- (void)didTapRefundButton {
    
    [self disableAutoCloseTimer];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[MPUUIHelper localizedString:@"MPURefundPayment"]
                                                   message:[MPUUIHelper localizedString:@"MPURefundPrompt"]
                                                  delegate:self
                                         cancelButtonTitle:[MPUUIHelper localizedString:@"MPUAbort"] otherButtonTitles:[MPUUIHelper localizedString:@"MPURefund"], nil];
    
    alert.tag = MPUSummaryControllerAlertTagRefund;
    
    [alert show];
};

- (void)didTapCaptureButton {
    
    [self disableAutoCloseTimer];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[MPUUIHelper localizedString:@"MPUCapturePayment"]
                                                   message:[MPUUIHelper localizedString:@"MPUCapturePrompt"]
                                                  delegate:self
                                         cancelButtonTitle:[MPUUIHelper localizedString:@"MPUAbort"] otherButtonTitles:[MPUUIHelper localizedString:@"MPUCapture"], nil];
    
    alert.tag = MPUSummaryControllerAlertTagCapture;
    [alert show];
};

#pragma mark - Autoclose timer

- (void)autoCloseTimerFired:(NSTimer*)timer {

    self.autoCloseTimer = nil;
    [self.delegate summaryCloseClicked];
}


- (void)disableAutoCloseTimer {
    
    [self.autoCloseTimer invalidate];
    self.autoCloseTimer = nil;
}


#pragma mark - Overload

- (UIBarButtonItem *)backButtonItem {
    
    return [[UIBarButtonItem alloc]initWithTitle:[MPUUIHelper localizedString:@"MPUBack"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapCloseButton)];
}


- (UIBarButtonItem *)rightButtonItem {
    
    if ([self isSendReceiptFeatureEnabled] && [self hasTransactionReceipt]) {
        return [[UIBarButtonItem alloc]initWithTitle:[MPUUIHelper localizedString:(self.receiptSent)?@"MPUResend":@"MPUSend"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapSendButton)];
    }
    
    return nil;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadCells];
}

#pragma mark - Cells

- (void)reloadCells {
    
    NSMutableArray *cellBuilders = [NSMutableArray array];
    
    [self addCellBuilder:[self headerCellBuilder] toArray:cellBuilders];

    NSArray *historyCellBuilders = [self historyCellBuildersForTransaction:self.transaction];
    [cellBuilders addObjectsFromArray:historyCellBuilders];
    
    [self addCellBuilder:[self cardCellBuilderWithSeparatorHidden:(historyCellBuilders.count > 0)] toArray:cellBuilders];
    
    [self addCellBuilder:[self subjectCellBuilder] toArray:cellBuilders];
    
    [self addCellBuilder:[self actionCellBuilder] toArray:cellBuilders];
    
    [self addCellBuilder:[self dateCellBuilder] toArray:cellBuilders];

    self.cellBuilders = cellBuilders;
    [self.tableView reloadData];
}


- (void)addCellBuilder:(MPUCellBuilder*)builder toArray:(NSMutableArray*)cellBuilders {
    
    if (builder) {
        [cellBuilders addObject:builder];
    }
}


#pragma mark Header cell

- (MPUCellBuilder*)headerCellBuilder {
    
    __weak typeof(self) weakSelf = self;
    
    MPUCellBuilder *headerCelBuilder = [MPUCellBuilder builderWithBlock:^UITableViewCell *{
        
        return [weakSelf headerCellForTransaction:weakSelf.transaction];
    }];

    return headerCelBuilder;
}


- (UITableViewCell*)headerCellForTransaction:(MPTransaction*)transaction {

    MPUTransactionHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionHeaderCellIdentifier];
    
    cell.titleLabel.text  = [self headerCellTitleTextForTransaction:transaction];
    
    cell.amountLabel.textColor = [self headerCellAmountTextColorForTransaction:transaction];
    cell.amountLabel.text = [self finalAmountTextForTransaction:transaction];

    return cell;
}



- (NSString*)headerCellTitleTextForTransaction:(MPTransaction*)transaction {
    
    NSString *localizationKey = [self localizationKeyForTitleForTransaction:transaction];
    return [MPUUIHelper localizedString:localizationKey];
}


- (NSString*)localizationKeyForTitleForTransaction:(MPTransaction*)transaction {
    
    switch (transaction.status) {
            
        case MPTransactionStatusApproved:
            
            if ([self isTransactionPreauthorized:transaction]) {
                return @"MPUPreauthorized";
            }
            
            if ([self isTransactionSale:transaction]) {
                return @"MPUSale";
            }
            
            if ([self isTransactionRefund:transaction]) {
                return @"MPURefund";
            }
            
            return @"MPUTotal";
            
            
        case MPTransactionStatusDeclined:   return @"MPUDeclined";
        case MPTransactionStatusAborted:    return @"MPUAborted";
        case MPTransactionStatusError:      return @"MPUError";
            
        case MPTransactionStatusUnknown:        //fallthrough
        case MPTransactionStatusInitialized:    //fallthrough
        case MPTransactionStatusPending:    return @"MPUUnknown";
    }

     return @"MPUUnknown";
}


- (NSString*)finalAmountTextForTransaction:(MPTransaction*)transaction {
    
    
    NSDecimalNumber *refundedAmount = [NSDecimalNumber zero];
    
    for (MPRefundTransaction *refundTransaction in transaction.refundDetails.refundTransactions) {
        
        if (refundTransaction.status == MPTransactionStatusApproved) {
            refundedAmount = [refundedAmount decimalNumberByAdding:refundTransaction.amount];
        }
    }
    
    
    NSDecimalNumber *finalAmount = [transaction.amount decimalNumberBySubtracting:refundedAmount];
    
    NSString *finalAmountText = [self.mposUi.transactionProvider.localizationToolbox textFormattedForAmount:finalAmount currency:transaction.currency];
    return finalAmountText;
}


- (UIColor*)headerCellAmountTextColorForTransaction:(MPTransaction*)transaction {
    
    switch (transaction.status) {
            
        case MPTransactionStatusApproved:
            
            if ([self isTransactionPreauthorized:transaction]) {
                return [self preauthAmountColor];
            }
            
            if ([self isTransactionRefund:transaction]) {
                return [self refundAmountColor];
            }
            
            return [self chargeAmountColor];
          
            
        case MPTransactionStatusDeclined:   
        case MPTransactionStatusAborted:    
        case MPTransactionStatusError:
            
        case MPTransactionStatusUnknown:
        case MPTransactionStatusInitialized:
        case MPTransactionStatusPending: return [self declinedColor];
    }

    return [self declinedColor];
}


- (UIColor*)refundAmountColor {
    
    return [UIColor colorWithRed:0./255. green:88./255. blue:191./255. alpha:1.];
}


- (UIColor*)chargeAmountColor {
    
    return [UIColor colorWithRed:88./255. green:117./255. blue:5./255. alpha:1.];
}


- (UIColor*)preauthAmountColor {

    return [UIColor colorWithRed:227./255. green:156./255. blue:3./255. alpha:1.];
}

- (UIColor*)declinedColor {

    return [UIColor colorWithRed:189./255. green:4./255. blue:26./255. alpha:1.];
}



- (BOOL)isTransactionPreauthorized:(MPTransaction*)transaction {
    
    if (transaction.status == MPTransactionStatusApproved
        && transaction.type == MPTransactionTypeCharge
        && transaction.captured == NO) {
        
        return (transaction.refundDetails.refundTransactions.count == 0);
    }
    
    return NO;
}


- (BOOL)isTransactionSale:(MPTransaction*)transaction {
    
    if (transaction.status == MPTransactionStatusApproved
        && transaction.type == MPTransactionTypeCharge
        && transaction.captured == YES) {
        
        // we look into the refund transactions because this is the only whay
        // to make sure it was not partially captured or partialy refunded
        return (transaction.refundDetails.refundTransactions.count == 0);
    }
    
    return NO;
}


- (BOOL)isTransactionRefund:(MPTransaction*)transaction {
    return (transaction.type == MPTransactionTypeRefund);
}



#pragma mark History cell

- (NSArray*)historyCellBuildersForTransaction:(MPTransaction*)transaction {
    
    NSMutableArray *cellBuilders = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    if ([self isTransactionRefundedWithoutPartialCapture:self.transaction]) {
        
        MPUCellBuilder *chargeHistoryCellBuilder = [MPUCellBuilder builderWithBlock:^UITableViewCell *{
            
            return [weakSelf historyCellSaleForTransaction:weakSelf.transaction];
        }];
        
        [cellBuilders addObject:chargeHistoryCellBuilder];
    }
    
    
    for (MPRefundTransaction *refundTx in self.transaction.refundDetails.refundTransactions) {
        
        if (refundTx.status != MPTransactionStatusApproved) {
            continue;
        }
        
        MPUCellBuilder *historyCellBuilder = [MPUCellBuilder builderWithBlock:^UITableViewCell *{
            return [self historyCellForRefundTransaction:refundTx];
        }];
        
        if (refundTx.code == MPRefundTransactionCodePartialCapture) {
            historyCellBuilder.cellHeight = 68.;
        } else {
            historyCellBuilder.cellHeight = 48.;
        }
        
        [cellBuilders addObject:historyCellBuilder];
    }
   
    
    return cellBuilders;
}



- (UITableViewCell*)historyCellSaleForTransaction:(MPTransaction*)transaction {
    
    MPUTransactionHistoryDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionHistoryDetailCellIdentifier];
    
    cell.transactionTypeLabel.text = [MPUUIHelper localizedString:(self.transaction.captured)?@"MPUTransactionTypeSale":@"MPUTransactionTypePreauthorization"];
    cell.amountLabel.text = [self.mposUi.transactionProvider.localizationToolbox textFormattedForAmount:transaction.amount currency:transaction.currency];
    cell.amountLabel.textColor = (self.transaction.captured)?[self chargeAmountColor]:[self preauthAmountColor];
    cell.initialAmountLabel.text = @"";
    cell.dateLabel.text = [self textFormattedForTimeAndDate:self.transaction.created];

    return cell;
}


- (UITableViewCell*)historyCellForRefundTransaction:(MPRefundTransaction*)refundTransaction {
 
    MPUTransactionHistoryDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionHistoryDetailCellIdentifier];
    
    cell.transactionTypeLabel.text = [self typeTextForRefundTransaction:refundTransaction];
    cell.amountLabel.text = [self textAmountForRefundTransaction:refundTransaction];
    cell.amountLabel.textColor = [self textAmountColorForRefundTransaction:refundTransaction];
    cell.initialAmountLabel.text = [self textInitialAmountForRefundTransaction:refundTransaction];
    cell.dateLabel.text = [self textFormattedForTimeAndDate:refundTransaction.created];
    return cell;
}



- (NSString*)typeTextForRefundTransaction:(MPRefundTransaction*)refundTransaction {
    
    switch (refundTransaction.code) {
        case MPRefundTransactionCodeRefundAfterClearing:
        case MPRefundTransactionCodeRefundBeforeClearing:
            return [MPUUIHelper localizedString:@"MPUTransactionTypeRefund"];
            
        case MPRefundTransactionCodePartialCapture:
            return [MPUUIHelper localizedString:@"MPUTransactionTypeSale"];
            
        case MPRefundTransactionCodeUnknown:
            return @"";
    }
    
    return @"";
}


- (NSString*)textAmountForRefundTransaction:(MPRefundTransaction*)refundTransaction {

    NSString *amountText = nil;
    
    switch (refundTransaction.code) {

        case MPRefundTransactionCodeRefundAfterClearing:
        case MPRefundTransactionCodeRefundBeforeClearing:
            
            amountText = [self.mposUi.transactionProvider.localizationToolbox textFormattedForAmount:refundTransaction.amount currency:refundTransaction.currency];
            amountText = [@"-" stringByAppendingString:amountText];
            break;
            
        case MPRefundTransactionCodePartialCapture:
          
            amountText = [self.mposUi.transactionProvider.localizationToolbox textFormattedForAmount:[self.transaction.amount decimalNumberBySubtracting:refundTransaction.amount]
                                                                                            currency:refundTransaction.currency];
            
        break;
            
        case MPRefundTransactionCodeUnknown:
            break;
    }
    
    return amountText;
}



- (NSString*)textInitialAmountForRefundTransaction:(MPRefundTransaction*)refundTransaction {

    
    if (refundTransaction.code == MPRefundTransactionCodePartialCapture) {
        
        NSString *textAmount = [self.mposUi.transactionProvider.localizationToolbox textFormattedForAmount:self.transaction.amount
                                                                                                  currency:self.transaction.currency];
        
        NSString *fullText = [NSString stringWithFormat:[[MPUUIHelper localizedString:@"MPUPartiallyCaptured"] stringByAppendingString:@" "], textAmount];
        
        DDLogVerbose(@"full text : '%@'", fullText);
        return fullText;
    }
    
    return @"";
}


- (UIColor*)textAmountColorForRefundTransaction:(MPRefundTransaction*)refundTransaction {
 
    switch (refundTransaction.code) {
            
        case MPRefundTransactionCodeRefundAfterClearing:
        case MPRefundTransactionCodeRefundBeforeClearing:
            
            return [self refundAmountColor];
            
        case MPRefundTransactionCodePartialCapture:
            
            return [self chargeAmountColor];
            
        case MPRefundTransactionCodeUnknown:
            return [UIColor blackColor];
    }
    
    return [UIColor blackColor];
}


- (BOOL)isTransactionRefundedWithoutPartialCapture:(MPTransaction*)transaction {

    if (transaction.refundDetails.refundTransactions.count == 0) {
        return NO;
    }
    
    for (MPRefundTransaction *refundTransaction in transaction.refundDetails.refundTransactions) {
        
        if (refundTransaction.code == MPRefundTransactionCodePartialCapture) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark Card cell


- (MPUCellBuilder*)cardCellBuilderWithSeparatorHidden:(BOOL)separatorHidden {
    
    if (![self canShowCardCellForTransaction:self.transaction]) {
        return nil;
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    MPUCellBuilder *cardCell = [MPUCellBuilder builderWithBlock:^UITableViewCell *{
        return [self cardCellForTransaction:weakSelf.transaction separatorHidden:separatorHidden];
    }];
    
    return cardCell;
}


- (BOOL)canShowCardCellForTransaction:(MPTransaction*)transaction {
    
    return transaction.paymentDetails.scheme != MPPaymentDetailsSchemeUnknown;
}

- (UITableViewCell*)cardCellForTransaction:(MPTransaction*)transaction separatorHidden:(BOOL)separatorHidden {
    
    MPUTransactionCardCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionCardCellIdentifier];
    
    UIImage *schemeImage = [self schemeImageForTransaction:transaction];
    
    if (schemeImage) {
        cell.schemeImageView.image = schemeImage;
        cell.schemeImageView.hidden = NO;
        cell.schemeLabel.hidden = YES;
    } else {
        cell.imageView.hidden = YES;
        cell.schemeLabel.hidden = NO;
        cell.schemeLabel.text = [self schemeTextForTransaction:transaction];
    }
    
    cell.cardNumberLabel.text = [self maskedAccountNumberForTransaction:transaction];
    cell.separatorView.hidden = separatorHidden;
    
    return cell;
}


- (UIImage*)schemeImageForTransaction:(MPTransaction*)transaction {
    
    if (!IS_OS_8_OR_LATER) {
        // on iOS 7, the method to load an image in a bundle does not exist.
        DDLogDebug(@"Scheme Falling Back!Not iOS8");
        return nil;
    }
    
    MPPaymentDetailsScheme scheme = transaction.paymentDetails.scheme;
    
    switch (scheme) {
        case MPPaymentDetailsSchemeVISA:
        case MPPaymentDetailsSchemeVISAElectron:
            return [UIImage imageNamed:@"VISA" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            
        case MPPaymentDetailsSchemeMaestro:
            return [UIImage imageNamed:@"Maestro" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            
        case MPPaymentDetailsSchemeMasterCard:
            return [UIImage imageNamed:@"MasterCard" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            
        case MPPaymentDetailsSchemeAmericanExpress:
            return [UIImage imageNamed:@"AmericanExpress" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            
        case MPPaymentDetailsSchemeDinersClub:
            return [UIImage imageNamed:@"Diners" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            
        case MPPaymentDetailsSchemeJCB:
            return [UIImage imageNamed:@"JCB" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            
        case MPPaymentDetailsSchemeDiscover:
            return [UIImage imageNamed:@"Discover" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            
        case MPPaymentDetailsSchemeUnionPay:
            return [UIImage imageNamed:@"UnionPay" inBundle:[MPUUIHelper frameworkBundle] compatibleWithTraitCollection:nil];
            
        case MPPaymentDetailsSchemeUnknown:
            return nil;
    }
    
    return nil;
}

- (NSString*)schemeTextForTransaction:(MPTransaction*)transaction {
    
    MPPaymentDetailsScheme scheme = transaction.paymentDetails.scheme;
    
    switch (scheme) {
        case MPPaymentDetailsSchemeVISA:
            return @"VISA";
            
        case MPPaymentDetailsSchemeVISAElectron:
            return @"VISA Electron";
            
        case MPPaymentDetailsSchemeMaestro:
            return @"Maestro";
            
        case MPPaymentDetailsSchemeMasterCard:
            return @"MasterCard";
            
        case MPPaymentDetailsSchemeAmericanExpress:
            return @"American Express";
            
        case MPPaymentDetailsSchemeDinersClub:
            return @"Diners";
            
        case MPPaymentDetailsSchemeJCB:
            return @"JCB";
            
        case MPPaymentDetailsSchemeDiscover:
            return @"Discover";
            
        case MPPaymentDetailsSchemeUnionPay:
            return @"Union Pay";
            
        case MPPaymentDetailsSchemeUnknown:
            return nil;
    }
    
    return nil;
}


- (NSString *)maskedAccountNumberForTransaction:(MPTransaction*)transaction {
    
    NSString *maskedAccountNumber = transaction.paymentDetails.accountNumber;
    
    maskedAccountNumber = [maskedAccountNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    maskedAccountNumber = [maskedAccountNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    maskedAccountNumber = [maskedAccountNumber stringByReplacingOccurrencesOfString:@"[^0-9]"
                                                                         withString:@"\u2022"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, [maskedAccountNumber length])];


    
    // next we separate string into groups of four separated with a space, starting with the end
    // ie "**********1234" - becomes "** **** **** 1234"
    
    NSUInteger numberOfSpaces = (maskedAccountNumber.length-1) / 4; // length-1 - so that we don't insert the extra space at the begining when we have multiple of 4 chars
    
    NSMutableString *man = [maskedAccountNumber mutableCopy];
    NSUInteger initalLength = man.length;
    
    // we add the space starting with the end, so only the indexes of the already inserted spaces are shifted
    // the 'next' index is in the same position as it would be in the original string
    for (int i = 1; i <= numberOfSpaces; i++) {
        
        [man insertString:@" " atIndex:initalLength - 4*i];
    }
    
    return man;
}


#pragma mark Subject cell


- (MPUCellBuilder*)subjectCellBuilder {
    
    if (self.transaction.subject.length == 0) {
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    MPUCellBuilder *subjectCellBuilder = [MPUCellBuilder builderWithBlock:^UITableViewCell *{

        return [self subjectCellForTransaction:weakSelf.transaction];
    }];

    return subjectCellBuilder;
}

- (UITableViewCell*)subjectCellForTransaction:(MPTransaction*)transaction {
    
    MPUTransactionSubjectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionSubjectCellIdentifier];
    cell.subjectLabel.text = transaction.subject;
    return cell;
}


#pragma mark Actions cell 


- (MPUCellBuilder*)actionCellBuilder {
    
    if (   ![self canPrint]
        && ![self canRefund]
        && ![self canCapture]) {
        
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    MPUCellBuilder *actionsCellBuilder = [MPUCellBuilder builderWithBlock:^UITableViewCell *{
        return [self actionCellForTransaction:weakSelf.transaction];
    }];
    
    return actionsCellBuilder;
}


- (UITableViewCell*)actionCellForTransaction:(MPTransaction*)transaction {
    
    MPUTransactionActionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionActionsCellIdentifier];

    if ([self isPrintReceiptFeatureEnabled]) {
        [self setupPrintActionInCell:cell button:cell.button0FromLeft forTransaction:transaction];
    }
    
    
    const BOOL canCapture = [self canCapture];
    
    if ([self canRefund]) {
        
        [self setupRefundActionInCell:cell
                               button:(canCapture)?cell.button1FromRight:cell.button0FromRight
                       forTransaction:transaction];
    }
    
    if (canCapture) {
        
        [self setupCaptureActionInCell:cell button:cell.button0FromRight forTransaction:transaction];
    }
    
    return cell;
}


#pragma mark .    print


- (void)setupPrintActionInCell:(MPUTransactionActionsCell*)cell button:(UIButton*)button forTransaction:(MPTransaction*)transaction {

    button.hidden = NO;
    [button setTitle:[self printButtonTitle] forState:UIControlStateNormal];
    [cell setAction:[self printActionForTransaction:transaction] forButton:button];
}


- (NSString*)printButtonTitle {
    
    return [MPUUIHelper localizedString:(self.isReceiptPrinted)?@"MPUReprint":@"MPUPrint"];
}

- (MPUSCActionsCellAction)printActionForTransaction:(MPTransaction*)transaction {
    
    __weak typeof(self) weakSelf = self;
    
    return ^(){
        
        [weakSelf didTapPrintButtonForTransactionWithId:[weakSelf transactionIdentifierForReceiptForTransaction:transaction]];
    };
}


- (NSString *)transactionIdentifierForReceiptForTransaction:(MPTransaction*)transaction {
    // If this is a refund, we look for the transaction identifier from the refundTransactions list.
    
    NSArray *refundTransactions = transaction.refundDetails.refundTransactions;
    
    
    for (NSInteger i = refundTransactions.count-1; i >= 0; i--) {
        
        MPRefundTransaction *refundTransaction = refundTransactions[i];
        
        if (refundTransaction.status == MPTransactionStatusApproved
            && refundTransaction.code != MPRefundTransactionCodePartialCapture) {
            
            return refundTransaction.identifier;
        }
    }

    return transaction.identifier;
}


- (BOOL)isPrintReceiptFeatureEnabled {
    
    return ((self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeaturePrintReceipt) == MPUMposUiConfigurationSummaryFeaturePrintReceipt);
}


#pragma mark .    refund

- (void)setupRefundActionInCell:(MPUTransactionActionsCell*)cell button:(UIButton*)button forTransaction:(MPTransaction*)transaction {
    
    button.hidden = NO;
    
    [button setTitle:[MPUUIHelper localizedString:@"MPURefund"] forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    [cell setAction:^{ [weakSelf didTapRefundButton]; } forButton:button];
}


- (BOOL)canRefund {
    
    return (self.refundEnabled
            && [self isRefundFeatureEnabled]
            && [self isTransactionRefundable]);
}

- (BOOL)canPrint {
    
    return ([self isPrintReceiptFeatureEnabled]
            && [self hasTransactionReceipt]);
}


- (BOOL)isTransactionRefundable {
    
    return ((self.transaction.status == MPTransactionStatusApproved)
            && (self.transaction.refundDetails.status != MPRefundDetailsStatusRefunded)
            && (self.transaction.type != MPTransactionTypeRefund));
}


- (BOOL)hasTransactionReceipt {
    
    switch (self.transaction.status) {
            
        case MPTransactionStatusApproved:   //fallthrough
        case MPTransactionStatusDeclined:   //fallthrough
        case MPTransactionStatusAborted:    return YES;
        
        case MPTransactionStatusError:      //fallthrough
        case MPTransactionStatusUnknown:    //fallthrough
        case MPTransactionStatusInitialized://fallthrough
        case MPTransactionStatusPending:    return NO;
    }
    
    return NO;
}


- (BOOL)isRefundFeatureEnabled {
  
    return (self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeatureRefundTransaction);
}



#pragma mark .   capture


- (void)setupCaptureActionInCell:(MPUTransactionActionsCell*)cell button:(UIButton*)button forTransaction:(MPTransaction*)transaction {
    
    button.hidden = NO;
    
    [button setTitle:[MPUUIHelper localizedString:@"MPUCapture"] forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    [cell setAction:^{ [weakSelf didTapCaptureButton]; } forButton:button];
}



- (BOOL)canCapture {

    return (self.refundEnabled
            && [self isCaptureFeatureEnabled]
            && [self isTransactionCapturable]);
}


- (BOOL)isCaptureFeatureEnabled {
    
    return (self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeatureCaptureTransaction);
}

- (BOOL)isTransactionCapturable {
    
    return ([self isTransactionRefundable]
            && !self.transaction.captured);
}



- (BOOL)isSendReceiptFeatureEnabled {
    
    return (self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeatureSendReceiptViaEmail);
}


#pragma mark Date

- (MPUCellBuilder*)dateCellBuilder {
    
    __weak typeof(self) weakSelf = self;
    
    MPUCellBuilder *dateCellBuilder = [MPUCellBuilder builderWithBlock:^UITableViewCell *{
        return [self dateCellForTransaction:weakSelf.transaction];
    }];
    
    return dateCellBuilder;
}


- (UITableViewCell*)dateCellForTransaction:(MPTransaction*)transaction {
    
    MPUTransactionDateFooterCell *dateCell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionDateFooterCellIdentifier];
    
    dateCell.dateLabel.text = [self textFormattedForTimeAndDate:self.transaction.created];
    
    return dateCell;
}

- (NSString *)textFormattedForTimeAndDate:(NSDate *)date {

    if (date == nil){
        return nil;
    }
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone =  [NSTimeZone localTimeZone];
        formatter.dateFormat = @"dd MMMM yyyy, HH:mm";
    });
    
    NSString *formattedText = [formatter stringFromDate:date];
    return formattedText;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        return;
    }
    
    
    switch (alertView.tag) {
            
        case MPUSummaryControllerAlertTagRefund:
            
            [self.delegate summaryRefundClicked:self.transaction.identifier];
            break;
            
            
        case MPUSummaryControllerAlertTagCapture:
            
            [self.delegate summaryCaptureClicked:self.transaction.identifier];
            break;
    }
}


#pragma mark - Tableview datasource 


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellBuilders.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MPUCellBuilder *cellBuilder = self.cellBuilders[indexPath.row];
    
    return cellBuilder.build();
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MPUCellBuilder *cellBuilder = self.cellBuilders[indexPath.row];
    return cellBuilder.cellHeight;
}

@end
