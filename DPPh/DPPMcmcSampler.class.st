Class {
	#name : 'DPPMcmcSampler',
	#superclass : 'Object',
	#instVars : [
		'kernel',
		'randomState',
		'initSample',
		'initSampleSize',
		'nbIter',
		'timeMax',
		'samplerMode'
	],
	#category : 'DPPh',
	#package : 'DPPh'
}

{ #category : 'checking' }
DPPMcmcSampler >> checkRandom: randomObject [

	randomObject ifNil: [ ^ Random seed: 42 ]. "Arbitrarily chosen seed"
	randomObject class = Random ifTrue: [ ^ randomObject ].
	randomObject class = Integer
		ifTrue: [ ^ Random seed: randomObject ]
		ifFalse: [
		self error: 'Given parameter cannot be used as seed for Random' ]
]

{ #category : 'accessing - defaults' }
DPPMcmcSampler >> defaultNumberOfIterations [

	^ 10
]

{ #category : 'handling' }
DPPMcmcSampler >> handleArguments: aCollection [

	randomState := self checkRandom: aCollection first.
	initSample := aCollection second.
	initSampleSize := aCollection third.
	nbIter := aCollection fourth
		          ifNil: [ self defaultNumberOfIterations ]
		          ifNotNil: [ aCollection fourth ].
	timeMax := aCollection fifth
]

{ #category : 'accessing' }
DPPMcmcSampler >> initSample [

	^ initSample
]

{ #category : 'accessing' }
DPPMcmcSampler >> initSample: anObject [

	initSample := anObject
]

{ #category : 'accessing' }
DPPMcmcSampler >> initSampleSize [

	^ initSampleSize
]

{ #category : 'accessing' }
DPPMcmcSampler >> initSampleSize: anObject [

	initSampleSize := anObject
]

{ #category : 'accessing' }
DPPMcmcSampler >> kernel [

	^ kernel
]

{ #category : 'accessing' }
DPPMcmcSampler >> kernel: anObject [

	kernel := anObject
]

{ #category : 'accessing' }
DPPMcmcSampler >> nbIter [

	^ nbIter
]

{ #category : 'accessing' }
DPPMcmcSampler >> nbIter: anObject [

	nbIter := anObject
]

{ #category : 'private' }
DPPMcmcSampler >> passParametersToSampler [

	samplerMode
		kernel: kernel;
		randomState: randomState;
		initSample: initSample;
		initSampleSize: initSampleSize;
		nbIter: nbIter;
		timeMax: timeMax
]

{ #category : 'accessing' }
DPPMcmcSampler >> randomState [

	^ randomState
]

{ #category : 'accessing' }
DPPMcmcSampler >> randomState: anObject [

	randomState := anObject
]

{ #category : 'sampling' }
DPPMcmcSampler >> sample [

	^ samplerMode sample
]

{ #category : 'accessing' }
DPPMcmcSampler >> samplerMode [

	^ samplerMode
]

{ #category : 'accessing' }
DPPMcmcSampler >> samplerMode: aSamplerMode [

	samplerMode := aSamplerMode new.
	self passParametersToSampler
]

{ #category : 'accessing' }
DPPMcmcSampler >> timeMax [

	^ timeMax
]

{ #category : 'accessing' }
DPPMcmcSampler >> timeMax: anObject [

	timeMax := anObject
]
