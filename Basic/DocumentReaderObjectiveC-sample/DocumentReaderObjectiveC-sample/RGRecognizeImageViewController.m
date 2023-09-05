//
//  RGRecognizeImageViewController.m
//  DocumentReaderExample
//
//  Created by Dmitry Smolyakov on 7/20/20.
//  Copyright © 2020 Regula. All rights reserved.
//

@import DocumentReader;
#import "RGRecognizeImageViewController.h"

@interface RGRecognizeImageViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, strong, nullable) RGPreviewView *previewView;
@property(nonatomic, nullable) AVCaptureSession *session;
@property(nonatomic, strong, nonnull) dispatch_queue_t sessionQueue;
@property(nonatomic, strong, nonnull) dispatch_queue_t captureQueue;
@property(nonatomic, assign) RGSessionSetupResult setupResult;
@property(nonatomic, nullable) AVCaptureDevice *captureDevice;
@property(nonatomic, nullable) AVCaptureDeviceInput *videoDeviceInput;
@property(nonatomic, assign) AVCaptureDevicePosition cameraPosition;
@property(nonatomic, strong)dispatch_semaphore_t scanningSemaphore;
@property(nonatomic, strong, nonnull) dispatch_queue_t scaningQueue;

@end

@implementation RGRecognizeImageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cameraPosition = AVCaptureDevicePositionBack;
        _sessionQueue = dispatch_queue_create("sessionqueue", NULL);
        _captureQueue = dispatch_queue_create("capturequeue", NULL);
        _scaningQueue = dispatch_queue_create("scaningqueue", DISPATCH_QUEUE_SERIAL);
        
        _scanningSemaphore = dispatch_semaphore_create(1);
        _setupResult = RGSessionSetupResultSuccess;
        _session = [[AVCaptureSession alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [RGLDocReader.shared startNewSession];
    
    self.previewView = [[RGPreviewView alloc] init];
    [self.view insertSubview:self.previewView atIndex:0];
    [self initPreviewView];
    
    self.previewView.session = self.session;
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
      case AVAuthorizationStatusAuthorized:
        break;
      case AVAuthorizationStatusNotDetermined: {
        dispatch_suspend(self.sessionQueue);
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
          if (!granted) {
            self.setupResult = RGSessionSetupResultNotAuthorized;
          }
          dispatch_resume(self.sessionQueue);
        }];
        break;
      }
      default:
        self.setupResult = RGSessionSetupResultNotAuthorized;
    }
    
    dispatch_async(self.sessionQueue, ^{
      [self configureSession];
    });
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  __weak RGRecognizeImageViewController *weakSelf = self;
  dispatch_async(weakSelf.sessionQueue, ^{
    switch (weakSelf.setupResult) {
      case RGSessionSetupResultSuccess: {
        [weakSelf.session startRunning];
        break;
      }
      case RGSessionSetupResultNotAuthorized: {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"App do not have permission");
        });
        break;
      }
      case RGSessionSetupResultConfigurationFailed: {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Unable to capture media");
        });
      }
      default:
        break;
    }
  });
}

- (void)configureSession {
  if (self.setupResult != RGSessionSetupResultSuccess) {
    return;
  }
  
  @try {
    self.captureDevice = [self selectCamera];
    [self setupCaptureDevice];
    
    if (self.captureDevice) {
      NSError *error;
      AVCaptureDeviceInput *videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:&error];
      
      if (videoDeviceInput) {
        if ([self.session canAddInput:videoDeviceInput]) {
          [self.session addInput:videoDeviceInput];
          self.videoDeviceInput = videoDeviceInput;
          
          dispatch_async(dispatch_get_main_queue(), ^{
            UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
            if (statusBarOrientation != UIInterfaceOrientationUnknown) {
              AVCaptureVideoOrientation videoOrientation = [self videoOrientation:statusBarOrientation];
              initialVideoOrientation = videoOrientation;
            }
            self.previewView.videoPreviewLayer.connection.videoOrientation = initialVideoOrientation;
          });
        } else {
          NSLog(@"Could not add video device input to the session");
          self.setupResult = RGSessionSetupResultConfigurationFailed;
          [self.session commitConfiguration];
          return;
        }
      }
    }
  } @catch (NSException *exception) {
    NSLog(@"Could not create video device input: %@", exception);
    self.setupResult = RGSessionSetupResultConfigurationFailed;
    [self.session commitConfiguration];
    return;
  }
  
  AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
  
  if ([self.session canAddOutput:videoOutput]) {
    [self.session addOutput:videoOutput];
    [videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
  } else {
    NSLog(@"Could not add video output to the session");
    self.setupResult = RGSessionSetupResultConfigurationFailed;
    [self.session commitConfiguration];
    return;
  }
    
  [self.session commitConfiguration];
  
  [self setupSessionPreset];
}

