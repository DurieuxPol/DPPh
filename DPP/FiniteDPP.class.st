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
		               samplerMode: mode.
	^ mcmcSampler sample last
]
