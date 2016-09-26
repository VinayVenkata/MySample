//
//  DishDashItemDetailsViewController.m
//  NewOne
//
//  Created by Vinay Ponnuri on 8/04/16.
//  Copyright © 2016 Vinay Ponnuri. All rights reserved.
//

#import "DishDashItemDetailsViewController.h"
#import "DishDashConstants.h"


@interface DishDashItemDetailsViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imgview_Dish;
@property (nonatomic, weak) IBOutlet UILabel *lbl_DishName;
@property (nonatomic, weak) IBOutlet UIImageView *imgview_nutritions;

@end

@implementation DishDashItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadDetailsWithContent:_detailsContent];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)loadDetailsWithContent:(NSDictionary *)content{
    
    _imgview_Dish.image = [UIImage imageNamed:[content objectForKey:@"image"]];
    
    NSString *dishname = [content objectForKey:@"name"];
    NSMutableAttributedString *dishnameString  = [[NSMutableAttributedString alloc] initWithString:[content objectForKey:@"name"]];
    [dishnameString addAttribute:NSFontAttributeName value:[UIFont fontWithName:ROBOTO_BOLD size:24] range:NSMakeRange(0, dishname.length)];
    NSRange withRange = [dishname rangeOfString:@"with" options:NSCaseInsensitiveSearch];
    if (withRange.location != NSNotFound) {
        [dishnameString addAttribute:NSFontAttributeName value:[UIFont fontWithName:ROBOTO_LIGHT size:24] range:withRange];
    }
    NSRange andRange = [dishname rangeOfString:@"and" options:NSCaseInsensitiveSearch];
    if (withRange.location != NSNotFound) {
        [dishnameString addAttribute:NSFontAttributeName value:[UIFont fontWithName:ROBOTO_LIGHT size:16] range:andRange];
    }
    _lbl_DishName.attributedText = dishnameString;
}
@end
