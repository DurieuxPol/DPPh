Class {
	#name : 'AEDSampler',
	#superclass : 'SamplerMode',
	#instVars : [
		'groundSet',
		'n',
		'sample0',
		'detSample0',
		'sizeSample0',
		'chain',
		'timeStart',
		'sample1',
		'indice',
		'randomElem',
		'addCondition',
		'exchangeCondition',
		'deleteCondition'
	],
	#category : 'DPP',
	#package : 'DPP'
}

{ #category : 'adding' }
AEDSampler >> add [

	| detSample1 |
	sample1 add: randomElem.
	detSample1 := kernel determinantWithRows: sample1 andColumns: sample1.
	randomState next
	< (detSample1 / detSample0 * (sizeSample0 + 1) / (n - sizeSample0))
		ifTrue: [
			sample0 := sample1.
			detSample0 := detSample1.
			chain add: sample1.
			sizeSample0 := sizeSample0 + 1 ]
		ifFalse: [ chain add: sample0 ]
]

{ #category : 'random' }
AEDSampler >> choice: anInt size: size replace: aBoolean [
	"Selects size integers between 1 and anInt.
If aBoolean is true, it allows the same integer to be added multiple times"

	| result interval int |
	result := {  } asOrderedCollection.
	interval := 1 to: anInt.
	[ result size < size ] whileTrue: [
		int := interval atRandom.
		(result includes: int) not | aBoolean ifTrue: [ result add: int ] ].
	^ result
]

{ #category : 'deleting' }
AEDSampler >> delete [

	| detSample1 |
	sample1 removeAt: indice.
	detSample1 := kernel determinantWithRows: sample1 andColumns: sample1.
	randomState next
	< (detSample1 / detSample0 * sizeSample0 / (n - (sizeSample0 - 1)))
		ifTrue: [
			sample0 := sample1.
			detSample0 := detSample1.
			chain add: sample1.
			sizeSample0 := sizeSample0 - 1 ]
		ifFalse: [ chain add: sample0 ]
]

{ #category : 'exchanging' }
AEDSampler >> exchange [

	| detSample1 |
	sample1 removeAt: indice.
	sample1 add: randomElem.
	detSample1 := kernel determinantWithRows: sample1 andColumns: sample1.
	randomState next < (detSample1 / detSample0)
		ifTrue: [
			sample0 := sample1.
			detSample0 := detSample1.
			chain add: sample1 ]
		ifFalse: [ chain add: sample0 ]
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
		          (sizeSample0 ifNotNil: [ sizeSample0 ] ifNil: [ n ]).
	groundSetCopy := groundSet copy.
	groundSetCopy removeAll: sample0.
	randomElem := groundSetCopy atRandom: randomState.
	percent := randomState next.
	ratio := sizeSample0 / n.

	self initializeConditionsWith: percent and: ratio
]

{ #category : 'sample' }
AEDSampler >> initializeForSampling [

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
AEDSampler >> initializeInitSample [

	| sample detSample nbTrials tol t |
	n := kernel numberOfRows.
	groundSet := (1 to: n) asOrderedCollection.

	sample := {  } asOrderedCollection.
	detSample := 0.
	nbTrials := 100.
	tol := 10 ** -9.

	1 to: nbTrials do: [ :i |
		detSample > tol ifTrue: [ ^ sample ].
		t := self choice: 2 * n size: n replace: false.
		sample := t intersection: groundSet.
		detSample := kernel determinantWithRows: sample andColumns: sample ].

	^ Error signal: 'After ' , nbTrials printString
		  , ' trials, no initial set s0 satisfies det Ls0 > '
		  , tol printString
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
			chain add: sample0 ].

		timeMax ifNotNil: [
			Time current - timeStart >= timeMax ifTrue: [ ^ chain ] ] ].

	^ chain
]
