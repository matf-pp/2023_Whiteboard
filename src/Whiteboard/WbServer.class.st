Class {
	#name : #WbServer,
	#superclass : #Object,
	#instVars : [
		'connectionSocket',
		'isRunning',
		'isRunningLock',
		'connectedClients',
		'clientsLock'
	],
	#category : #Whiteboard
}

{ #category : #accessing }
WbServer >> addClient: aClient [
	clientsLock critical: [ connectedClients add: aClient ]
]

{ #category : #accessing }
WbServer >> initialize [ 
	super initialize.
	isRunningLock := Mutex new.
	clientsLock := Mutex new.
	connectedClients := OrderedCollection new.
	self isRunning: false.
]

{ #category : #accessing }
WbServer >> interactOnConnection [
	| interactionSocket |
	interactionSocket := connectionSocket waitForAcceptFor: 1 ifTimedOut: [ ^self ].
	[ self interactUsing: interactionSocket  ] fork 
]

{ #category : #accessing }
WbServer >> interactUsing: interactionSocket [
	| receivedData |
	self addClient: interactionSocket .
	[ interactionSocket isConnected & self isRunning ] whileTrue: [ 
			receivedData := interactionSocket receiveDataTimeout: 5.
			receivedData ifNotEmpty: [ 
							clientsLock critical: [ 
							connectedClients do: [ :aClient |
							interactionSocket ~= aClient ifTrue: [ 
									aClient sendData: receivedData .
								 ].
							
						 ]
				 ]
				 ].

		 ].
	self removeClient: interactionSocket .
	interactionSocket closeAndDestroy .

	
]

{ #category : #accessing }
WbServer >> isRunning [
	^ isRunningLock critical: [ isRunning ]
]

{ #category : #accessing }
WbServer >> isRunning: aBoolean [
	^ isRunningLock critical: [ isRunning := aBoolean ]
]

{ #category : #accessing }
WbServer >> removeClient: aClient [
	clientsLock critical: [ connectedClients remove: aClient ifAbsent: [ ^self ] ]
]

{ #category : #accessing }
WbServer >> serve [
	[ [ self isRunning ]
		whileTrue: [ self interactOnConnection ]
	 ] ensure: [ connectionSocket closeAndDestroy ]
]

{ #category : #accessing }
WbServer >> start [
	isRunningLock critical: [ 
			self isRunning ifTrue: [ ^self ].
			self isRunning: true.
		 ].
	connectionSocket := Socket newTCP.
	connectionSocket listenOn: 12345 backlogSize: 10.
	[ self serve ] fork 
]

{ #category : #accessing }
WbServer >> stop [
	self isRunning: false
]
