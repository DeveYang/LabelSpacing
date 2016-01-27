//
//  SpaceLabel.m
//  LabelSpacing
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 DeveYang. All rights reserved.
//

#import "SpaceLabel.h"
#import <CoreText/CoreText.h>
@interface SpaceLabel(){
@private
    NSMutableAttributedString *attributedString;
}
- (void) initAttributedString;
@end
@implementation SpaceLabel
@synthesize characterSpacing = characterSpacing_;
@synthesize linesSpacing = linesSpacing_;
@synthesize paragraphSpacing = _paragraphSpacing;

- (id)initWithFrame:(CGRect)frame
{
    //初始化字间距、行间距
    if(self =[super initWithFrame:frame])
        
    {
        self.characterSpacing = 1.5f;
        self.linesSpacing = 4.0f;
        self.paragraphSpacing = 10.0f;
    }
    
    return self;
}
//外部调用设置字间距
-(void)setCharacterSpacing:(CGFloat)characterSpacing
{
    characterSpacing_ = characterSpacing;
    [self setNeedsDisplay];
}

//外部调用设置行间距
-(void)setLinesSpacing:(long)linesSpacing
{
    linesSpacing_ = linesSpacing;
    [self setNeedsDisplay];
}

/*
 *初始化AttributedString并进行相应设置
 */
- (void) initAttributedString
{
    if(attributedString==nil){
        NSString *labelString = self.text;
        
        //创建AttributeString
        attributedString =[[NSMutableAttributedString alloc]initWithString:labelString];
        
        //设置字体及大小
        CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize,NULL);
        [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0,[attributedString length])];
        
        //设置字间距
        long number = self.characterSpacing;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        CFRelease(num);
        /*
         if(self.characterSpacing)
         {
         long number = self.characterSpacing;
         CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
         [attributedString addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(0,[attributedString length])];
         CFRelease(num);
         }
         */
        
        //设置字体颜色
        [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(self.textColor.CGColor) range:NSMakeRange(0,[attributedString length])];
        
        //创建文本对齐方式
        CTTextAlignment alignment = kCTLeftTextAlignment;
        if(self.textAlignment == NSTextAlignmentCenter)
        {
            alignment = kCTCenterTextAlignment;
        }
        if(self.textAlignment == NSTextAlignmentRight)
        {
            alignment = kCTRightTextAlignment;
        }
        
        CTParagraphStyleSetting alignmentStyle;
        
        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        
        alignmentStyle.valueSize = sizeof(alignment);
        
        alignmentStyle.value = &alignment;
        
        //设置文本行间距
        /*
         CGFloat lineSpace = self.linesSpacing;
         */
        CGFloat lineSpace = self.linesSpacing;
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        lineSpaceStyle.valueSize = sizeof(lineSpace);
        lineSpaceStyle.value =&lineSpace;
        
        //设置文本段间距
        CGFloat paragraphSpacings = self.paragraphSpacing;
        CTParagraphStyleSetting paragraphSpaceStyle;
        paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
        paragraphSpaceStyle.valueSize = sizeof(CGFloat);
        paragraphSpaceStyle.value = &paragraphSpacings;
        
        //创建设置数组
        CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
        
        //给文本添加设置
        [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [attributedString length])];
        CFRelease(helveticaBold);
    }
}
/*
 *覆写setText方法
 */
- (void) setText:(NSString *)text
{
    [super setText:text];
    [self initAttributedString];
}
/*
 *开始绘制
 */
-(void) drawTextInRect:(CGRect)requestedRect
{
    [self initAttributedString];
    
    //排版
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    //翻转坐标系统（文本原来是倒的要翻转下）
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    //画出文本
    
    CTFrameDraw(leftFrame,context);
    
    //释放
    
    CGPathRelease(leftColumnPath);
    
    CFRelease(framesetter);
    
    UIGraphicsPushContext(context);
}

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width
{
    [self initAttributedString];
    
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 100000 - line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
}
+ (SpaceLabel *)lableFrame:(CGRect)_frame Content:(NSString *)LabelStr FontName:(NSString *)fontName FontSize:(CGFloat)fontSize title_Color:(UIColor *)fontColor BgColor:(UIColor *)fontBgColor LinesSpac:(long)linesSpacing CharacterSpacing:(CGFloat)characterSpacing ParagraphSpacing:(CGFloat)paragraphSpacing TextAlignment:(int)textAlignment{
    SpaceLabel *customLabel = [[SpaceLabel alloc] initWithFrame:_frame];
    customLabel.numberOfLines = 0;
    //设置字体颜色
    customLabel.textColor = fontColor;
    //设置label的背景颜色
    customLabel.backgroundColor = fontBgColor;
    //设置label的行间距 默认4.0
    [customLabel setLinesSpacing:linesSpacing];
    //设置label的字间距 默认 1.5
    [customLabel setCharacterSpacing:characterSpacing];
    //设置label的段间距 默认 10.0
    [customLabel setParagraphSpacing:paragraphSpacing];
    //使用自定义字体
    customLabel.font = [UIFont systemFontOfSize:fontSize];
    //设置label显示内容
    customLabel.text = LabelStr;
    //设置文字位置
    customLabel.textAlignment = textAlignment;
    //根据字符串长度和Label显示的宽度计算出contentLab的高
    int labelHeight = [customLabel getAttributedStringHeightWidthValue:_frame.size.width];
    _frame.size.height = labelHeight;
    customLabel.frame = _frame;
    return customLabel;
}


@end
