Class {
	#name : 'DppSamplerMcmc',
	#superclass : 'Object',
	#instVars : [
		'kernel',
		'randomState',
		'initSample',
		'nbIter',
		'timeMax',
		'modeDic',
		'samplerMode'
	],
	#category : 'DPP',
	#package : 'DPP'
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

{ #category : 'accessing' }
DppSamplerMcmc >> initSample [

	^ initSample
]

{ #category : 'accessing' }
DppSamplerMcmc >> initSample: anObject [

	initSample := anObject
]

{ #category : 'initialization' }
DppSamplerMcmc >> initialize [

	nbIter := 10.
	self initializeModeDic
]

{ #category : 'private' }
DppSamplerMcmc >> initializeModeDic [

	modeDic := Dictionary
		           newFromKeys: #( #aed )
		           andValues: { AEDSampler new }
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
DppSamplerMcmc >> modeDic [

	^ modeDic
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

	| rng |
	rng := self checkRandom: randomState.
	samplerMode
		kernel: kernel;
		nbIter: nbIter;
		timeMax: timeMax;
		randomState: rng.
	initSample ifNil: [ initSample := samplerMode initializeInitSample ].
	samplerMode initSample: initSample
]

{ #category : 'accessing' }
DppSamplerMcmc >> randomState [

	^ randomState
]

{ #category : 'accessing' }
DppSamplerMcmc >> randomState: anObject [

	randomState := anObject
]

{ #category : 'sample' }
DppSamplerMcmc >> sample [

	^ samplerMode sample
]

{ #category : 'accessing' }
DppSamplerMcmc >> samplerMode [

	^ samplerMode
]

{ #category : 'accessing' }
DppSamplerMcmc >> samplerMode: aString [

	samplerMode := modeDic at: aString.
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
