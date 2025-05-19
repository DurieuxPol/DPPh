Class {
	#name : 'SamplerMode',
	#superclass : 'Object',
	#instVars : [
		'kernel',
		'kernelSize',
		'groundSet',
		'nbIter',
		'initSample',
		'initSampleSize',
		'timeMax',
		'randomState',
		'sample0',
		'sample0Det',
		'sample0Size',
		'timeStart',
		'samplesChain'
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

{ #category : 'as yet unclassified' }
SamplerMode >> initSampleDraw: size [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SamplerMode >> initSampleSize [

	^ initSampleSize
]

{ #category : 'accessing' }
SamplerMode >> initSampleSize: anObject [

	initSampleSize := anObject
]

{ #category : 'initialization' }
SamplerMode >> initializeForSampling [

	groundSet := (1 to: kernelSize) asOrderedCollection.
	initSample ifNil: [ initSample := self initializeInitSample: initSampleSize ].
	sample0 := initSample.
	sample0Det := kernel
		              determinantWithRows: initSample
		              andColumns: initSample.
	sample0Size := sample0 size.
	samplesChain := { sample0 } asOrderedCollection.
	timeStart := timeMax ifNil: [ 0 ] ifNotNil: [ Time current ]
]

{ #category : 'initialization' }
SamplerMode >> initializeInitSample: sampleSize [

	| sample sampleDet nbTrials tol |
	sample := {  } asOrderedCollection.
	sampleDet := 0.
	nbTrials := 100.
	tol := 10 ** -9.

	1 to: nbTrials do: [ :i |
		sampleDet > tol ifTrue: [ ^ sample ].
		sample := self initSampleDraw: sampleSize.
		sampleDet := kernel determinantWithRows: sample andColumns: sample ].

	^ Error signal: 'After ' , nbTrials printString
		  , ' trials, no initial set s0 satisfies det Ls0 > '
		  , tol printString
]

{ #category : 'accessing' }
SamplerMode >> kernel [

	^ kernel
]

{ #category : 'accessing' }
SamplerMode >> kernel: anObject [

	kernel := anObject.
	kernelSize := kernel numberOfRows.
]

{ #category : 'accessing' }
SamplerMode >> kernelSize [

	^ kernelSize
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
