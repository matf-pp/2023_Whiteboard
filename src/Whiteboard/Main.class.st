Class {
	#name : #Main,
	#superclass : #Object,
	#instVars : [
		'whiteboard',
		'm',
		'draw',
		'erase',
		'window'
	],
	#category : #Whiteboard
}

{ #category : #initialization }
Main >> initialize [ 

	whiteboard := Whiteboard extent:800@600 depth:32.
	whiteboard initClient.
	
	whiteboard getCanvas fillRectangle: (0@0 extent:800@600) color: Color white. 

	m := whiteboard asMorph.
	whiteboard morph: m.
	whiteboard shouldDraw.
	whiteboard setColor: (Color black). 

	m on: #mouseMove send: #drawLine: to: whiteboard.
	m on: #mouseUp send: #stopDrawing: to: whiteboard.
	m on: #mouseDown send: #startDrawing: to: whiteboard.
	
	
	draw := Morph new
	extent: 80@30 ;
	color: Color black.
	
	draw addMorph: (TextMorph new
	contents: 'Pisi';
	color: Color white;
	center: draw center).
	
	erase := Morph new
	extent: 80@30 ;
	color: Color white;
	position:0@30.
	
	erase addMorph: (TextMorph new
	contents: 'Brisi';
	color: Color black;
	center: erase center).
	
	draw borderStyle: (BorderStyle simple 
						width: 1;
						color: Color black).
		erase borderStyle: (BorderStyle simple 
						width: 1;
						color: Color black).
	
	m addMorph: draw .
	
	m addMorph: erase .
	
	draw on: #mouseDown send: #pencil: to: whiteboard.
	erase on: #mouseDown send: #eraser: to: whiteboard.
	
	
]

{ #category : #initialization }
Main >> setIp: aIp [
	whiteboard getClient setIp: aIp
]

{ #category : #initialization }
Main >> setPort: aPort [
	whiteboard getClient setPort: aPort
]

{ #category : #accessing }
Main >> start [
	whiteboard startClient.
	window := WbWindow new.
	window setWb: whiteboard.
	m position: (25@25).
	window addMorph: m.
	window openModal.
	window isResizeable: false.
]
