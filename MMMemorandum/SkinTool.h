//
//  SkinTool.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/21.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define skinColorKey @"skinColor"

@interface SkinTool : NSObject

+ (void)setSkincolor:(NSString *)skinColor;
+ (UIImage *)skinToolWithImageName:(NSString *)imageName;
+ (UIColor *)skinToolWithLabelColor;

@end
