Class {
	#name : 'SamplerMode',
	#superclass : 'Object',
	#instVars : [
		'kernel',
		'nbIter',
		'initSample',
		'timeMax',
		'randomState',
		'n',
		'sample0',
		'detSample0',
		'sizeSample0',
		'chain',
		'timeStart'
	],
	#category : 'DPPh',
	#package : 'DPPh'
}

{ #category : 'accessing' }
SamplerMode >> initSample [

	^ initSample
]

{ #category : 'accessing' }
SamplerMode >> initSample: anObject [

	initSample := anObject
]

{ #category : 'initialization' }
SamplerMode >> initializeForSampling [

	initSample ifNil: [ initSample := self initializeInitSample ].
	sample0 := initSample.
	detSample0 := kernel
		              determinantWithRows: initSample
		              andColumns: initSample.
	sizeSample0 := sample0 size.
	chain := { sample0 } asOrderedCollection.
	timeStart := timeMax ifNil: [ 0 ] ifNotNil: [ Time current ]
]

{ #category : 'initialization' }
SamplerMode >> initializeInitSample [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SamplerMode >> kernel [

	^ kernel
]

{ #category : 'accessing' }
SamplerMode >> kernel: anObject [

	kernel := anObject.
	n := kernel numberOfRows.
]

{ #category : 'accessing' }
SamplerMode >> n [

	^ n
]

{ #category : 'accessing' }
SamplerMode >> nbIter [

	^ nbIter
]

{ #category : 'accessing' }
SamplerMode >> nbIter: anObject [

	nbIter := anObject
]

{ #category : 'accessing' }
SamplerMode >> randomState [

	^ randomState
]

{ #category : 'accessing' }
SamplerMode >> randomState: anObject [

	randomState := anObject
]

{ #category : 'sample' }
SamplerMode >> sample [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SamplerMode >> timeMax [

	^ timeMax
]

{ #category : 'accessing' }
SamplerMode >> timeMax: anObject [

	timeMax := anObject
]