- (AVCaptureDevice *)selectCamera {
  AVCaptureDevice *defaultVideoDevice = nil;
  
  if (@available(iOS 10.2, *)) {
    if (self.cameraPosition == AVCaptureDevicePositionUnspecified || self.cameraPosition == AVCaptureDevicePositionBack) {
      defaultVideoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
      if (defaultVideoDevice == nil) {
        defaultVideoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
      }
      if (self.cameraPosition == AVCaptureDevicePositionUnspecified && defaultVideoDevice == nil) {
        defaultVideoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
      }
    } else if (self.cameraPosition == AVCaptureDevicePositionFront) {
      defaultVideoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    }
  } else {
    for (AVCaptureDevice *device in AVCaptureDevice.devices) {
      
      if ([device hasMediaType:AVMediaTypeVideo]) {
        if (self.cameraPosition == AVCaptureDevicePositionUnspecified || self.cameraPosition == AVCaptureDevicePositionBack) {
          if (device.position == AVCaptureDevicePositionBack) {
            defaultVideoDevice = device;
          } else if (self.cameraPosition == AVCaptureDevicePositionUnspecified && defaultVideoDevice == nil && device.position == AVCaptureDevicePositionFront) {
            defaultVideoDevice = device;
          }
        } else if (self.cameraPosition == AVCaptureDevicePositionFront) {
          defaultVideoDevice = device;
        }
      }
    }
  }
  return defaultVideoDevice;
}

- (void)setupSessionPreset {
    AVCaptureSessionPreset currentSessionPreset = [self.session sessionPreset];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080] && currentSessionPreset != AVCaptureSessionPreset1920x1080) {
      [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    } else if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720] && currentSessionPreset != AVCaptureSessionPreset1280x720) {
      [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    } else if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480] && currentSessionPreset != AVCaptureSessionPreset640x480) {
      [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
}

- (void)setupCaptureDevice {
  if (self.captureDevice) {
    @try {
      NSError *error;
      if ([self.captureDevice lockForConfiguration:&error]) {
        if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
          self.captureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        
        if ([self.captureDevice isSmoothAutoFocusEnabled]) {
          [self.captureDevice setSmoothAutoFocusEnabled:YES];
        }
                        
        if ([self.captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
          self.captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        }
        
        if ([self.captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
          self.captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
        }
        
        [self.captureDevice unlockForConfiguration];
      }
    } @catch (NSException *exception) {
      NSLog(@"Eror during capture device setup: %@", exception);
    }
  }
}

- (void)initPreviewView {
    [self.previewView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.previewView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewView.backgroundColor = UIColor.blackColor;
    
    [[NSLayoutConstraint constraintWithItem:self.previewView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.previewView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:self.previewView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.previewView attribute:NSLayoutAttributeWidth multiplier:1.777777 constant:0] setActive:YES];
    
    
    NSLayoutConstraint *topConstr = [NSLayoutConstraint constraintWithItem:self.previewView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [topConstr setPriority:998];
    [topConstr setActive:YES];
    
    NSLayoutConstraint *bottomConstr;
    if (@available(iOS 11.0, *)) {
        bottomConstr = [self.view.safeAreaLayoutGuide.bottomAnchor constraintLessThanOrEqualToAnchor:self.previewView.bottomAnchor constant:46];
    } else {
        bottomConstr = [NSLayoutConstraint constraintWithItem:self.previewView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-46];
    }
    [bottomConstr setPriority:999];
    [bottomConstr setActive:YES];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    @autoreleasepool {
        if (self.captureDevice && self.captureDevice.isAdjustingFocus && self.captureDevice.isAdjustingExposure && self.captureDevice.isAdjustingWhiteBalance) {
            return;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage *image = [self generateUIImageDidOutputSampleBuffer:sampleBuffer];
            if (dispatch_semaphore_wait(self.scanningSemaphore, DISPATCH_TIME_NOW) == 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    dispatch_async(self.scaningQueue, ^{
                        [RGLDocReader.shared recognizeVideoFrame:image completion:^(RGLDocReaderAction action, RGLDocumentReaderResults * _Nullable results, NSError * _Nullable error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (action == RGLDocReaderActionComplete || action == RGLDocReaderActionMorePagesAvailable) {
                                    [self.delegate recognizeDidFinishedWith:results viewController:self];
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }
                                dispatch_semaphore_signal(self.scanningSemaphore);
                            });
                        }];
                    });
                });
            }
        });
    }
}

