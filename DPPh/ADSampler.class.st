Class {
	#name : 'ADSampler',
	#superclass : 'SamplerMode',
	#category : 'DPPh',
	#package : 'DPPh'
}

{ #category : 'initialization' }
ADSampler >> initializeInitSample [

	| sample detSample nbTrials tol |
	sample := {  } asOrderedCollection.
	detSample := 0.
	nbTrials := 100.
	tol := 10 ** -9.

	1 to: nbTrials do: [ :i |
		detSample > tol ifTrue: [ ^ sample ].
		sample := randomState choice: n size: (randomState nextInteger: n + 1) replace: false.
		detSample := kernel determinantWithRows: sample andColumns: sample ].

	^ Error signal: 'After ' , nbTrials printString
		  , ' trials, no initial set s0 satisfies det Ls0 > '
		  , tol printString
]

{ #category : 'sample' }
ADSampler >> sample [

	| sample1 item detSample1 |
	self initializeForSampling.

	1 to: nbIter - 1 do: [ :i |
		randomState next < 0.5
			ifTrue: [
				sample1 := sample0 copy.
				item := randomState nextInteger: n.
				(sample1 includes: item)
					ifTrue: [ sample1 remove: item ]
					ifFalse: [ sample1 add: item ].

				detSample1 := kernel
					              determinantWithRows: sample1
					              andColumns: sample1.
				randomState next < (detSample1 / detSample0) ifTrue: [
					sample0 := sample1.
					detSample0 := detSample1.
					chain add: sample1 ] ]
			ifFalse: [ chain add: sample0 ].

		timeMax ifNotNil: [
			Time current - timeStart >= timeMax ifTrue: [ ^ chain ] ] ].

	^ chain
]
