Class {
	#name : 'AEDSampler',
	#superclass : 'McmcSamplerMode',
	#instVars : [
		'sample1',
		'indice',
		'randomElem',
		'addCondition',
		'exchangeCondition',
		'deleteCondition',
		'sample1Det'
	],
	#category : 'DPPh',
	#package : 'DPPh'
}

{ #category : 'adding' }
AEDSampler >> add [

	sample1 add: randomElem.
	sample1Det := kernel determinantWithRows: sample1 andColumns: sample1.
	randomState next < (sample1Det / sample0Det * (sample0Size + 1)
	 / (kernelSize - sample0Size))
		ifTrue: [
			sample0 := sample1.
			sample0Det := sample1Det.
			samplesChain add: sample1.
			sample0Size := sample0Size + 1 ]
		ifFalse: [ samplesChain add: sample0 ]
]

{ #category : 'deleting' }
AEDSampler >> delete [

	sample1 removeAt: indice.
	sample1Det := kernel determinantWithRows: sample1 andColumns: sample1.
	randomState next < (sample1Det / sample0Det * sample0Size
	 / (kernelSize - (sample0Size - 1)))
		ifTrue: [
			sample0 := sample1.
			sample0Det := sample1Det.
			samplesChain add: sample1.
			sample0Size := sample0Size - 1 ]
		ifFalse: [ samplesChain add: sample0 ]
]

{ #category : 'exchanging' }
AEDSampler >> exchange [

	sample1 removeAt: indice.
	sample1 add: randomElem.
	sample1Det := kernel determinantWithRows: sample1 andColumns: sample1.
	randomState next < (sample1Det / sample0Det)
		ifTrue: [
			sample0 := sample1.
			sample0Det := sample1Det.
			samplesChain add: sample1 ]
		ifFalse: [ samplesChain add: sample0 ]
]

{ #category : 'as yet unclassified' }
AEDSampler >> initSampleDraw: sampleSize [

	| intermediateSample |
	intermediateSample := randomState
		                      choice: 2 * kernelSize
		                      size: kernelSize
		                      replace: false.
	^ intermediateSample intersection: groundSet
]

{ #category : 'initialization' }
AEDSampler >> initializeConditionsWith: percent and: ratio [

	addCondition := percent < (0.5 * (1 - ratio ** 2)).
	exchangeCondition := 0.5 * (1 - ratio ** 2) <= percent
	                     & (percent < (0.5 * (1 - ratio))).
	deleteCondition := 0.5 * (1 - ratio) <= percent
	                   & (percent < (0.5 * (ratio ** 2 + (1 - ratio))))
]

{ #category : 'initialization' }
AEDSampler >> initializeForIteration [

	| groundSetCopy percent ratio |
	sample1 := sample0 copy.
	indice := randomState nextInteger:
		          (sample0Size = 0 | sample0Size isNil
			           ifFalse: [ sample0Size ]
			           ifTrue: [ kernelSize ]).
	groundSetCopy := groundSet copy.
	groundSetCopy removeAll: sample0.
	randomElem := groundSetCopy isEmpty
		              ifTrue: [ nil ]
		              ifFalse: [ groundSetCopy atRandom: randomState ].
	percent := randomState next.
	ratio := sample0Size / kernelSize.

	self initializeConditionsWith: percent and: ratio
]

{ #category : 'sample' }
AEDSampler >> sample [

	self initializeForSampling.

	1 to: nbIter - 1 do: [ :i |
		self initializeForIteration.

		addCondition ifTrue: [ self add ].

		exchangeCondition ifTrue: [ self exchange ].

		deleteCondition ifTrue: [ self delete ].

		addCondition | exchangeCondition | deleteCondition ifFalse: [
			samplesChain add: sample0 ].

		timeMax ifNotNil: [
			Time current - timeStart >= timeMax ifTrue: [ ^ samplesChain ] ] ].

	^ samplesChain
]
