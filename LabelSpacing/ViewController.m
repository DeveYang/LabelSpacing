//
//  ViewController.m
//  LabelSpacing
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 DeveYang. All rights reserved.
//

#import "ViewController.h"
#import "SpaceLabel.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    SpaceLabel *spaceLabel = [SpaceLabel lableFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 10) Content:str FontName:@"Arial" FontSize:13 title_Color:[UIColor grayColor] BgColor:[UIColor clearColor] LinesSpac:0 CharacterSpacing:1.5 ParagraphSpacing:0 TextAlignment:0];
    spaceLabel.layer.borderWidth = 1;//边框宽度
    spaceLabel.layer.borderColor = [UIColor redColor].CGColor;//边框颜色
    [self.view addSubview:spaceLabel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
