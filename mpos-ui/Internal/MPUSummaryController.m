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

const CGFloat MPUSummaryControllerActionCellHeight = 44.0;

const CGFloat MPUSummaryControllerHeaderBigCellHeight = 82.0;
const CGFloat MPUSummaryControllerHeaderSmallCellHeight = 64.0;
const CGFloat MPUSummaryControllerHistoryBigCellHeight = 72.0;
const CGFloat MPUSummaryControllerHistorySmallCellHeight = 56.0;

@implementation MPUSummaryController


- (void)viewDidLoad {

    [super viewDidLoad];
    
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


- (void)didTapPrintButton {
    
    [self disableAutoCloseTimer];
    [self.delegate summaryPrintReceiptClicked:[self transactionIdentifierForReceiptForTransaction:self.transaction]];
}



- (void)didTapRefundButton {
    
    [self disableAutoCloseTimer];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[MPUUIHelper localizedString:@"MPURefundTransaction"]
                                                   message:[MPUUIHelper localizedString:@"MPURefundPrompt"]
                                                  delegate:self
                                         cancelButtonTitle:[MPUUIHelper localizedString:@"MPUAbort"] otherButtonTitles:[MPUUIHelper localizedString:@"MPURefund"], nil];
    
    alert.tag = MPUSummaryControllerAlertTagRefund;
    
    [alert show];
};

- (void)didTapCaptureButton {
    
    [self disableAutoCloseTimer];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[MPUUIHelper localizedString:@"MPUCaptureTransaction"]
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadCells];
}

#pragma mark - Cells

- (void)reloadCells {
    
    NSMutableArray *cellBuilders = [NSMutableArray array];
    
    
    NSMutableArray *receiptSection = [NSMutableArray array];
    
    [self addCellBuilder:[self headerCellBuilder] toArray:receiptSection];

    NSArray *historyCellBuilders = [self historyCellBuildersForTransaction:self.transaction];
    [receiptSection addObjectsFromArray:historyCellBuilders];
    
    [self addCellBuilder:[self cardCellBuilderWithSeparatorHidden:(historyCellBuilders.count == 0)] toArray:receiptSection];
    
    [self addCellBuilder:[self subjectCellBuilder] toArray:receiptSection];
    
    [self addCellBuilder:[self dateCellBuilder] toArray:receiptSection];
    
    [cellBuilders addObject:receiptSection];
    
    
    NSMutableArray *buttonsSection = [NSMutableArray array];
    
    [self addCellBuilder:[self captureCellBuilder] toArray:buttonsSection];
    
    [self addCellBuilder:[self refundCellBuilder] toArray:buttonsSection];
    
    [self addCellBuilder:[self sendReceiptCellBuilder] toArray:buttonsSection];
    
    [self addCellBuilder:[self printReceiptCellBuilder] toArray:buttonsSection];
    
    
    if (buttonsSection.count > 0) {
        [cellBuilders addObject:buttonsSection];
    }
    
    
    [cellBuilders addObject:@[[self closeCellBuilder]]];

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
    
    MPUCellBuilder *headerCelBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
        
        return [weakSelf headerCellForTransaction:weakSelf.transaction];
    }];
    
    headerCelBuilder.cellHeight = [self headerCellHeightForTransaction:self.transaction];

    return headerCelBuilder;
}


- (MPUTransactionCell*)headerCellForTransaction:(MPTransaction*)transaction {

    MPUTransactionHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionHeaderCellIdentifier];
    
    cell.titleLabel.text  = [self headerCellTitleTextForTransaction:transaction];
    cell.amountLabel.text = [self finalAmountTextForTransaction:transaction];
    cell.detailLabel.text = [self headerDetailTextForTransaction:transaction];
    
    UIColor *textColor = [self headerCellTextColorForTransaction:transaction];
    
    cell.titleLabel.textColor = textColor;
    cell.amountLabel.textColor = textColor;
    cell.detailLabel.textColor = textColor;
    
    cell.contentView.backgroundColor = [self headerCellBackgroundColorForTransaction:transaction];
    
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
                return @"MPUApproved";
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


