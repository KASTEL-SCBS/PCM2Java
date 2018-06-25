package aName.contracts.interfaces;

import java.lang.Iterable;
		
public interface OpInterfaceDiamond extends OpInterfaceInheritanceOne, OpInterfaceInheritanceTwo {
			
	Iterable<Object> methodDiamond(); 

}