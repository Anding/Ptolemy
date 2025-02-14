: STARTUP (# STARTUP ) 
			(* CONNECT-MOUNT ) CONNECT-MOUNT 
			(* CONNECT-CAMERA ) CONNECT-CAMERA 
			CONNECT-FOCUSER
			CONNECT-FILTERWHEEL
			CONNECT-LIGHTBOX
;
			
CONNECT-MOUNT {
			(* SET-IP-ADDRESS ) SET-IP-ADDRESS 
			OPEN-SOCKET
			TEST-STATUS
			} ERROR-HANDLER.CONNECT-MOUNT
			

EXPOSE-IMAGE {
			! ERROR-HANDLER.EXPOSE-IMAGE
			WAIT-FOR-CAMERA-READY
			START-EXPOSURE
			DOWNLOAD-IMAGE
}

SEQUENCE {
			! ERROR-HANDLER.SEQUENCE
			(* STATUS-CHECK ) STATUS-CHECK						
			CASE 
				1 OF (* ? REFOCUS ) REFOCUS ENDOF			
				2 OF (* ? MERIDIAN-FLIP ) MERIDIAN-FLIP ENDOF	
				3 OF (* ? NEXT-EXPOSURE ) NEXT-EXPOSURE ENDOF	
			ENDCASE
			}
			(* \ repeat )

}
			
\ this will be a way of notating Forth code
\ (* is an immediate word that builds a tree structure	
\ in execution - runtime - (* updates the tree structure - depending on debug status, updates the diagram
\ this cannot be done in the Forth Dictionary due to compilation-time building
\ use a specialized-buffer
\ 
\ use a stack to hold the current tree position in the buffer
\ n4 n3 n2 n1 4  TOS has to hold the depth

\ node descriptor (each or 0)
\ pointer to up node
\ pointer to back node
\ pointer to next node
\ pointer to down node 
\ counted string