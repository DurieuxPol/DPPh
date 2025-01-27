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

	| mcmcSampler |
	mcmcSampler := DppSamplerMcmc new
		               kernel: kernel;
		               handleArguments: { nil. nil. nil. nil };
		               samplerMode: mode.
	^ mcmcSampler sample last
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
