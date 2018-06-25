package aName.contracts.interfaces;

import java.lang.Iterable;
import aName.contracts.datatypes.CompTypeFull;
import aName.contracts.datatypes.CompTypeEmpty;
		
public interface OpInterfaceFull extends OpInterfaceInheritanceOne, OpInterfaceEmpty {
			
	void methodEmpty(); 
	int methodPrimitiveReturn(Iterable<Iterable<Iterable<CompTypeEmpty>>> paraCollType, CompTypeFull paraCompType); 
	Iterable<Iterable<Iterable<CompTypeEmpty>>> methodCollTypeReturn(int paraInt); 
	CompTypeFull methodcompTypeReturn(); 

}