Class {
	#name : 'SamplerMode',
	#superclass : 'Object',
	#instVars : [
		'kernel',
		'nbIter',
		'initSample',
		'timeMax',
		'randomState'
	],
	#category : 'DPP',
	#package : 'DPP'
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
SamplerMode >> initializeInitSample [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SamplerMode >> kernel [

	^ kernel
]

{ #category : 'accessing' }
SamplerMode >> kernel: anObject [

	kernel := anObject
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
