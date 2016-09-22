//
//  MPUTransactionCellTableViewCell.h
//  mpos-ui
//
//  Created by Leonid Popescu on 01/09/16.
//  Copyright © 2016 payworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPUTransactionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *separatorView;

- (void)hideSeparatorView:(BOOL)hide;

@end
