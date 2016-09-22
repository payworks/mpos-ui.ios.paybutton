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

#import "MPUApplicationSelectionController.h"
#import "MPUMposUiAppearance.h"
#import "MPUMposUi.h"
#import "MPUMposUiConfiguration.h"
#import "MPUUIHelper.h"

@interface MPUApplicationSelectionController ()

@property (nonatomic, weak) IBOutlet UILabel* selectAccountLabel;
@property (nonatomic, weak) IBOutlet UITableView* applicationsTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation MPUApplicationSelectionController

#pragma mark - UI-Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    MPUMposUiAppearance *appearance = self.mposUi.configuration.appearance;
    self.selectAccountLabel.backgroundColor = appearance.navigationBarTint;
    self.selectAccountLabel.textColor = appearance.navigationBarTextColor;
    self.applicationsTableView.backgroundColor = appearance.backgroundColor;
    
    self.applicationsTableView.hidden = YES;
    self.applicationsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1.)];
    self.applicationsTableView.tableFooterView.backgroundColor = [MPUUIHelper colorFromHexString:@"#e7e7e7"];
    
    [self l10n];
}

- (void)l10n {
    self.selectAccountLabel.text = [MPUUIHelper localizedString:@"MPUSelectAccount"];
    
    NSAttributedString *abortAttString = [[NSAttributedString alloc] initWithString:[MPUUIHelper localizedString:@"MPUAbort"] attributes:[MPUUIHelper actionButtonTitleAttributesBold:YES]];
    [self.cancelButton setAttributedTitle:abortAttString forState:UIControlStateNormal];
    self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.applicationsTableView.hidden = NO;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applications.count;
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

    MPApplicationInformation *applicationInformation = self.applications[indexPath.row];
    cell.textLabel.text = applicationInformation.applicationName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate applicationSelected:self.applications[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = self.mposUi.configuration.appearance.backgroundColor;
}



#pragma mark - IBActions

- (IBAction)didTapAbortButton:(id)sender {
    [self.delegate applicationSelectionAbortClicked];
}

@end