- (CGFloat)headerCellHeightForTransaction:(MPTransaction*)transaction {
    
    NSString *detail = [self headerDetailTextForTransaction:transaction];
    
    CGFloat height = (detail.length > 0)? MPUSummaryControllerHeaderBigCellHeight : MPUSummaryControllerHeaderSmallCellHeight;
    
    return height;
}


- (NSString*)headerDetailTextForTransaction:(MPTransaction*)transaction {
    
    switch (transaction.status) {
        
        case MPTransactionStatusDeclined:
        case MPTransactionStatusError:
            return  [self.mposUi.transactionProvider.localizationToolbox informationForTransactionStatusDetailsCode:transaction.statusDetails.code] ;
            
        case MPTransactionStatusApproved:
        case MPTransactionStatusUnknown:
        case MPTransactionStatusInitialized:
        case MPTransactionStatusPending:
        case MPTransactionStatusAborted:
            return @"";
    }
    
    return @"";
}

- (UIColor*)headerCellBackgroundColorForTransaction:(MPTransaction*)transaction {
    
    MPUMposUiAppearance *appearance = self.mposUi.configuration.appearance;
    
    
    switch (transaction.status) {
            
        case MPTransactionStatusApproved:
            
            if ([self isTransactionPreauthorized:transaction]) {
                return appearance.preauthorizedBackgroundColor;
            }
            
            if ([self isTransactionRefund:transaction]) {
                return appearance.refundedBackgroundColor;
            }
            
            return appearance.approvedBackgroundColor;
          
            
        case MPTransactionStatusDeclined:   
        case MPTransactionStatusAborted:    
        case MPTransactionStatusError:
            
        case MPTransactionStatusUnknown:
        case MPTransactionStatusInitialized:
        case MPTransactionStatusPending: return appearance.declinedBackgroundColor;
    }

    return appearance.declinedBackgroundColor;
}


- (UIColor*)headerCellTextColorForTransaction:(MPTransaction*)transaction {
    
    MPUMposUiAppearance *appearance = self.mposUi.configuration.appearance;
    
    
    switch (transaction.status) {
            
        case MPTransactionStatusApproved:
            
            if ([self isTransactionPreauthorized:transaction]) {
                return appearance.preauthorizedTextColor;
            }
            
            if ([self isTransactionRefund:transaction]) {
                return appearance.refundedTextColor;
            }
            
            return appearance.approvedTextColor;
            
            
        case MPTransactionStatusDeclined:
        case MPTransactionStatusAborted:
        case MPTransactionStatusError:
            
        case MPTransactionStatusUnknown:
        case MPTransactionStatusInitialized:
        case MPTransactionStatusPending: return appearance.declinedTextColor;
    }
    
    return appearance.declinedTextColor;
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
        
        MPUCellBuilder *chargeHistoryCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
            
            return [weakSelf historyCellSaleForTransaction:weakSelf.transaction];
        }];
        
        [cellBuilders addObject:chargeHistoryCellBuilder];
    }
    
    
    for (MPRefundTransaction *refundTx in self.transaction.refundDetails.refundTransactions) {
        
        if (refundTx.status != MPTransactionStatusApproved) {
            continue;
        }
        
        MPUCellBuilder *historyCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
            return [self historyCellForRefundTransaction:refundTx];
        }];
        
        if (refundTx.code == MPRefundTransactionCodePartialCapture) {
            historyCellBuilder.cellHeight = MPUSummaryControllerHistoryBigCellHeight;
        } else {
            historyCellBuilder.cellHeight = MPUSummaryControllerHistorySmallCellHeight;
        }
        
        [cellBuilders addObject:historyCellBuilder];
    }
   
    
    return cellBuilders;
}



- (MPUTransactionCell*)historyCellSaleForTransaction:(MPTransaction*)transaction {
    
    MPUTransactionHistoryDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionHistoryDetailCellIdentifier];
    
    cell.transactionTypeLabel.text = [MPUUIHelper localizedString:(self.transaction.captured)?@"MPUTransactionTypeSale":@"MPUTransactionTypePreauthorization"];
    cell.amountLabel.text = [self.mposUi.transactionProvider.localizationToolbox textFormattedForAmount:transaction.amount currency:transaction.currency];
    MPUMposUiAppearance *appearance = self.mposUi.configuration.appearance;
    cell.amountLabel.textColor = (self.transaction.captured)?appearance.approvedBackgroundColor:appearance.preauthorizedBackgroundColor;
    cell.initialAmountLabel.text = @"";
    cell.dateLabel.text = [self textFormattedForTimeAndDate:self.transaction.created];

    return cell;
}


