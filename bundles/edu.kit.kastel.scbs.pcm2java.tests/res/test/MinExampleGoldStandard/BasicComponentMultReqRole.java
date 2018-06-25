package aName.components.BasicComponentMultReqRole;

import aName.contracts.interfaces.OpInterfacePrimitiveTypes;
import aName.contracts.interfaces.OpInterfaceInheritanceOne;
import aName.contracts.interfaces.OpInterfaceFull;
		
public class BasicComponentMultReqRole {
	
	private OpInterfacePrimitiveTypes opInterfacePrimitiveTypes;
	private OpInterfaceInheritanceOne opInterfaceInheritanceOne;
	private OpInterfaceFull opInterfaceFull;
	
	public BasicComponentMultReqRole(OpInterfacePrimitiveTypes opInterfacePrimitiveTypes, OpInterfaceInheritanceOne opInterfaceInheritanceOne, OpInterfaceFull opInterfaceFull) {
		// TODO: implement and verify auto-generated constructor.
	    this.opInterfacePrimitiveTypes = opInterfacePrimitiveTypes;
	    this.opInterfaceInheritanceOne = opInterfaceInheritanceOne;
	    this.opInterfaceFull = opInterfaceFull;
	}
	
}