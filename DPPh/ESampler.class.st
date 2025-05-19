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

{ #category : 'initialization' }
ESampler >> initializeForSampling [

	super initializeForSampling.
	samplesChain := PMMatrix zerosRows: nbIter cols: sample0Size.
	samplesChain atRow: 1 put: sample0
]

{ #category : 'sample' }
ESampler >> sample [

	| sample1 item sample1Det |
	self initializeForSampling.

	1 to: nbIter - 1 do: [ :i |
		randomState next < 0.5
			ifTrue: [
				sample1 := sample0 copy.
				item := randomState nextInteger: kernelSize.
				(sample1 includes: item)
					ifTrue: [ sample1 remove: item ]
					ifFalse: [ sample1 add: item ].

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
