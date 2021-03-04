//
//  RGPreviewView.h
//  DocumentReaderExample
//
//  Created by Dmitry Smolyakov on 2/13/20.
//  Copyright © 2020 Regula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RGPreviewView : UIView

@property(nonatomic,readonly,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic,readwrite,strong) AVCaptureSession *session;

@end
