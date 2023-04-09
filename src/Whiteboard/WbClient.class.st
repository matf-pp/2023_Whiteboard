Class {
	#name : #WbClient,
	#superclass : #Object,
	#instVars : [
		'ip',
		'port',
		'clientSocket',
		'isRunning'
	],
	#category : #Whiteboard
}

{ #category : #initialization }
WbClient >> connect [
	| serverAddress |
	
	serverAddress := NetNameResolver addressForName: ip.
	clientSocket connectTo: serverAddress port: port waitForConnectionFor: 10.
	 
]

{ #category : #accessing }
WbClient >> getSocket [ 
^clientSocket 
]

{ #category : #initialization }
WbClient >> initialize [ 
	clientSocket := Socket newTCP.
	ip := 'localhost'.
	port := 12345.
]

{ #category : #accessing }
WbClient >> isRunning [
	^ isRunning 
]

{ #category : #accessing }
WbClient >> isRunning: aBoolean [
	isRunning := aBoolean 
]

{ #category : #initialization }
WbClient >> sendData: aData [
	clientSocket sendData: aData.
]

{ #category : #initialization }
WbClient >> setIp: aIp [
	ip := aIp
]

{ #category : #initialization }
WbClient >> setPort: aPort [
	port := aPort
]

{ #category : #initialization }
WbClient >> start [
	| serverAddress |
	isRunning := true.
	serverAddress := NetNameResolver addressForName: ip.
	clientSocket connectTo: serverAddress port: port waitForConnectionFor: 10.
	 
]

{ #category : #initialization }
WbClient >> stop [
	isRunning := false.
	 
]
