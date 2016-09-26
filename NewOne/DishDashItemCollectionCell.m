//
//  DishDashItemCell.m
//  NewOne
//
//  Created by Vinay Ponnuri on 8/04/16.
//  Copyright © 2016 Vinay Ponnuri. All rights reserved.
//

#import "DishDashItemCollectionCell.h"
#import "DishDashConstants.h"

@implementation DishDashItemCollectionCell

- (void)fillDataWithContent:(NSDictionary *)content{
    //Loading Image and String calculations in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = [UIImage imageNamed:[content objectForKey:@"image"]];
        NSMutableAttributedString *attributedDishName = [self getAttributedTitleOfDish:content];
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgview_Dish.image = image;
            _lbl_DishName.attributedText = attributedDishName;
        });
    });
}

-(NSMutableAttributedString *)getAttributedTitleOfDish:(NSDictionary *)content{
    NSString *dishname = [content objectForKey:@"name"];
    NSMutableAttributedString *dishnameString  = [[NSMutableAttributedString alloc] initWithString:[content objectForKey:@"name"]];
    [dishnameString addAttribute:NSFontAttributeName value:[UIFont fontWithName:ROBOTO_BOLD size:16] range:NSMakeRange(0, dishname.length)];
    NSRange withRange = [dishname rangeOfString:@"with" options:NSCaseInsensitiveSearch];
    if (withRange.location != NSNotFound) {
        [dishnameString addAttribute:NSFontAttributeName value:[UIFont fontWithName:ROBOTO_LIGHT size:16] range:withRange];
    }
    NSRange andRange = [dishname rangeOfString:@"and" options:NSCaseInsensitiveSearch];
    if (withRange.location != NSNotFound) {
        [dishnameString addAttribute:NSFontAttributeName value:[UIFont fontWithName:ROBOTO_LIGHT size:16] range:andRange];
    }
    return dishnameString;
}

@end