- (UIImage *)generateUIImageDidOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
  return [self convertImageFromSampleBuffer:sampleBuffer frame:self.view.frame cropRect:self.view.bounds cameraPosition:self.cameraPosition];
}

- (UIImage *)convertImageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer frame:(CGRect)frame cropRect:(CGRect)cropRect cameraPosition:(AVCaptureDevicePosition)cameraPosition {
  CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  if (imageBuffer) {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    UIImage *image = [self getImageFromCIImage:ciImage frame:frame cropRect:cropRect cameraPosition:cameraPosition];
    return image;
  } else {
    return nil;
  }
}
                      
- (UIImage *)getImageFromCIImage:(CIImage *)ciImage frame:(CGRect)frame cropRect:(CGRect)cropRect cameraPosition:(AVCaptureDevicePosition)cameraPosition {
    UIDeviceOrientation orientation = [self deviceOrientation:[UIApplication sharedApplication].statusBarOrientation];

    CGFloat angle = 0;
    if (orientation == UIDeviceOrientationPortrait) {
      angle = (CGFloat)(-M_PI / 2.0);
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
      if (cameraPosition == AVCaptureDevicePositionBack || cameraPosition == AVCaptureDevicePositionUnspecified) {
        angle = M_PI;
      }
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
      if (cameraPosition == AVCaptureDevicePositionFront) {
        angle = M_PI;
      }
    }

    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
    CIImage *outputImage = [ciImage imageByApplyingTransform:transform];
    CIContext *imageContext = [CIContext contextWithOptions:nil];

    CGRect resultRect = CGRectMake(CGRectGetMinX(outputImage.extent) + CGRectGetMinX(cropRect) * (outputImage.extent.size.width / frame.size.width),
                                   CGRectGetMinY(outputImage.extent) + CGRectGetMinY(cropRect) * (outputImage.extent.size.height / frame.size.height),
                                   outputImage.extent.size.width * (cropRect.size.width / frame.size.width),
                                   outputImage.extent.size.height * (cropRect.size.height / frame.size.height));

    CGImageRef cgim = [imageContext createCGImage:outputImage fromRect:resultRect];
    UIImage *image = [UIImage imageWithCGImage:cgim];
    CGImageRelease(cgim);
    return image;
}

                      
- (AVCaptureVideoOrientation)videoOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationUnknown:
            return AVCaptureVideoOrientationPortrait;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
    }
}

- (UIDeviceOrientation)deviceOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return UIDeviceOrientationPortrait;
        case UIInterfaceOrientationLandscapeLeft:
            return UIDeviceOrientationLandscapeRight;
        case UIInterfaceOrientationLandscapeRight:
            return UIDeviceOrientationLandscapeLeft;
        default:
            return UIScreen.mainScreen.bounds.size.height > UIScreen.mainScreen.bounds.size.width ? UIDeviceOrientationPortrait : UIDeviceOrientationLandscapeRight;
    }
}

@end
