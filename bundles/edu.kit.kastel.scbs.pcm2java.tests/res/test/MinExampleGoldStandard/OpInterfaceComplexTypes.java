package aName.contracts.interfaces;

import java.lang.Iterable;
import aName.contracts.datatypes.CompTypeCollTypesPrimitive;
import aName.contracts.datatypes.CompTypeCollTypesComplex;
import aName.contracts.datatypes.CompTypeEmpty;
		
public interface OpInterfaceComplexTypes {
			
	void methodVoid(CompTypeCollTypesComplex paraCompType); 
	CompTypeCollTypesPrimitive methodCompType(Iterable<Iterable<CompTypeEmpty>> paraCollType); 
	Iterable<Integer> methodCollType(Iterable<Boolean> paraCollType); 

}