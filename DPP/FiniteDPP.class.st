Class {
	#name : 'FiniteDPP',
	#superclass : 'Object',
	#instVars : [
		'kernel',
		'listOfSamples'
	],
	#category : 'DPP',
	#package : 'DPP'
}

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

	^ self sampleMcmc: mode withArgs: { nil. nil. nil. nil }
]

{ #category : 'sample methods' }
FiniteDPP >> sampleMcmc: mode withArgs: aCollection [

	| mcmcSampler sample |
	mcmcSampler := DppSamplerMcmc new
		               kernel: kernel;
		               handleArguments: aCollection;
		               samplerMode: mode.
	sample := mcmcSampler sample.
	listOfSamples addAll: sample.
	^ sample last
]
