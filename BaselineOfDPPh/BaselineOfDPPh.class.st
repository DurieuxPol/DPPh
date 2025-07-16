Class {
	#name : 'BaselineOfDPPh',
	#superclass : 'Object',
	#category : 'BaselineOfDPPh',
	#package : 'BaselineOfDPPh'
}

{ #category : 'baselines' }
BaselineOfDPPh >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'DPPh';
			package: 'DPPh-Tests' with: [ spec requires: #( 'DPPh' ) ] ]
]
