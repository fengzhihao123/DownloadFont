//
//  ViewController.m
//  DownloadFont
//
//  Created by 冯志浩 on 16/7/18.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
@interface ViewController ()
{
    NSString *_errorMessage;
    NSString *_postName;
}
@property (weak, nonatomic) IBOutlet UILabel *fontLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _postName = @"FZLTXHK--GBK1-0";//若将该值换为Apple预装的字体ru：Cochin Bold则不会走matchFontAnddownloadFontWithfontName:方法
    
    BOOL isDownLoad = [self isFontIsExist:_postName];
    if (isDownLoad) {
        self.fontLabel.font = [UIFont fontWithName:_postName size:17];
    }else{
        [self matchFontAnddownloadFontWithfontName:_postName];
    }
}
//判断字体是否存在在apple字体预装列表中
- (BOOL)isFontIsExist:(NSString *)fontName {
    UIFont* font = [UIFont fontWithName:fontName size:12.0];
    if (font && ([font.fontName compare:fontName] == NSOrderedSame
                 || [font.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    } else {
        return NO;
    }
}
//匹配、下载字体
- (void)matchFontAnddownloadFontWithfontName:(NSString *)fontName{
    
    // 用字体的 PostScript 名字创建一个 Dictionary
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    // 创建一个字体描述对象 CTFontDescriptorRef
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    // 将字体描述对象放到一个 NSMutableArray 中
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    __block BOOL errorDuringDownload = NO;
    
    
    //匹配字体
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef _Nonnull progressParameter) {
        
        if (state == kCTFontDescriptorMatchingDidBegin) {//字体已经匹配
            
        } else if (state == kCTFontDescriptorMatchingDidFinish) {//字体 %@ 下载完成
            if (!errorDuringDownload) {
                dispatch_async( dispatch_get_main_queue(), ^ {
                    // 可以在这里修改 UI 控件的字体
                    self.fontLabel.font = [UIFont fontWithName:_postName size:17];
                    return ;
                });
            }
        }
        return (BOOL)YES;
    });
    
    
    //下载字体
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef _Nonnull progressParameter) {
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            NSLog(@" 字体开始下载 ");
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            NSLog(@" 字体下载完成 ");
            dispatch_async( dispatch_get_main_queue(), ^ {
                // 可以在这里修改 UI 控件的字体
                self.fontLabel.font = [UIFont fontWithName:_postName size:17];
                
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            NSLog(@" 下载进度 %.0f%% ", progressValue);
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                _errorMessage = [error description];
            } else {
                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // 设置标志
            errorDuringDownload = YES;
            NSLog(@" 下载错误: %@", _errorMessage);
        }
        
        return (BOOL)YES;
    });
}


@end
