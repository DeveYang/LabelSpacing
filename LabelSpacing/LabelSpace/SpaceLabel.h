//
//  SpaceLabel.h
//  LabelSpacing
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 DeveYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpaceLabel : UILabel{
@private
    CGFloat characterSpacing_;       //字间距
    long    linesSpacing_;           //行间距
    CGFloat paragraphSpacing;        //段间距
}

@property(nonatomic,assign) CGFloat characterSpacing;
@property(nonatomic,assign) CGFloat paragraphSpacing;
@property(nonatomic,assign) long    linesSpacing;
@property(nonatomic,strong) UIColor* backgroundColors;
/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width;
/**
 *  返回一个label
 *
 *  @param frame           label的初始Frame
 *  @param LabelStr              传入的label内容
 *  @param fontName            字体名字
 *  @param fontSize            字体大小
 *  @param fontColor           字体颜色
 *  @param fontBgColor         背景颜色
 *  @param linesSpacing        行间距
 *  @param characterSpacing    字间距
 *  @param paragraphSpacing    段间距
 *  @param textAlignment    label位置(居左,右,中)
 *
 *  @return 设置好的label
 */
+ (SpaceLabel *)lableFrame:(CGRect)_frame Content:(NSString *)LabelStr FontName:(NSString *)fontName FontSize:(CGFloat)fontSize title_Color:(UIColor *)fontColor BgColor:(UIColor *)fontBgColor LinesSpac:(long)linesSpacing CharacterSpacing:(CGFloat)characterSpacing ParagraphSpacing:(CGFloat)paragraphSpacing TextAlignment:(int)textAlignment;

@end
