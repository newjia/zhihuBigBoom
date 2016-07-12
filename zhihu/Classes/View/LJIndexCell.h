//
//  LJIndexCell.h
//  zhihu
//
//  Created by 李佳 on 16/6/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJIndexCell : UITableViewCell
{
    UIImageView *logIV;
    UITextView *titleTV;
}

- (void)refreshWithData: (NSDictionary *)info;
@end
