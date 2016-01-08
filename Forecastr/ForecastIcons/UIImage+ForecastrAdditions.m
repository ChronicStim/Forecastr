//
//  UIImage+ForecastrAdditions.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "UIImage+ForecastrAdditions.h"

@implementation UIImage (ForecastrAdditions)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize scale:(CGFloat)scale;
{
    if (nil == image || CGSizeEqualToSize(newSize, CGSizeZero)) {
        return nil;
    }
    
    if (0 == scale) {
        // Use same scale factor as input image
        scale = [image scale];
    }
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width*scale, newSize.height*scale));
    CGImageRef imageRef = image.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end
