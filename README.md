# DownloadFont
iOS 动态下载系统字体
### 注意事项
1）网上现在很多资料写的都是以前的，坑的我好惨。
`CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter)`这个方法要改成下面的
` CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)descs, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef  _Nonnull progressParameter) `。否则真机、模拟器都可运行但是不能打包。

2）报错：`incompatible block pointer types passing
 ‘BOOL(^)(CTFontDescriptorMatchingState,CFDictionaryRef)’ to parameter of type
 ‘CTFontDEscriptorProgressHandler _Nonnull’(aka ‘bool(^)(CTFontDescriptorMatchingState,CFDictionaryRef _Nonnull))`,解决办法同上。
 
3）`- (BOOL)isFontIsExist:(NSString *)fontName`都说是判断字体是否下载，但是通过我的实践
 ，该方法其实是判断字体是是否Apple预装的[Apple的字体详情](https://support.apple.com/zh-cn/HT202599)，所以如果你的字体如果不在预装的列表里面，即使你下载了字体，程序也会走`- (void)matchFontAnddownloadFontWithfontName:(NSString *)fontName`的方法，但是它不会再重新执行下载的代码块，它只会走匹配的字体代码块。