- (MPUTransactionCell*)historyCellForRefundTransaction:(MPRefundTransaction*)refundTransaction {
 
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
 
    MPUMposUiAppearance *appearance = self.mposUi.configuration.appearance;
    
    switch (refundTransaction.code) {
            
        case MPRefundTransactionCodeRefundAfterClearing:
        case MPRefundTransactionCodeRefundBeforeClearing:
            
            return appearance.refundedBackgroundColor;
            
        case MPRefundTransactionCodePartialCapture:
            
            return appearance.approvedBackgroundColor;
            
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
    
    MPUCellBuilder *cardCell = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
        return [self cardCellForTransaction:weakSelf.transaction];
    }];
    
    cardCell.forceHideSepparator = separatorHidden;
    
    return cardCell;
}


- (BOOL)canShowCardCellForTransaction:(MPTransaction*)transaction {
    
    return transaction.paymentDetails.scheme != MPPaymentDetailsSchemeUnknown;
}

- (MPUTransactionCell*)cardCellForTransaction:(MPTransaction*)transaction {
    
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
    MPUCellBuilder *subjectCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{

        return [self subjectCellForTransaction:weakSelf.transaction];
    }];

    return subjectCellBuilder;
}

- (MPUTransactionCell*)subjectCellForTransaction:(MPTransaction*)transaction {
    
    MPUTransactionSubjectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionSubjectCellIdentifier];
    cell.subjectLabel.text = transaction.subject;
    return cell;
}


#pragma mark Capture cell

- (MPUCellBuilder*)captureCellBuilder {
    
    if (![self canCapture]) {
        
        return nil;
    }
    
    MPUCellBuilder *actionsCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
        return [self captureCell];
    }];
    
    actionsCellBuilder.cellHeight = MPUSummaryControllerActionCellHeight;
    
    return actionsCellBuilder;
}


- (MPUTransactionCell*)captureCell {
    
    MPUTransactionActionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionActionsCellIdentifier];
    
    [cell setActionTitle:[MPUUIHelper localizedString:@"MPUCaptureTransaction"] bold:NO];
    
    __weak typeof(self) weakSelf = self;
    [cell setAction:^{ [weakSelf didTapCaptureButton]; }];
    
    
    
    return cell;
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


#pragma mark Refund cell


- (MPUCellBuilder*)refundCellBuilder {
    
    if (![self canRefund]) {
        
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    MPUCellBuilder *actionsCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
        
        return [self refundCellForTransaction:weakSelf.transaction];
    }];
    
    actionsCellBuilder.cellHeight = MPUSummaryControllerActionCellHeight;
    
    return actionsCellBuilder;
}


- (MPUTransactionCell*)refundCellForTransaction:(MPTransaction*)transaction {
    
    MPUTransactionActionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionActionsCellIdentifier];
    
    [cell setActionTitle:[MPUUIHelper localizedString:@"MPURefundTransaction"] bold:NO];
    
    __weak typeof(self) weakSelf = self;
    [cell setAction:^{ [weakSelf didTapRefundButton]; }];
    
    return cell;
}


- (BOOL)canRefund {
    
    return (self.refundEnabled
            && [self isRefundFeatureEnabled]
            && [self isTransactionRefundable]);
}




- (BOOL)isRefundFeatureEnabled {
    
    return (self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeatureRefundTransaction);
}


- (BOOL)isTransactionRefundable {
    
    return ((self.transaction.status == MPTransactionStatusApproved)
            && (self.transaction.refundDetails.status != MPRefundDetailsStatusRefunded)
            && (self.transaction.type != MPTransactionTypeRefund));
}


#pragma Send receipt cell

- (MPUCellBuilder*)sendReceiptCellBuilder {
    
    if (![self isSendReceiptFeatureEnabled]
        || ![self hasTransactionReceipt]) {
        
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    MPUCellBuilder *actionsCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
        return [weakSelf sendReceiptCell];
    }];
    
    actionsCellBuilder.cellHeight = MPUSummaryControllerActionCellHeight;
    
    return actionsCellBuilder;
}


