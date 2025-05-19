Class {
	#name : 'FiniteDPP',
	#superclass : 'Object',
	#instVars : [
		'kernel',
		'listOfSamples'
	],
	#category : 'DPPh',
	#package : 'DPPh'
}

{ #category : 'instance creation' }
FiniteDPP class >> correlation: kernel [

	^ self new kernel: kernel
]

{ #category : 'instance creation' }
FiniteDPP class >> correlationWithEigenValues: values andVectors: vectors [

	^ self new kernel:
		  (vectors elementwiseProductWithVector: values) * vectors transpose
]

{ #category : 'flushing' }
FiniteDPP >> flushSamples [

	listOfSamples := {  } asOrderedCollection
]

{ #category : 'initialization' }
FiniteDPP >> initialize [

	listOfSamples := {  } asOrderedCollection
]

{ #category : 'accessing' }
FiniteDPP >> kernel [

	^ kernel
]

{ #category : 'accessing' }
FiniteDPP >> kernel: anObject [

	kernel := anObject
]

{ #category : 'accessing' }
FiniteDPP >> listOfSamples [

	^ listOfSamples
]

{ #category : 'accessing' }
FiniteDPP >> listOfSamples: anObject [

	listOfSamples := anObject
]

{ #category : 'sample methods' }
FiniteDPP >> sampleMcmc: mode [

	^ self sampleMcmc: mode withArgs: { nil. nil. nil. nil . nil }
]

{ #category : 'sample methods' }
FiniteDPP >> sampleMcmc: mode withArgs: aCollection [
	"aCollection should always be of size at least 5 and shaped like: { randomSate . initSample . initSampleSize . nbIter . timeMax }. Elements of the collection can be nil"

	| mcmcSampler sample |
	mcmcSampler := DppSamplerMcmc new
		               kernel: kernel;
		               handleArguments: aCollection;
		               samplerMode: mode.
	sample := mcmcSampler sample.
	listOfSamples addAll: sample.
	^ sample last
]
