//
// SentimentPolarity.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class SentimentPolarityInput : MLFeatureProvider {

    /// Features extracted from the text. as dictionary of strings to doubles
    public var input: [String : Double]

    public var featureNames: Set<String> {
        get {
            return ["input"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input") {
            return try! MLFeatureValue(dictionary: input as [NSObject : NSNumber])
        }
        return nil
    }
    
    public init(input: [String : Double]) {
        self.input = input
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class SentimentPolarityOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// The most likely polarity (positive or negative), for the given input. as string value
    public lazy var classLabel: String = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")!.stringValue
    }()

    /// The probabilities for each class label, for the given input. as dictionary of strings to doubles
    public lazy var classProbability: [String : Double] = {
        [unowned self] in return self.provider.featureValue(for: "classProbability")!.dictionaryValue as! [String : Double]
    }()

    public var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    public init(classLabel: String, classProbability: [String : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["classLabel" : MLFeatureValue(string: classLabel), "classProbability" : MLFeatureValue(dictionary: classProbability as [AnyHashable : NSNumber])])
    }

    public init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class SentimentPolarity {
    var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: SentimentPolarity.self)
        return bundle.url(forResource: "SentimentPolarity", withExtension:"mlmodelc")!
    }

    /**
        Construct a model with explicit path to mlmodelc file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration
        - parameters:
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    public convenience init(configuration: MLModelConfiguration) throws {
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
    public init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
        self.model = try MLModel(contentsOf: url, configuration: configuration)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as SentimentPolarityInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as SentimentPolarityOutput
    */
    public func prediction(input: SentimentPolarityInput) throws -> SentimentPolarityOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as SentimentPolarityInput
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as SentimentPolarityOutput
    */
    public func prediction(input: SentimentPolarityInput, options: MLPredictionOptions) throws -> SentimentPolarityOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return SentimentPolarityOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - input: Features extracted from the text. as dictionary of strings to doubles
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as SentimentPolarityOutput
    */
    public func prediction(input: [String : Double]) throws -> SentimentPolarityOutput {
        let input_ = SentimentPolarityInput(input: input)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface
        - parameters:
           - inputs: the inputs to the prediction as [SentimentPolarityInput]
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as [SentimentPolarityOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    public func predictions(inputs: [SentimentPolarityInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [SentimentPolarityOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [SentimentPolarityOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  SentimentPolarityOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
