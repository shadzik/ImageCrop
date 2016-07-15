//
//  ViewController.m
//  ImageCrop
//
//  Created by Bartosz Świątek on 15/07/16.
//  Copyright © 2016 Bartosz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet UIImageView* imageView;
@property UIImage* origImage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.origImage = [UIImage imageNamed:@"RefPhoto"];
    self.imageView.image = self.origImage;
}

- (IBAction)cropTo150x150:(id)sender
{
    UIImage* newImage = [self imageByScalingAndCroppingImage:self.origImage
                                                      toSize:CGSizeMake(150, 150)];
    self.imageView.image = newImage;
}

- (IBAction)cropTo300x300:(id)sender
{
    UIImage* newImage = [self imageByScalingAndCroppingImage:self.origImage
                                                      toSize:CGSizeMake(300, 300)];
    self.imageView.image = newImage;
}

- (IBAction)cropTo600x600:(id)sender
{
    UIImage* newImage = [self imageByScalingAndCroppingImage:self.origImage
                                                      toSize:CGSizeMake(600, 600)];
    //[self imageByCroppingImage:self.origImage toSize:CGSizeMake(600, 600)];
    self.imageView.image = newImage;
}

- (IBAction)cropToFullWidth:(id)sender
{
    UIImage* newImage = [self imageByScalingAndCroppingImage:self.origImage
                                                      toSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)];

    //      [self imageByCroppingImage:self.origImage
    //                          toSize:CGSizeMake(self.imageView.frame.size.width,
    //                                            self.imageView.frame.size.height)];
    self.imageView.image = newImage;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (UIImage*)imageByCroppingImage:(UIImage*)image toSize:(CGSize)size
{
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);

    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;

    CGRect cropRect = CGRectMake(x, y, size.width, size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);

    UIImage* cropped = [UIImage imageWithCGImage:imageRef
                                           scale:0.0
                                     orientation:image.imageOrientation];
    CGImageRelease(imageRef);

    return cropped;
}

- (UIImage*)imageByScalingAndCroppingImage:(UIImage*)image
                                    toSize:(CGSize)size
{
    CGFloat factor = 0.0;
    CGFloat widthFactor = size.width / image.size.width;
    CGFloat heightFactor = size.height / image.size.height;

    if (widthFactor > heightFactor) {
        factor = widthFactor;
    }
    else {
        factor = heightFactor; //scale to fit width
    }

    CGFloat x = 0.0;
    CGFloat y = 0.0;
    // center the image
    if (widthFactor > heightFactor) {
        y = (size.height - image.size.height * factor) * 0.5;
    }
    else {
        x = (size.width - image.size.width * factor) * 0.5;
    }

    UIGraphicsBeginImageContext(size); // this will crop

    CGRect cropRect = CGRectZero;
    cropRect.origin = CGPointMake(x, y);
    cropRect.size = CGSizeMake(image.size.width * factor, image.size.height * factor);
    [image drawInRect:cropRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end
