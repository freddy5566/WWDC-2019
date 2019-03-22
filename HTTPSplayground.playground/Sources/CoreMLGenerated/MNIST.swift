//
// mnist.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class mnistInput : MLFeatureProvider {

  /// Grayscale image of hand written digit as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
  var image: CVPixelBuffer

  var featureNames: Set<String> {
    get {
      return ["image"]
    }
  }

  func featureValue(for featureName: String) -> MLFeatureValue? {
    if (featureName == "image") {
      return MLFeatureValue(pixelBuffer: image)
    }
    return nil
  }

  init(image: CVPixelBuffer) {
    self.image = image
  }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class mnistOutput : MLFeatureProvider {

  /// Source provided by CoreML

  private let provider : MLFeatureProvider


  /// Predicted digit as dictionary of strings to doubles
  lazy var output: [String : Double] = {
    [unowned self] in return self.provider.featureValue(for: "output")!.dictionaryValue as! [String : Double]
    }()

  /// classLabel as string value
  lazy var classLabel: String = {
    [unowned self] in return self.provider.featureValue(for: "classLabel")!.stringValue
    }()

  var featureNames: Set<String> {
    return self.provider.featureNames
  }

  func featureValue(for featureName: String) -> MLFeatureValue? {
    return self.provider.featureValue(for: featureName)
  }

  init(output: [String : Double], classLabel: String) {
    self.provider = try! MLDictionaryFeatureProvider(dictionary: ["output" : MLFeatureValue(dictionary: output as [AnyHashable : NSNumber]), "classLabel" : MLFeatureValue(string: classLabel)])
  }

  init(features: MLFeatureProvider) {
    self.provider = features
  }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class mnist {
  var model: MLModel

  /// URL of model assuming it was installed in the same bundle as this class
  class var urlOfModelInThisBundle : URL {
    let bundle = Bundle(for: mnist.self)
    return bundle.url(forResource: "mnist", withExtension:"mlmodelc")!
  }

  /**
   Construct a model with explicit path to mlmodelc file
   - parameters:
   - url: the file url of the model
   - throws: an NSError object that describes the problem
   */
  init(contentsOf url: URL) throws {
    self.model = try MLModel(contentsOf: url)
  }

  /// Construct a model that automatically loads the model from the app's bundle
  convenience init() {
    try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
  }

  /**
   Construct a model with configuration
   - parameters:
   - configuration: the desired model configuration
   - throws: an NSError object that describes the problem
   */
  @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
  convenience init(configuration: MLModelConfiguration) throws {
    try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
  }

  /**
   Construct a model with explicit path to mlmodelc file and configuration
   - parameters:
   - url: the file url of the model
   - configuration: the desired model configuration
   - throws: an NSError object that describes the problem
   */
  @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
  init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
    self.model = try MLModel(contentsOf: url, configuration: configuration)
  }

  /**
   Make a prediction using the structured interface
   - parameters:
   - input: the input to the prediction as mnistInput
   - throws: an NSError object that describes the problem
   - returns: the result of the prediction as mnistOutput
   */
  func prediction(input: mnistInput) throws -> mnistOutput {
    return try self.prediction(input: input, options: MLPredictionOptions())
  }

  /**
   Make a prediction using the structured interface
   - parameters:
   - input: the input to the prediction as mnistInput
   - options: prediction options
   - throws: an NSError object that describes the problem
   - returns: the result of the prediction as mnistOutput
   */
  func prediction(input: mnistInput, options: MLPredictionOptions) throws -> mnistOutput {
    let outFeatures = try model.prediction(from: input, options:options)
    return mnistOutput(features: outFeatures)
  }

  /**
   Make a prediction using the convenience interface
   - parameters:
   - image: Grayscale image of hand written digit as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
   - throws: an NSError object that describes the problem
   - returns: the result of the prediction as mnistOutput
   */
  func prediction(image: CVPixelBuffer) throws -> mnistOutput {
    let input_ = mnistInput(image: image)
    return try self.prediction(input: input_)
  }

  /**
   Make a batch prediction using the structured interface
   - parameters:
   - inputs: the inputs to the prediction as [mnistInput]
   - options: prediction options
   - throws: an NSError object that describes the problem
   - returns: the result of the prediction as [mnistOutput]
   */
  @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
  func predictions(inputs: [mnistInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [mnistOutput] {
    let batchIn = MLArrayBatchProvider(array: inputs)
    let batchOut = try model.predictions(from: batchIn, options: options)
    var results : [mnistOutput] = []
    results.reserveCapacity(inputs.count)
    for i in 0..<batchOut.count {
      let outProvider = batchOut.features(at: i)
      let result =  mnistOutput(features: outProvider)
      results.append(result)
    }
    return results
  }
}
