//
//  MPUCreditDebitSelectionController.m
//  mpos-ui
//
//  Created by Simon Eumes on 13.12.16.
//  Copyright © 2016 payworks. All rights reserved.
//

#import "MPUCreditDebitSelectionController.h"
#import "MPUMposUiAppearance.h"
#import "MPUMposUi.h"
#import "MPUMposUiConfiguration.h"
#import "MPUUIHelper.h"

@interface MPUCreditDebitSelectionController ()

@property (nonatomic, weak) IBOutlet UILabel* selectCreditDebitLabel;
@property (nonatomic, weak) IBOutlet UITableView* listTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation MPUCreditDebitSelectionController

#pragma mark - UI-Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MPUMposUiAppearance *appearance = self.mposUi.configuration.appearance;
    self.selectCreditDebitLabel.backgroundColor = appearance.navigationBarTint;
    self.selectCreditDebitLabel.textColor = appearance.navigationBarTextColor;
    self.listTableView.backgroundColor = appearance.backgroundColor;
    
    self.listTableView.hidden = YES;
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1.)];
    self.listTableView.tableFooterView.backgroundColor = [MPUUIHelper colorFromHexString:@"#e7e7e7"];
    
    [self l10n];
}

- (void)l10n {
    self.selectCreditDebitLabel.text = [MPUUIHelper localizedString:@"MPUPleaseSelect"];
    
    NSAttributedString *abortAttString = [[NSAttributedString alloc] initWithString:[MPUUIHelper localizedString:@"MPUAbort"] attributes:[MPUUIHelper actionButtonTitleAttributesBold:YES]];
    [self.cancelButton setAttributedTitle:abortAttString forState:UIControlStateNormal];
    self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.listTableView.hidden = NO;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ApplicationSelectionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 0){
        cell.textLabel.text = [MPUUIHelper localizedString:@"MPUCredit"];
    }
    else {
        cell.textLabel.text = [MPUUIHelper localizedString:@"MPUDebit"];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        [self.delegate creditSelected];
    }
    else {
        [self.delegate debitSelected];
    }    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = self.mposUi.configuration.appearance.backgroundColor;
}



#pragma mark - IBActions

- (IBAction)didTapAbortButton:(id)sender {
    [self.delegate creditDebitSelectionAbortClicked];
}

@end
