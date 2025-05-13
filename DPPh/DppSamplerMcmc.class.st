Class {
	#name : 'DppSamplerMcmc',
	#superclass : 'Object',
	#instVars : [
		'kernel',
		'randomState',
		'initSample',
		'nbIter',
		'timeMax',
		'samplerMode'
	],
	#category : 'DPPh',
	#package : 'DPPh'
}

{ #category : 'checking' }
DppSamplerMcmc >> checkRandom: randomObject [

	randomObject ifNil: [ ^ Random seed: 42 ]. "Arbitrarily chosen seed"
	randomObject class = Random ifTrue: [ ^ randomObject ].
	randomObject class = Integer
		ifTrue: [ ^ Random seed: randomObject ]
		ifFalse: [
		self error: 'Given parameter cannot be used as seed for Random' ]
]

{ #category : 'accessing - defaults' }
DppSamplerMcmc >> defaultNumberOfIterations [

	^ 10
]

{ #category : 'handling' }
DppSamplerMcmc >> handleArguments: aCollection [

	randomState := self checkRandom: aCollection first.
	initSample := aCollection second.
	nbIter := aCollection third
		          ifNil: [ self defaultNumberOfIterations ]
		          ifNotNil: [ aCollection third ].
	timeMax := aCollection fourth
]

{ #category : 'accessing' }
DppSamplerMcmc >> initSample [

	^ initSample
]

{ #category : 'accessing' }
DppSamplerMcmc >> initSample: anObject [

	initSample := anObject
]

{ #category : 'accessing' }
DppSamplerMcmc >> kernel [

	^ kernel
]

{ #category : 'accessing' }
DppSamplerMcmc >> kernel: anObject [

	kernel := anObject
]

{ #category : 'accessing' }
DppSamplerMcmc >> nbIter [

	^ nbIter
]

{ #category : 'accessing' }
DppSamplerMcmc >> nbIter: anObject [

	nbIter := anObject
]

{ #category : 'private' }
DppSamplerMcmc >> passParametersToSampler [

	samplerMode
		kernel: kernel;
		randomState: randomState;
		initSample: initSample;
		nbIter: nbIter;
		timeMax: timeMax
]

{ #category : 'accessing' }
DppSamplerMcmc >> randomState [

	^ randomState
]

{ #category : 'accessing' }
DppSamplerMcmc >> randomState: anObject [

	randomState := anObject
]

{ #category : 'sampling' }
DppSamplerMcmc >> sample [

	^ samplerMode sample
]

{ #category : 'accessing' }
DppSamplerMcmc >> samplerMode [

	^ samplerMode
]

{ #category : 'accessing' }
DppSamplerMcmc >> samplerMode: aSamplerMode [

	samplerMode := aSamplerMode new.
	self passParametersToSampler
]

{ #category : 'accessing' }
DppSamplerMcmc >> timeMax [

	^ timeMax
]

{ #category : 'accessing' }
DppSamplerMcmc >> timeMax: anObject [

	timeMax := anObject
]
