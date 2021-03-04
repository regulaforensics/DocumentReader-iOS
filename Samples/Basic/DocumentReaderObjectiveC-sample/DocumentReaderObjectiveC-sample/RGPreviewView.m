//
//  RGPreviewView.m
//  DocumentReaderExample
//
//  Created by Dmitry Smolyakov on 2/13/20.
//  Copyright © 2020 Regula. All rights reserved.
//

#import "RGPreviewView.h"

@implementation RGPreviewView

- (instancetype)init
{
  self = [super init];
  if (self) {
    _videoPreviewLayer = (AVCaptureVideoPreviewLayer *) self.layer;
  }
  return self;
}

- (void)setSession:(AVCaptureSession *)session {
  self.videoPreviewLayer.session = session;
}

- (AVCaptureSession *)session {
  return self.videoPreviewLayer.session;
}

+ (Class)layerClass {
  return [AVCaptureVideoPreviewLayer self];
}


@end