- (MPUTransactionCell*)sendReceiptCell {
    
    MPUTransactionActionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionActionsCellIdentifier];
    
    [cell setActionTitle:[MPUUIHelper localizedString:(self.receiptSent)?@"MPUResendReceipt":@"MPUSendReceipt"] bold:NO];
    
    __weak typeof(self) weakSelf = self;
    [cell setAction:^{ [weakSelf didTapSendButton]; }];
    
    return cell;
}


- (BOOL)isSendReceiptFeatureEnabled {
    
    return (self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeatureSendReceiptViaEmail);
}



#pragma mark Print receipt cell

- (MPUCellBuilder*)printReceiptCellBuilder {
    
    if (![self isPrintReceiptFeatureEnabled]
        || ![self hasTransactionReceipt]) {
        
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    MPUCellBuilder *actionsCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
        return [weakSelf printReceiptCell];
    }];
    
    actionsCellBuilder.cellHeight = MPUSummaryControllerActionCellHeight;
    
    return actionsCellBuilder;
}


- (MPUTransactionCell*)printReceiptCell {
    
    MPUTransactionActionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionActionsCellIdentifier];
    
    [cell setActionTitle:[MPUUIHelper localizedString:(self.isReceiptPrinted)?@"MPUReprintReceipt":@"MPUPrintReceipt"] bold:NO];
    
    __weak typeof(self) weakSelf = self;
    [cell setAction:^{ [weakSelf didTapPrintButton]; }];
    
    return cell;
}


- (BOOL)isPrintReceiptFeatureEnabled {
    
    return ((self.mposUi.configuration.summaryFeatures & MPUMposUiConfigurationSummaryFeaturePrintReceipt) == MPUMposUiConfigurationSummaryFeaturePrintReceipt);
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


#pragma mark Close cell

- (MPUCellBuilder*)closeCellBuilder {
    
    __weak typeof(self) weakSelf = self;
    MPUCellBuilder *actionsCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
        return [weakSelf closeCell];
    }];

    actionsCellBuilder.cellHeight = MPUSummaryControllerActionCellHeight;
    
    return actionsCellBuilder;
}


- (MPUTransactionCell*)closeCell {
    
    MPUTransactionActionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MPUTransactionActionsCellIdentifier];
    
    [cell setActionTitle:[MPUUIHelper localizedString:@"MPUClose"] bold:YES];
    
    __weak typeof(self) weakSelf = self;
    [cell setAction:^{ [weakSelf didTapCloseButton]; }];
    
    return cell;
}



#pragma mark Date

- (MPUCellBuilder*)dateCellBuilder {
    
    __weak typeof(self) weakSelf = self;
    
    MPUCellBuilder *dateCellBuilder = [MPUCellBuilder builderWithBlock:^MPUTransactionCell *{
        return [self dateCellForTransaction:weakSelf.transaction];
    }];
    
    return dateCellBuilder;
}


- (MPUTransactionCell*)dateCellForTransaction:(MPTransaction*)transaction {
    
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
    
    return self.cellBuilders.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.cellBuilders[section] count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *section = self.cellBuilders[indexPath.section];
    
    MPUCellBuilder *cellBuilder = section[indexPath.row];
    MPUTransactionCell *cell = cellBuilder.build();
    
    BOOL hideSeparator = cellBuilder.forceHideSepparator || (indexPath.row == 0);
    
    [cell hideSeparatorView:hideSeparator];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *section = self.cellBuilders[indexPath.section];
    
    MPUCellBuilder *cellBuilder = section[indexPath.row];
    
    return cellBuilder.cellHeight;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  (section == 0) ? CGFLOAT_MIN : 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    view.backgroundColor = [MPUUIHelper colorFromHexString:@"#e7e7e7"];
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 36.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectZero];
    [view addSubview:separator];
    
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"separator" : separator}];
   
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separator(1)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"separator" : separator}];
    
    [view addConstraints:horizontalConstraints];
    [view addConstraints:verticalConstraints];
    
    view.backgroundColor = [UIColor clearColor];
    separator.backgroundColor = [MPUUIHelper colorFromHexString:@"#e7e7e7"];
    
    return view;
}

@end
