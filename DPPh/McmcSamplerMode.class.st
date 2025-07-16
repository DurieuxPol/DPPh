Class {
	#name : 'McmcSamplerMode',
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
McmcSamplerMode >> initSample [

	^ initSample
]

{ #category : 'accessing' }
McmcSamplerMode >> initSample: anObject [

	initSample := anObject
]

{ #category : 'as yet unclassified' }
McmcSamplerMode >> initSampleDraw: size [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
McmcSamplerMode >> initSampleSize [

	^ initSampleSize
]

{ #category : 'accessing' }
McmcSamplerMode >> initSampleSize: anObject [

	initSampleSize := anObject
]

{ #category : 'initialization' }
McmcSamplerMode >> initializeForSampling [

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
McmcSamplerMode >> initializeInitSample: sampleSize [

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
McmcSamplerMode >> kernel [

	^ kernel
]

{ #category : 'accessing' }
McmcSamplerMode >> kernel: anObject [

	kernel := anObject.
	kernelSize := kernel numberOfRows.
]

{ #category : 'accessing' }
McmcSamplerMode >> kernelSize [

	^ kernelSize
]

{ #category : 'accessing' }
McmcSamplerMode >> nbIter [

	^ nbIter
]

{ #category : 'accessing' }
McmcSamplerMode >> nbIter: anObject [

	nbIter := anObject
]

{ #category : 'accessing' }
McmcSamplerMode >> randomState [

	^ randomState
]

{ #category : 'accessing' }
McmcSamplerMode >> randomState: anObject [

	randomState := anObject
]

{ #category : 'sample' }
McmcSamplerMode >> sample [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
McmcSamplerMode >> timeMax [

	^ timeMax
]

{ #category : 'accessing' }
McmcSamplerMode >> timeMax: anObject [

	timeMax := anObject
]
