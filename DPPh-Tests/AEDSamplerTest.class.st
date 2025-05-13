Class {
	#name : 'AEDSamplerTest',
	#superclass : 'TestCase',
	#instVars : [
		'dpp',
		'samples',
		'n',
		'gen',
		'nbIter',
		'tolerance',
		'chi'
	],
	#category : 'DPPh-Tests',
	#package : 'DPPh-Tests'
}

{ #category : 'accessing' }
AEDSamplerTest >> getCountOfDoubletons: listOfDoubletons in: listOfSamples [

	^ listOfDoubletons collect: [ :doubl |
		  | listOfBooleans |
		  listOfBooleans := listOfSamples collect: [ :sampl |
			                    (sampl includes: doubl first)
			                    & (sampl includes: doubl second) ].
		  listOfBooleans sum: [ :elem |
			  elem
				  ifTrue: [ 1 ]
				  ifFalse: [ 0 ] ] ]
]

{ #category : 'accessing' }
AEDSamplerTest >> getCountOfSingletons: listOfSingletons in: listOfSamples [

	^ listOfSingletons collect: [ :singl |
		  | listOfBooleans |
		  listOfBooleans := listOfSamples collect: [ :sampl |
			                    sampl includes: singl ].
		  listOfBooleans sum: [ :elem |
			  elem
				  ifTrue: [ 1 ]
				  ifFalse: [ 0 ] ] ]
]

{ #category : 'running' }
AEDSamplerTest >> setUp [

	| matrixForEigVecs eigvecs eigvals rank |
	super setUp.

	chi := ChisquareEvaluation new.

	rank := 6.
	n := 10.

	nbIter := 1000.
	gen := Random new.
	tolerance := 0.05.

	matrixForEigVecs := PMMatrix
		                    rows: n
		                    columns: rank
		                    random: 1
		                    generator: gen.

	eigvecs := matrixForEigVecs orthogonalize.

	eigvals := PMVector new: rank random: 1 generator: gen.

	dpp := FiniteDPP
		       correlationWithEigenValues: eigvals
		       andVectors: eigvecs.
	dpp sampleMcmc: AEDSampler withArgs: {
			nil.
			nil.
			nbIter.
			nil }.
	samples := dpp listOfSamples
]

{ #category : 'tests' }
AEDSamplerTest >> testDoubletonAdequation [

	| nbDoubleton doubletons doubleton theoricProbabilities observedData observedDistribution criticalValue degreesOfFreedom pvalue |
	nbDoubleton := 10.

	doubletons := OrderedCollection new.
	nbDoubleton timesRepeat: [
		doubleton := gen choice: n size: 2 replace: false.
		doubletons add: doubleton ].

	theoricProbabilities := doubletons collect: [ :d |
		                        dpp kernel
			                        determinantWithRows: d
			                        andColumns: d ].
	observedData := self getCountOfDoubletons: doubletons in: samples.
	observedDistribution := observedData / nbIter asFloat.

	criticalValue := chi
		                 criticalValueFor: theoricProbabilities
		                 and: observedDistribution.
	degreesOfFreedom := nbDoubleton - 1.
	pvalue := chi pvalueFor: criticalValue and: degreesOfFreedom.

	self assert: pvalue > tolerance
]

{ #category : 'tests' }
AEDSamplerTest >> testDoubletonAdequation2 [

	| nbDoubleton doubletons doubleton theoricProbabilities observedData criticalValue degreesOfFreedom pvalue |
	nbDoubleton := 10.

	doubletons := OrderedCollection new.
	nbDoubleton timesRepeat: [
		doubleton := gen choice: n size: 2 replace: false.
		doubletons add: doubleton ].

	theoricProbabilities := doubletons collect: [ :d |
		                        dpp kernel
			                        determinantWithRows: d
			                        andColumns: d ].
	observedData := self getCountOfDoubletons: doubletons in: samples.

	criticalValue := chi
		                 criticalValue2For: theoricProbabilities
		                 and: observedData.
	degreesOfFreedom := nbDoubleton - 1.
	pvalue := chi pvalueFor: criticalValue and: degreesOfFreedom.

	self assert: pvalue > tolerance
]

{ #category : 'tests' }
AEDSamplerTest >> testSingletonAdequation [

	| theoricProbabilities observedData observedDistribution criticalValue degreesOfFreedom pvalue |

	theoricProbabilities := dpp kernel principalDiagonal .
	observedData :=  self getCountOfSingletons: (1 to: n) in: samples.
	observedDistribution := observedData / nbIter asFloat.

	criticalValue := chi
		                 criticalValueFor: theoricProbabilities
		                 and: observedDistribution.
	degreesOfFreedom := 10 - 1.
	pvalue := chi pvalueFor: criticalValue and: degreesOfFreedom.

	self assert: pvalue > tolerance
]

{ #category : 'tests' }
AEDSamplerTest >> testSingletonAdequation2 [

	| theoricProbabilities observedData criticalValue degreesOfFreedom pvalue |
	theoricProbabilities := dpp kernel principalDiagonal / dpp kernel tr.
	observedData := self getCountOfSingletons: (1 to: n) in: samples.

	criticalValue := chi
		                 criticalValue2For: theoricProbabilities
		                 and: observedData.
	degreesOfFreedom := n - 1.
	pvalue := chi pvalueFor: criticalValue and: degreesOfFreedom.

	self assert: pvalue > tolerance
]
