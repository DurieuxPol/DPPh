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
AEDSamplerTest >> getCountOf: listOfCollections in: listOfSamples [

	^ listOfCollections collect: [ :col |
		  | listOfBooleans |
		  listOfBooleans := listOfSamples collect: [ :sampl |
			                    self sample: sampl includes: col ].
		  listOfBooleans sum: [ :elem |
			  elem
				  ifTrue: [ 1 ]
				  ifFalse: [ 0 ] ] ]
]

{ #category : 'testing' }
AEDSamplerTest >> sample: sample includes: aSet [
	"For the moment the set can only be either a doubleton or a singleton"

	^ aSet size = 2
		  ifTrue: [
		  (sample includes: aSet first) & (sample includes: aSet second) ]
		  ifFalse: [ sample includes: aSet ]
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
	observedData := self getCountOf: doubletons in: samples.
	observedDistribution := observedData / nbIter asFloat.

	criticalValue := chi
		                 criticalValueFor: theoricProbabilities
		                 and: observedDistribution.
	"criticalValue := chi
		                 criticalValue2For: theoricProbabilities
		                 and: observedData."
	degreesOfFreedom := nbDoubleton - 1.
	pvalue := chi pvalueFor: criticalValue and: degreesOfFreedom.

	self assert: pvalue > tolerance
]

{ #category : 'tests' }
AEDSamplerTest >> testSingletonAdequation [

	| theoricProbabilities observedData observedDistribution criticalValue degreesOfFreedom pvalue singletons |
	theoricProbabilities := dpp kernel principalDiagonal.
	singletons := (1 to: n) collect: [ :num |
		              { num } asSet ].
	observedData := self getCountOf: singletons in: samples.
	observedDistribution := observedData / nbIter asFloat.

	criticalValue := chi
		                 criticalValueFor: theoricProbabilities
		                 and: observedDistribution.
	"criticalValue := chi
		                 criticalValue2For: theoricProbabilities
		                 and: observedData."
	degreesOfFreedom := n - 1.
	pvalue := chi pvalueFor: criticalValue and: degreesOfFreedom.

	self assert: pvalue > tolerance
]
