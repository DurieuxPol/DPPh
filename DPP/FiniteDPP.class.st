Class {
	#name : 'FiniteDPP',
	#superclass : 'Object',
	#instVars : [
		'kernel'
	],
	#category : 'DPP',
	#package : 'DPP'
}

{ #category : 'accessing' }
FiniteDPP >> kernel [

	^ kernel
]

{ #category : 'accessing' }
FiniteDPP >> kernel: anObject [

	kernel := anObject
]

{ #category : 'sample methods' }
FiniteDPP >> sampleMcmc: mode [

	^ self sampleMcmc: mode withArgs: { nil. nil. nil. nil }
]

{ #category : 'sample methods' }
FiniteDPP >> sampleMcmc: mode withArgs: aCollection [

	| mcmcSampler |
	mcmcSampler := DppSamplerMcmc new
		               kernel: kernel;
		               handleArguments: aCollection;
		               samplerMode: mode.
	^ mcmcSampler sample last
]
