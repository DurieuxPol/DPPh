Class {
	#name : 'ESampler',
	#superclass : 'SamplerMode',
	#category : 'DPPh',
	#package : 'DPPh'
}

{ #category : 'as yet unclassified' }
ESampler >> initSampleDraw: sampleSize [

	^ randomState choice: kernelSize size: sampleSize replace: false
]

{ #category : 'sample' }
ESampler >> sample [

	| sample1 sample1Det index t |
	self initializeForSampling.

	1 to: nbIter - 1 do: [ :i |
		randomState next < 0.5
			ifTrue: [
				sample1 := sample0 copy.
				index := randomState nextInteger: sample0Size.
				t := randomState
					     choice: (groundSet copy removeAll: sample0)
					     size: 1
					     replace: false.
				sample1 atRow: index put: t.
				sample1Det := kernel
					              determinantWithRows: sample1
					              andColumns: sample1.
				randomState next < (sample1Det / sample0Det) ifTrue: [
					sample0 := sample1.
					sample0Det := sample1Det.
					samplesChain add: sample1 ] ]
			ifFalse: [ samplesChain add: sample0 ].

		timeMax ifNotNil: [
			Time current - timeStart >= timeMax ifTrue: [ ^ samplesChain ] ] ].

	^ samplesChain
]
