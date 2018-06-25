package aName.components.BasicComponentFull;

import aName.contracts.interfaces.OpInterfaceInheritanceOne;
import java.lang.Iterable;
import aName.contracts.interfaces.OpInterfaceInheritanceMult;
import aName.contracts.datatypes.CompTypeAllPrimitives;
import aName.contracts.datatypes.CompTypeCollTypesPrimitive;
import aName.contracts.interfaces.OpInterfaceEmpty;
import aName.contracts.datatypes.CompTypeCollTypesComplex;
import aName.contracts.datatypes.CompTypeEmpty;
		
public class BasicComponentFull implements OpInterfaceInheritanceMult {
	
	private OpInterfaceInheritanceOne opInterfaceInheritanceOne;
	private OpInterfaceEmpty opInterfaceEmpty;
	
	public BasicComponentFull(OpInterfaceInheritanceOne opInterfaceInheritanceOne, OpInterfaceEmpty opInterfaceEmpty) {
		// TODO: implement and verify auto-generated constructor.
	    this.opInterfaceInheritanceOne = opInterfaceInheritanceOne;
	    this.opInterfaceEmpty = opInterfaceEmpty;
	}
	
	public void methodInheritanceOne(int paraInt){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public CompTypeAllPrimitives methodInheritanceOneA(){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public Iterable<String> paraInheritanceOneB(){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public void methodEmpty(){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public boolean methodBoolean(boolean paraBoolean){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public byte methodByte(byte paraByte){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public char methodCharacter(char paraCharacter){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public int methodInteger(int paraInteger){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public long methodLong(long paraLong){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public double methodDouble(double paraDouble){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public String methodString(String paraString){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public void methodVoid(CompTypeCollTypesComplex paraCompType){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public CompTypeCollTypesPrimitive methodCompType(Iterable<Iterable<CompTypeEmpty>> paraCollType){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
	public Iterable<Integer> methodCollType(Iterable<Boolean> paraCollType){
		// TODO: implement and verify auto-generated method stub
		throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}
	
}